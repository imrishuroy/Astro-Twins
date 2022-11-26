import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/constants/constants.dart';

class ChooseGender extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final String imageUrl;
  final bool isSelected;

  const ChooseGender({
    Key? key,
    required this.label,
    required this.onTap,
    required this.imageUrl,
    this.isSelected = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80.0,
        width: 80.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: isSelected ? Contants.primaryColor : Colors.grey.shade300,
            width: 1.4,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              imageUrl,
              height: 25.0,
              width: 25.0,
            ),
            const SizedBox(height: 10.0),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
