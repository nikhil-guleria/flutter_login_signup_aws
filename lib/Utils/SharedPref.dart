import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesTest {

  final String login = "login";

  Future<String> sessiontoken(String type,{String value}) async
  {
    String a ="";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(type=="set") {
      prefs.setString("dtoken", value);
      return a;
    }
    else {
      String dtok = prefs.getString("dtoken");
      return dtok;
    }
  }
}