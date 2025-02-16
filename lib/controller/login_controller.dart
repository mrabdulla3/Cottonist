import 'package:cottonist/views/dashboards/director_dashboard.dart';
import 'package:cottonist/views/dashboards/grader_dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isPasswordHidden = true.obs;
  RxString accessToken="".obs;

  Future<void> login(String username, String password) async {
    String url = 'https://www.shreshtacotton.com/api/login/';
    isLoading.value = true;
    try {
      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "username": username.trim(),
            "password": password.trim(),
          }));

      //print(response.statusCode);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        accessToken.value=data['access'];
        print("Login Successful: ${data}");
        isLoading.value = false;
        if (data['role'] == "grader") {
          Get.offAll(() => GraderDashboard());
        } else if (data['role'] == "director") {
          Get.offAll(() => DirectorDashboard());
        }
        Get.snackbar(
          'Success', // Title
          'Login successful!', // Message
          snackPosition: SnackPosition.BOTTOM, // Position
          backgroundColor: Colors.green,
          colorText: Colors.white,
          borderRadius: 10,
          margin: EdgeInsets.all(10),
          duration: Duration(seconds: 3),
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
      } else {
        print("Login Failed: ${response.body}");
        isLoading.value = false;
        Get.snackbar(
          'Login Failed', // Title
          'Please! try again later', // Message
          snackPosition: SnackPosition.BOTTOM, // Position
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: EdgeInsets.all(10),
          duration: Duration(seconds: 3),
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
      }
    } catch (e) {
      print(e.toString());

      isLoading.value = false;
      Get.snackbar(
        'ERROR Occured', // Title
        '${e.toString()}', // Message
        snackPosition: SnackPosition.BOTTOM, // Position
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 10,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.check_circle, color: Colors.white),
      );
    }
  }
}
