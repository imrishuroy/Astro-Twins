import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final bool isEnabled;

  const BottomNavButton({
    Key? key,
    required this.onTap,
    required this.label,
    this.isEnabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Padding(
    //   padding: const EdgeInsets.symmetric(
    //     horizontal: 20.0,
    //     vertical: 20.0,
    //   ),
    //   child:

    return SizedBox(
      //height: double.infinity,
      width: double.infinity,
      child: GestureDetector(
        onTap: isEnabled ? onTap : null,
        child: Container(
          height: 54.0,
          width: 100.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40.0),
            color:
                isEnabled ? const Color(0xff2588E7) : const Color(0xffD9DBE2),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const Icon(
                  FontAwesomeIcons.arrowRight,
                  color: Colors.white,
                  size: 20.0,
                )
              ],
            ),
          ),
        ),
        // ),
      ),
    );
  }
}
