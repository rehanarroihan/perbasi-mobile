import 'package:flutter/material.dart';
import 'package:perbasitlg/app.dart';
import 'package:perbasitlg/main_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  App.configure(
    apiBaseURL: 'https://multazamgsd.com/ngamenhub/',
    appTitle: 'Perbasi Tulungagung'
  );

  await App().init();

  runApp(MainApp());
}