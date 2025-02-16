import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cottonist/views/dashboards/director_dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignupController extends GetxController {
  RxBool isLoading = false.obs;
  final Rxn<Uint8List> selectedImage = Rxn<Uint8List>();

  Future<void> signUp(String orgName, orgAdd, dirName, mobile, email, username,
      password, role, Uint8List image) async {
    isLoading.value = true;
    try {
      String url = 'https://www.shreshtacotton.com/api/signup/';

      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'organizationName': orgName,
          'email': email,
          'password': password,
          'organizationAddress': orgAdd,
          'mobileNumber': mobile,
          'directorName': dirName,
          'username': username,
          'role': role,
          'logo': image
        }),
      );
      //print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.offAll(() => DirectorDashboard());
        Get.snackbar(
          'Success',
          'Signup Successful!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          'Signup Failed: ${response.body}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error!', // Title
        'Something went wrong!', // Message
        snackPosition: SnackPosition.BOTTOM, // Position
        backgroundColor: Colors.green,
        colorText: Colors.white,
        borderRadius: 10,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.check_circle, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Pick Image
  Future<void> pickLogo() async {
    //print("Yesss");
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      selectedImage.value = await imageFile.readAsBytes();
    }

    print(selectedImage.value);
  }
}
