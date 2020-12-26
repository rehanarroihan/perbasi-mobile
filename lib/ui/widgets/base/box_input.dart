import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:perbasitlg/ui/widgets/base/space.dart';
import 'package:perbasitlg/utils/global_method_helper.dart';

class BoxInput extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool passwordField;
  final TextInputType keyboardType;
  final Widget suffixWidget;
  final Function onClick;
  final ValueChanged<String> validator;
  final TextCapitalization textCapitalization;

  BoxInput({
    @required this.controller,
    @required this.label,
    this.passwordField = false,
    this.onClick,
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
    if (widget.onClick != null) {
      return Stack(
        children: [
          _buildTextFormField(context),
          Container(
            height: ScreenUtil().setHeight(55),
            width: double.infinity,
            child: GestureDetector(
              onTap: widget.onClick,
            ),
          )
        ],
      );
    } else {
      return _buildTextFormField(context);
    }
  }

  Widget _buildTextFormField(BuildContext context) {
    if (widget.passwordField) {
      return TextFormField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: _obscurePasswordText,
        readOnly: widget.onClick != null,
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
    } else {
      return TextFormField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
        readOnly: widget.onClick != null,
        validator: widget.validator ?? (String args) => null,
        decoration: InputDecoration(
          labelText: widget.label,
          suffixIcon: widget.suffixWidget != null
              ? widget.suffixWidget
              : Space()
        ),
      );
    }
  }
}
