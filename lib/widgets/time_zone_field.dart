import 'package:astro_twins/constants/constants.dart';
import 'package:flutter/material.dart';

final _border = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8.0),
  borderSide: BorderSide(color: Colors.grey.shade300, width: 1.8),
);

class TimeZoneField extends StatelessWidget {
  final String? timezone;
  final Function(String?)? onChanged;

  const TimeZoneField({Key? key, this.timezone, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      builder: (FormFieldState<String> _) {
        return InputDecorator(
          decoration: InputDecoration(
              enabledBorder: _border,
              focusedBorder: _border,
              disabledBorder: _border,
              contentPadding: const EdgeInsets.all(10),
              errorStyle: const TextStyle(
                color: Colors.redAccent,
                fontSize: 16.0,
              ),
              hintText: 'Please your timezone',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
          isEmpty: timezone == '',
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: timezone,
              icon: const Padding(
                padding: EdgeInsets.only(
                  right: 14.0,
                ),
                child: Icon(
                  Icons.expand_more,
                  size: 24.0,
                  color: Contants.primaryColor,
                ),
              ),
              isDense: true,
              onChanged: onChanged,
              items: timeZones.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, overflow: TextOverflow.ellipsis),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
