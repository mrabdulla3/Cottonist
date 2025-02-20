import 'package:cottonist/views/login_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPreferences extends GetxController {
  String? userrole;
  String? accessToken;
  Future<void> saveCredentials(
      String username, String role, String accessToken) async {
class AuthPreferences extends GetxController{
   String ?userrole;
   String ?accessToken;
   Future<void> saveCredentials(String username,String role, String accessToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('role', role);
    await prefs.setString('accessToken', accessToken);
  }

  Future<Map<String, String?>> getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? role = prefs.getString('role');
    String? accessToken = prefs.getString('accessToken');
    return {'username': username, 'role': role, 'accessToken': accessToken};
  }

  Future<String> userRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('role') ?? '';
  }

  Future<void> clearCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('accessToken');
    await prefs.remove('role');
    Get.to(() => LoginScreen());
  }

  Future<bool> isLogged() async {
    Map<String, String?> cred = await getCredentials();
    userrole = cred['role'];
    accessToken = cred['accessToken'];
    if (cred['username'] != null && cred['accessToken'] != null) {
      return true;
    } else {
      return false;
    }
  }
}
