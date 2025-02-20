import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddgraderController extends GetxController {
  RxBool isLoading = false.obs;
  final Rxn<Uint8List> selectedImage = Rxn<Uint8List>();

  Future<void> signUp(String orgName, orgAdd, grName, mobile, email, username,
      password, role, Uint8List image) async {
    isLoading.value = true;
    try {
      String url = 'https://www.shreshtacotton.com/api/director/add-grader/';

      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'organizationName': orgName,
          'email': email,
          'password': password,
          'organizationAddress': orgAdd,
          'mobileNumber': mobile,
          'directorName': grName,
          'username': username,
          'role': role,
          'logo': image
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Grader added Successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (response.statusCode == 502) {
        Get.snackbar(
          'Error', // Title
          'Server is Issue!', // Message
          snackPosition: SnackPosition.BOTTOM, // Position
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          duration: const Duration(seconds: 3),
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );
      } else {
        Get.snackbar(
          'Error',
          'Add Grader Failed: ${response.body}',
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
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Pick Image
  Future<void> pickLogo() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      selectedImage.value = await imageFile.readAsBytes();
    }
  }
}
