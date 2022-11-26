import 'package:flutter/material.dart';

class BirthFields extends StatelessWidget {
  final String? text;
  final String hintText;
  final VoidCallback onTap;
  final bool isPlaceField;

  final Widget icon;
  const BirthFields({
    Key? key,
    this.text,
    required this.hintText,
    required this.onTap,
    required this.icon,
    this.isPlaceField = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 49.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.8,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              text ?? hintText,
              style: TextStyle(
                fontSize: 15.5,
                color: text != null ? Colors.black : Colors.grey.shade400,
              ),
            ),
          ),
          isPlaceField
              ? icon
              : Padding(
                  padding: const EdgeInsets.only(right: 7.0),
                  child: IconButton(
                    onPressed: onTap,
                    icon: icon,
                  ),
                )
        ],
      ),
    );
  }
}










// import 'package:flutter/material.dart';

// class BirthFields extends StatelessWidget {
//   final String hintText;
//   final Widget suffixIcon;
//   final VoidCallback onTap;

//   const BirthFields({
//     Key? key,
//     required this.hintText,
//     required this.suffixIcon,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       //enabled: false,
//       decoration: InputDecoration(
//         //suffixIcon: suffixIcon,
//         suffixIcon: GestureDetector(
//           onTap: onTap,
//           child: suffixIcon,
//         ),

//         //contentPadding: const EdgeInsets.all(10),
//         contentPadding: const EdgeInsets.only(left: 15.0),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.0),
//           borderSide: BorderSide(
//             color: Colors.grey.shade300,
//             width: 1.8,
//           ),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.0),
//           borderSide: BorderSide(
//             color: Colors.grey.shade300,
//             width: 1.8,
//           ),
//         ),
//         hintText: hintText,
//       ),
//     );
//   }
// }
