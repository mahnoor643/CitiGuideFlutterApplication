import 'dart:ui';

import 'package:citi_guide/Constants/constants.dart';
import 'package:flutter/material.dart';

class CityImgCard extends StatelessWidget {
  final double Widthcard;
  final double ImgHeight;
  final double OpacityHeight;
  final double OpacityAboveRemainingHeightForMargin;
  final Widget firstOpacityDivRow;
  final Widget secondOpacityDivRow;
  final String cityImg;

  const CityImgCard({
    super.key,
    required this.Widthcard,
    required this.ImgHeight,
    required this.OpacityHeight,
    required this.firstOpacityDivRow,
    required this.secondOpacityDivRow,
    required this.OpacityAboveRemainingHeightForMargin, required this.cityImg,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Colors.transparent,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                cityImg,
                width: Widthcard,
                height: ImgHeight,
                fit: BoxFit.cover,
                
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin:
                    EdgeInsets.only(top: OpacityAboveRemainingHeightForMargin),
                width: Widthcard,
                height: OpacityHeight,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      color: Color.fromARGB(255, 134, 132, 132).withOpacity(0.4),
                      child: Column(
                        children: [
                          firstOpacityDivRow,
                          secondOpacityDivRow,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
