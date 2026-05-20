import 'dart:async';
import 'package:citi_guide/screens/map/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  final double longitudeDetected;
  final double latitudeDetected;
  const MapPage({
    super.key,
    required this.longitudeDetected,
    required this.latitudeDetected,
  });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  final Location _locationController = Location();

  late LatLng _pDestination;
  LatLng? _currentP;

  Map<PolylineId, Polyline> polylines = {};
  bool _followMe = false;

  bool _polylineFetching = false;
  Timer? _polylineTimer;
  StreamSubscription<LocationData>? _locationSub;
  bool _firstLocationReceived = false;

  @override
  void initState() {
    super.initState();
    // Status bar transparent karo — full screen effect ke liye
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    _pDestination = LatLng(widget.latitudeDetected, widget.longitudeDetected);
    getLocationUpdates();
  }

  @override
  void dispose() {
    _locationSub?.cancel();
    _polylineTimer?.cancel();
    super.dispose();
  }

  // ─── Camera: destination ──────────────────────────────────────────────────

  Future<void> _cameraToDestination() async {
    if (!_mapController.isCompleted) return;
    final controller = await _mapController.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _pDestination, zoom: 15),
      ),
    );
  }

  // ─── Camera: current location follow ─────────────────────────────────────

  Future<void> _cameraToCurrentPosition(LatLng pos) async {
    if (!_followMe) return;
    if (!_mapController.isCompleted) return;
    final controller = await _mapController.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: pos, zoom: 17),
      ),
    );
  }

  // ─── Camera: Overview ─────────────────────────────────────────────────────

  Future<void> _showOverview() async {
    if (_currentP == null) return;
    if (!_mapController.isCompleted) return;
    final controller = await _mapController.future;

    final minLat = _currentP!.latitude < _pDestination.latitude
        ? _currentP!.latitude
        : _pDestination.latitude;
    final minLng = _currentP!.longitude < _pDestination.longitude
        ? _currentP!.longitude
        : _pDestination.longitude;
    final maxLat = _currentP!.latitude > _pDestination.latitude
        ? _currentP!.latitude
        : _pDestination.latitude;
    final maxLng = _currentP!.longitude > _pDestination.longitude
        ? _currentP!.longitude
        : _pDestination.longitude;

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    if (mounted) setState(() => _followMe = false);
    await controller.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 80),
    );
  }

  // ─── Location Updates ─────────────────────────────────────────────────────

  Future<void> getLocationUpdates() async {
    bool serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted =
        await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    _locationSub = _locationController.onLocationChanged.listen(
      (LocationData currentLocation) {
        if (!mounted) return;
        if (currentLocation.latitude == null ||
            currentLocation.longitude == null) return;

        final newPos =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);

        setState(() => _currentP = newPos);

        if (!_firstLocationReceived) {
          _firstLocationReceived = true;
          _fetchPolylineNow();
        }

        _cameraToCurrentPosition(newPos);
      },
    );
  }

  // ─── Polyline: immediate fetch ────────────────────────────────────────────

  Future<void> _fetchPolylineNow() async {
    if (_polylineFetching || !mounted) return;
    _polylineFetching = true;
    final coords = await getPolylinePoints();
    _polylineFetching = false;
    if (mounted) generatePolylineFromPoints(coords);
    _startPolylineTimer();
  }

  // ─── Polyline: 15s periodic refresh ──────────────────────────────────────

  void _startPolylineTimer() {
    _polylineTimer?.cancel();
    _polylineTimer = Timer.periodic(const Duration(seconds: 15), (_) async {
      if (!mounted || _polylineFetching) return;
      _polylineFetching = true;
      final coords = await getPolylinePoints();
      _polylineFetching = false;
      if (mounted) generatePolylineFromPoints(coords);
    });
  }

  // ─── Polyline fetch ───────────────────────────────────────────────────────

  Future<List<LatLng>> getPolylinePoints() async {
    if (_currentP == null) return [];

    final polylinePoints = PolylinePoints();
    final result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: GOOGLE_MAPS_API_KEY,
      request: PolylineRequest(
        origin: PointLatLng(_currentP!.latitude, _currentP!.longitude),
        destination:
            PointLatLng(_pDestination.latitude, _pDestination.longitude),
        mode: TravelMode.driving,
        wayPoints: [],
      ),
    );

    if (result.points.isNotEmpty) {
      return result.points
          .map((p) => LatLng(p.latitude, p.longitude))
          .toList();
    }

    debugPrint('Polyline error: ${result.errorMessage}');
    return [];
  }

  void generatePolylineFromPoints(List<LatLng> coords) {
    if (coords.isEmpty || !mounted) return;
    const id = PolylineId("route");
    setState(() {
      polylines[id] = Polyline(
        polylineId: id,
        color: Colors.blue,
        points: coords,
        width: 5,
      );
    });
  }

  // ─── Reusable floating button style ──────────────────────────────────────

  Widget _floatingCircleButton({
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = Colors.black87,
    Color bgColor = Colors.white,
    double size = 40,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor, size: size * 0.5),
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      // ✅ extendBodyBehindAppBar — map status bar ke peeche bhi jaye
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // ── Full screen Google Map ───────────────────────────────
          GoogleMap(
            onMapCreated: (controller) {
              if (!_mapController.isCompleted) {
                _mapController.complete(controller);
              }
              _cameraToDestination();
            },
            initialCameraPosition: CameraPosition(
              target: _pDestination,
              zoom: 15,
            ),
            onCameraMoveStarted: () {
              if (_followMe && mounted) setState(() => _followMe = false);
            },
            // ✅ Map ke controls apne aap neeche FABs se door rahein
            padding: EdgeInsets.only(top: topPadding + 60, bottom: 120),
            markers: {
              if (_currentP != null)
                Marker(
                  markerId: const MarkerId("_currentLocation"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueBlue),
                  position: _currentP!,
                  infoWindow: const InfoWindow(title: "Aap yahan hain"),
                ),
              Marker(
                markerId: const MarkerId("_destinationLocation"),
                icon: BitmapDescriptor.defaultMarker,
                position: _pDestination,
                infoWindow: const InfoWindow(title: "Destination"),
              ),
            },
            polylines: Set<Polyline>.of(polylines.values),
          ),

          // ── Top bar: back button + title ─────────────────────────
          Positioned(
            top: topPadding + 10,
            left: 12,
            right: 12,
            child: Row(
              children: [
                // Back button
                _floatingCircleButton(
                  icon: Icons.arrow_back,
                  onTap: () => Navigator.pop(context),
                  size: 42,
                ),
                const SizedBox(width: 10),
                // Title pill
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.place, color: Colors.red, size: 18),
                        SizedBox(width: 6),
                        Text(
                          "Destination",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Right side FABs ───────────────────────────────────────
          Positioned(
            right: 12,
            bottom: 40,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Overview
                _floatingCircleButton(
                  icon: Icons.zoom_out_map,
                  onTap: _showOverview,
                  size: 44,
                ),
                const SizedBox(height: 10),

                // Destination
                _floatingCircleButton(
                  icon: Icons.place,
                  onTap: _cameraToDestination,
                  iconColor: Colors.red,
                  size: 44,
                ),
                const SizedBox(height: 10),

                // Follow Me
                GestureDetector(
                  onTap: () {
                    setState(() => _followMe = true);
                    if (_currentP != null) {
                      _cameraToCurrentPosition(_currentP!);
                    }
                  },
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: _followMe ? Colors.blue : Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      _followMe ? Icons.navigation : Icons.navigation_outlined,
                      color: _followMe ? Colors.white : Colors.black87,
                      size: 26,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}