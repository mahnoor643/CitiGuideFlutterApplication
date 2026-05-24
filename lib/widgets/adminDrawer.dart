import 'package:citi_guide/Constants/constants.dart';
import 'package:flutter/material.dart';

class AdminDrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isRed;

  const AdminDrawerItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isRed = false, // Default value yahan assign hogi
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isRed
              ? Colors.red.withOpacity(0.1)
              : Constants.OrangeColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: isRed ? Colors.red : Constants.OrangeColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isRed ? Colors.red : Colors.black87,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: Colors.grey.shade400,
      ),
    );
  }
}