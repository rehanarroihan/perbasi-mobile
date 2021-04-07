import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:html/parser.dart';
import 'package:image/image.dart';

class GlobalMethodHelper {
  static bool isEmpty(text){
    if(text == "" || text == null || text == "null"){
      return true;
    }else{
      return false;
    }
  }

  static bool isEmptyList(List<dynamic> list){
    if(list == null){
      return true;
    } else if (list.length == 0){
      return true;
    }else{
      return false;
    }
  }

  static String formatNumberToString(String text, {String defaultValue = "0"}) {
    if(GlobalMethodHelper.isEmpty(text)){
      return defaultValue;
    }
    return int.parse(double.parse(text).toStringAsFixed(0)).toString();
  }

  static String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

  static Future<File> resizeImage(File file, {String fileName, int preferredWidth}) async {
    var image = await compute(decodeImage, file.readAsBytesSync());
    var resized = copyResize(image, width: preferredWidth ?? 640);

    File resizedFile = File(file.path)..writeAsBytesSync(encodePng(resized));

    return resizedFile;
  }
}