# CitiGuide 🗺️

**CitiGuide** is a comprehensive mobile application built with Flutter that helps users explore, discover, and track renowned landmarks and destinations within Pakistani cities. The app offers a seamless experience with user authentication, advanced location search, interactive maps, and admin features for managing destinations.

---

## 🌟 Features

### 👤 User Features
- **User Authentication**: Secure sign-in and signup with Firebase Authentication
- **Profile Management**: Create and manage user profiles with custom avatars
- **Destination Discovery**: Browse and search landmarks by city and category
- **Save Favorites**: Bookmark and save favorite destinations for quick access
- **Google Maps Integration**: Real-time location tracking and navigation
- **Category-Based Search**: Filter destinations by interests (Foodie Finds, Peaceful Corners, Insta Worthy, Geek Haven, City Beats, Culture Trails)
- **City Exploration**: Discover destinations across major Pakistani cities
- **Distance Tracking**: View distance information for each location

### 🔐 Admin Features
- **Destination Management**: Add, edit, and delete landmark entries
- **City Management**: Manage city information and categories
- **Dashboard Analytics**: View statistics on destinations, users, and cities
- **Batch Operations**: Quick actions for managing multiple entries

### 🎨 UI/UX Features
- **Responsive Design**: Fully responsive interface optimized for all screen sizes
- **SafeArea Implementation**: Proper handling of notches and status bars
- **Smooth Animations**: Elegant transitions and loading states
- **Professional Color Scheme**: Orange/red gradient theme with warm cream backgrounds
- **Native Splash Screen**: Custom white splash screen with launcher icon

---

## 🛠️ Technology Stack

### Frontend
- **Framework**: Flutter 3.2.4+
- **Language**: Dart
- **UI Libraries**: 
  - google_nav_bar (Bottom Navigation)
  - animated_splash_screen

### Backend & Services
- **Authentication**: Firebase Authentication
- **Database**: Cloud Firestore (Real-time)
- **Storage**: Firebase Cloud Storage
- **Maps**: Google Maps Flutter SDK
- **Location**: Location Services & Geolocation

### Additional Packages
- **google_sign_in**: OAuth authentication
- **image_picker**: Image selection from device
- **path_provider**: File system access
- **flutter_polyline_points**: Route polyline rendering

---

## 📋 Requirements

- Flutter SDK: `>=3.2.4 <4.0.0`
- Android: API 21+
- iOS: 11.0+
- Google Account (for Maps API)
- Firebase Project

---

## 🚀 Getting Started

### 1. Clone the Repository
```bash
git clone https://github.com/mahnoor643/CitiGuideFlutterApplication.git
cd CitiGuideFlutterApplication
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Configure API Keys

#### Google Maps API
1. Create `local.properties` file in project root:
```properties
GOOGLE_MAPS_API_KEY=YOUR_API_KEY_HERE
```

2. Update `android/app/build.gradle`:
```gradle
def localProperties = new Properties()
def localPropertiesFile = rootProject.file('local.properties')
if (localPropertiesFile.exists()) {
    localPropertiesFile.withInputStream { stream ->
        localProperties.load(stream)
    }
}

def googleMapsApiKey = localProperties.getProperty('GOOGLE_MAPS_API_KEY', '')
manifestPlaceholders = [googleMapsApiKey: googleMapsApiKey]
```

3. Update `android/app/src/main/AndroidManifest.xml`:
```xml
<meta-data 
    android:name="com.google.android.geo.API_KEY"
    android:value="${googleMapsApiKey}"/>
```

#### Firebase Setup
1. Create Firebase Project at https://console.firebase.google.com
2. Download `google-services.json` and place in `android/app/`
3. Configure Firestore security rules
4. Enable Authentication methods (Email/Password, Google Sign-In)

### 4. Run the App
```bash
flutter clean
flutter pub get
flutter run
```

---

## 🔐 Security Best Practices

### API Key Protection
- ✅ Store API keys in `local.properties` (not committed to git)
- ✅ Add `.gitignore` entry: `local.properties`
- ✅ Restrict API keys in Google Cloud Console:
  - Android app restrictions (package + SHA-1)
  - API restrictions (Maps SDK only)
- ✅ Never hardcode keys in source files

### Firebase Security
- ✅ Use Firebase Authentication for user management
- ✅ Implement Firestore security rules
- ✅ Enable read-only access where appropriate
- ✅ Use service accounts for backend operations

---

## 📱 App Screens

| Screen | Purpose |
|--------|---------|
| **Login/SignUp** | User authentication |
| **Dashboard** | Home feed with destinations |
| **Cities** | Browse all cities with filtering |
| **CityDestinations** | View locations in selected city |
| **DestinationDetails** | Full destination info + map |
| **SavedPlaces** | User's bookmarked destinations |
| **Search** | Global destination search |
| **Profile** | User account management |
| **Admin Panel** | Destination & city management |

---

## 🎨 Design

- **Color Scheme**: Orange/Red gradient (#E54000, #D76E00)
- **Background**: Warm cream (#fbf8f3)
- **Typography**: Poppins font family
- **Responsive**: Adaptive layouts for all screen sizes
- **Icons**: Material Design + Custom assets

---

## 📹 Demo & Preview

### App Interface
![CitiGuide UI](https://github.com/mahnoor643/CitiGuideFlutterApplication/assets/117991270/86246af4-f174-4b45-93d6-b49bf85e5bd2)

### Video Walkthrough

For a detailed walkthrough of CitiGuide features and functionality, watch the demo:

📽️ **LinkedIn Demo**: [CitiGuide - Flutter Firebase Mobile App Development](https://www.linkedin.com/posts/mahnoor-tariq-803176253_flutter-firebase-mobileappdevelopment-activity-7199030259915075586-SeXP?utm_source=share&utm_medium=member_android)

---

## 👥 Developer

**Mahnoor Tariq**
- Firebase & Google Maps Integration
- UI/UX Design & Implementation

---

## 🤝 Support & Contact

For issues, suggestions, or contributions:
- **Email**: mahnoort643@gmail.com
- **GitHub Issues**: [Create an issue](https://github.com/mahnoor643/CitiGuideFlutterApplication/issues)
- **LinkedIn**: [Mahnoor Tariq](https://www.linkedin.com/in/mahnoor-tariq-803176253/)

---

**Built with ❤️ using Flutter | Powered by Firebase & Google Maps**