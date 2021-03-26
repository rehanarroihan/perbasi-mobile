import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DropdownData {
  String value, text;

  DropdownData({
    @required this.value,
    @required this.text,
  });
}

class DropdownInput extends StatefulWidget {
  final Widget icon;
  final Widget suffixIcon;
  final String placeholder;
  final Function onClick;
  final FocusNode focusNode;
  final ValueChanged<dynamic> onChanged;
  final ValueChanged<dynamic> onFieldSubmitted;
  final String defaultValues;
  final List<DropdownData> listItem;
  final bool blackPlaceholder;
  final double verticalPadding;

  @override
  _DropDownInputState createState() => _DropDownInputState();

  DropdownInput({
    this.icon,
    this.placeholder,
    this.suffixIcon,
    this.onClick,
    this.focusNode,
    this.defaultValues,
    this.listItem,
    this.onChanged,
    this.blackPlaceholder = false,
    this.verticalPadding = 20, this.onFieldSubmitted,
  });
}

class _DropDownInputState extends State<DropdownInput> {

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField<String>(
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
        decoration: InputDecoration(
          hintStyle: TextStyle(
            fontSize: 16,
          ),
          hintText: widget.placeholder,
          errorBorder: InputBorder.none,
        ),
        onChanged: widget.onChanged,
        isExpanded: true,
        value: widget.defaultValues,
        items: widget.listItem.map((e) =>
          DropdownMenuItem<String>(
            value: e.value,
            child: Text(e.text),
          )
        ).toList()
      ),
    );
  }
}
