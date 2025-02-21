import 'package:cottonist/credentials/auth_preference.dart';
import 'package:cottonist/views/dashboards/director_dashboard.dart';
import 'package:cottonist/views/dashboards/grader_dashboard.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isPasswordHidden = true.obs;
  RxString accessToken = "".obs;
  final authPreferences = Get.put(AuthPreferences());
  Future<void> login(String username, String password) async {
    String url = '${dotenv.env['API_URL']}/api/login/';
    isLoading.value = true;
    try {
      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "username": username.trim(),
            "password": password.trim(),
          }));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        accessToken.value = data['access'];
        authPreferences.saveCredentials(
            data['username'], data['role'], data['access']);
        isLoading.value = false;
        if (data['role'] == "grader") {
          Get.offAll(() => const GraderDashboard());
        } else if (data['role'] == "Director") {
          Get.offAll(() => const DirectorDashboard());
        }
        Get.snackbar(
          'Success', // Title
          'Login successful!', // Message
          snackPosition: SnackPosition.BOTTOM, // Position
          backgroundColor: Colors.green,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          duration: const Duration(seconds: 3),
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );
      } else {
        isLoading.value = false;
        Get.snackbar(
          'Login Failed', // Title
          'Please! try again later', // Message
          snackPosition: SnackPosition.BOTTOM, // Position
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          duration: const Duration(seconds: 3),
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'ERROR Occured', // Title
        '$e', // Message
        snackPosition: SnackPosition.BOTTOM, // Position
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 10,
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    }
  }
}
