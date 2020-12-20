import 'package:flutter/material.dart';
import 'package:perbasitlg/ui/widgets/base/button.dart';

class AppAlertDialog {
  final String title;
  final String description;

  AppAlertDialog({
    @required this.title,
    @required this.description,
  });

  void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ), //this right here
          title: Text(title),
          content: Text(description),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: Text("Oke"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }
}
