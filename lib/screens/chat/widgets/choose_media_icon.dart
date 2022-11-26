import 'package:flutter/material.dart';

class ChooseMediaIcon extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final IconData icon;

  const ChooseMediaIcon({
    Key? key,
    required this.onTap,
    required this.label,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xffED462F),
            radius: 26.0,
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
