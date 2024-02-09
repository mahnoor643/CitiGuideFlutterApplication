import 'package:citi_guide/Constants/constants.dart';
import 'package:flutter/material.dart';

class SearchSuggestions extends StatelessWidget {
  final String place;
  const SearchSuggestions({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.5, color: Constants.greyTextColor),
        ),
      ),
      child: Row(
        children: [
          Text(
            place,
            style: TextStyle(
              color: Constants.greyTextColor,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.arrow_outward_sharp,
            color: Constants.greyTextColor,
          )
        ],
      ),
    );
  }
}
