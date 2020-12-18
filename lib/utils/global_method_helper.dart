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
}