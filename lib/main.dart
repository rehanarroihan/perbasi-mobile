import 'package:flutter/material.dart';
import 'package:perbasitlg/app.dart';
import 'package:perbasitlg/main_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  App.configure(
    apiBaseURL: 'https://perbasitulungagung.com/endpoint/api/',
    appTitle: 'Perbasi Tulungagung'
  );

  await App().init();

  runApp(MainApp());
}