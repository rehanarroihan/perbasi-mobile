import 'package:flutter/material.dart';
import 'package:perbasitlg/ui/widgets/base/space.dart';
import 'package:perbasitlg/utils/global_method_helper.dart';

class BoxInput extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool passwordField;
  final bool readOnly;
  final TextInputType keyboardType;
  final Widget suffixWidget;
  final ValueChanged<String> validator;
  final TextCapitalization textCapitalization;

  BoxInput({
    @required this.controller,
    @required this.label,
    this.readOnly = false,
    this.passwordField = false,
    this.keyboardType = TextInputType.text,
    this.suffixWidget,
    this.validator,
    this.textCapitalization
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
        readOnly: widget.readOnly,
        validator: widget.validator ?? (String args) => null,
        textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
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
        textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
        readOnly: widget.readOnly,
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
