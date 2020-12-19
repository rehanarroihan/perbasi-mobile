import 'package:flutter/material.dart';
import 'package:perbasitlg/ui/widgets/base/space.dart';
import 'package:perbasitlg/utils/global_method_helper.dart';

class BoxInput extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool passwordField;
  final bool enabled;
  final TextInputType keyboardType;
  final Widget suffixWidget;
  final ValueChanged<String> validator;

  BoxInput({
    @required this.controller,
    @required this.label,
    this.enabled = true,
    this.passwordField = false,
    this.keyboardType = TextInputType.text,
    this.suffixWidget,
    this.validator
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
        enabled: widget.enabled,
        validator: widget.validator ?? (String args) => null,
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
        enabled: widget.enabled,
        validator: widget.validator ?? (String args) => null,
        decoration: InputDecoration(
          labelText: widget.label,
          suffixIcon: widget.suffixWidget != null
              ? widget.suffixWidget
              : Space()
        ),
      );
    }

    return Container();
  }
}
