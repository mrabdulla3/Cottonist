import 'dart:io';
import 'dart:typed_data';
import 'package:cottonist/views/dashboards/director_dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class SignupController extends GetxController {
  RxBool isLoading = false.obs;
  var selectedImage = Rxn<File?>();

  Future<void> signUp(String orgName, orgAdd, dirName, mobile, email, username,
      password, role, File image) async {
    isLoading.value = true;
    try {
      String url = 'https://www.shreshtacotton.com/api/signup/';

      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields.addAll({
        'organizationName': orgName,
        'email': email,
        'password': password,
        'organizationAddress': orgAdd,
        'mobileNumber': mobile,
        'directorName': dirName,
        'username': username,
        'role': role,
      });

      if (selectedImage.value != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'logo',
          selectedImage.value!.path,
          filename: basename(selectedImage.value!.path),
        ));
      }

      var response = await request.send();
      print(response.statusCode);
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
          'Signup Failed: ${await response.stream.bytesToString()}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error!',
        'Something went wrong!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
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
      selectedImage.value = await File(pickedFile.path);
    }

    print(selectedImage.value);
  }
}
