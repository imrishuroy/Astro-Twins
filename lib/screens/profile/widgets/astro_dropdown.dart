import 'package:astro_twins/constants/constants.dart';
import 'package:flutter/material.dart';

final textFieldBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8.0),
  borderSide: BorderSide(color: Colors.grey.shade300, width: 1.8),
);

class AstroDropDown extends StatelessWidget {
  final Function(String? value) onChanged;
  final String? selectValue;

  const AstroDropDown({
    Key? key,
    required this.onChanged,
    required this.selectValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      builder: (FormFieldState<String> _) {
        return InputDecorator(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 22.0, 10.0),
            // labelStyle: textStyle,
            // errorStyle: TextStyle(
            //     color: Colors.redAccent,
            //     fontSize: 16.0),
            focusedBorder: textFieldBorder,
            enabledBorder: textFieldBorder,
            disabledBorder: textFieldBorder,
            hintText: 'Please select astro',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.8),
            ),
          ),
          isEmpty: selectValue == '',
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectValue,
              // state.astro,
              isDense: true,
              icon: const Icon(Icons.expand_more),
              onChanged: onChanged,

              // (String? newValue) {
              //   if (newValue != null) {
              //     _profileCubit.astroChange(newValue);
              //   }
              // },
              items: Contants.astro.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
