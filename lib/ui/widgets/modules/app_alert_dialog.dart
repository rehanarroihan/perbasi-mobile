import 'package:flutter/material.dart';

class AppAlertDialog {
  final String title;
  final String description;

  final String positiveButtonText;
  final Function positiveButtonOnTap;

  final String negativeButtonText;
  final Function negativeButtonOnTap;

  AppAlertDialog({
    @required this.title,
    @required this.description,
    this.positiveButtonText,
    this.positiveButtonOnTap,
    this.negativeButtonText,
    this.negativeButtonOnTap
  });

  void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          title: Text(title),
          content: Text(description),
          actions: <Widget>[
            negativeButtonText != null && negativeButtonOnTap != null ?
            FlatButton(
              child: Text(negativeButtonText),
              onPressed: () => negativeButtonOnTap(),
            ) : Container(),
            positiveButtonText != null && positiveButtonOnTap != null ?
            FlatButton(
              child: Text(positiveButtonText),
              onPressed: () => positiveButtonOnTap(),
            ) : Container(),
          ],
        );
      }
    );
  }
}
