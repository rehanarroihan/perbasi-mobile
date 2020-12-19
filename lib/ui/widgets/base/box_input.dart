import 'package:flutter/material.dart';
import 'package:perbasitlg/utils/global_method_helper.dart';

class BoxInput extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool passwordField;
  final TextInputType keyboardType;
  final Widget suffixWidget;

  BoxInput({
    @required this.controller,
    @required this.label,
    this.passwordField = false,
    this.keyboardType = TextInputType.text,
    this.suffixWidget
  });

  @override
  _BoxInputState createState() => _BoxInputState();
}

class _BoxInputState extends State<BoxInput> {
  bool _obscurePasswordText = true;

  @override
  Widget build(BuildContext context) {
    if (widget.passwordField) {
      return TextFormField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: _obscurePasswordText,
        decoration: InputDecoration(
          labelText: widget.label,
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _obscurePasswordText = !_obscurePasswordText;
              });
            },
            icon: Icon(_obscurePasswordText
                ? Icons.visibility_off
                : Icons.visibility
            ),
          )
        ),
      );
    }

    if (!widget.passwordField) {
      return TextFormField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          labelText: widget.label,
          suffixIcon: widget.suffixWidget != null
              ? widget.suffixWidget
              : Container()
        ),
      );
    }

    return Container();
  }
}
