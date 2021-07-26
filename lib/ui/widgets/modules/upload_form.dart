import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:perbasitlg/ui/widgets/base/box_input.dart';
import 'package:perbasitlg/ui/widgets/base/button.dart';
import 'package:perbasitlg/ui/widgets/base/space.dart';
import 'package:perbasitlg/utils/global_method_helper.dart';

class UploadForm extends StatefulWidget {
  final TextEditingController input;
  final Function onPickImage;
  final String label;
  final ValueChanged<String> validator;
  final bool isPreviewThumbnail;
  final String imageUrl;
  final File image;

  const UploadForm({
    Key key,
    @required this.input,
    @required this.onPickImage,
    @required this.label,
    @required this.validator,
    @required this.isPreviewThumbnail,
    @required this.imageUrl,
    @required this.image,
  }) : super(key: key);

  @override
  _UploadFormState createState() => _UploadFormState();
}

class _UploadFormState extends State<UploadForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BoxInput(
          controller: widget.input,
          label: widget.label,
          onClick: widget.onPickImage,
          validator: widget.validator,
          suffixWidget: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildThumbnail(),
              Space(width: 8),
              Container(
                width: ScreenUtil().setWidth(72),
                height: ScreenUtil().setHeight(32),
                child: Button(
                  onPressed: () {},
                  fontSize: 10,
                  text: 'Pilih File',
                  style: AppButtonStyle.primary,
                  padding: 0,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
        Space(height: 4),
        Text(
          '*Upload file (PNG, JPG, JPEG) max. 5 MB',
          style: TextStyle(
            fontSize: 12
          ),
        )
      ],
    );
  }

  Widget _buildThumbnail() {
    if (widget.isPreviewThumbnail) {
      return Container(
        width: ScreenUtil().setWidth(32),
        height: ScreenUtil().setHeight(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: FileImage(widget.image),
          ),
        ),
      );
    }

    if (!GlobalMethodHelper.isEmpty(widget.imageUrl)) {
      return Container(
        width: ScreenUtil().setWidth(32),
        height: ScreenUtil().setHeight(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(widget.imageUrl),
          ),
        ),
      );
    }

    return Container(
      width: ScreenUtil().setWidth(32),
      height: ScreenUtil().setHeight(32),
    );
  }
}