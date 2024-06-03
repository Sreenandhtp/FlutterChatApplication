import 'package:flutter/material.dart';

class CustomeTextField extends StatelessWidget {
  final String labeltext;
  final IconData fieldIcon;
  final double height;
  final RegExp validationRegExp;
  final bool obsecureText;
  final void Function(String?) onsave;

  const CustomeTextField(
      {super.key,
      required this.validationRegExp,
      required this.fieldIcon,
      required this.onsave,
      required this.labeltext,
      required this.height,
      this.obsecureText = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        obscureText: obsecureText,
        validator: (value) {
          if (value != null && validationRegExp.hasMatch(value)) {
            return null;
          }
          return "Enter a Valid ${labeltext.toLowerCase()}";
        },
        // controller: controllers,
        decoration: InputDecoration(
            prefixIcon: Icon(fieldIcon),
            labelText: labeltext,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                onSaved: onsave,
      ),
    );
  }
}
