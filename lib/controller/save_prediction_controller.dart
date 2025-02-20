import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SavePredictionController extends GetxController {
  RxBool isLoadingD = false.obs;
  RxBool isLoadingS = false.obs;
  Future<void> saveprediction(String doc_id) async {
    try {
      isLoadingS.value = true;
      var response = await http.post(
          Uri.parse(
              "https://www.shreshtacotton.com/api/grader/save-predictions/"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "doc_id": doc_id,
            "decision": "save",
          }));
      if (response.statusCode == 200) {
        Get.snackbar(
          'Successfully!',
          'Prediction has been Saved.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar("Error", "$e");
    } finally {
      isLoadingS.value = false;
    }
  }

  Future<void> deleteprediction(String doc_id) async {
    try {
      isLoadingD.value = true;
      var response = await http.post(
          Uri.parse(
              "https://www.shreshtacotton.com/api/grader/save-predictions/"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "doc_id": doc_id,
            "decision": "delete",
          }));
      if (response.statusCode == 200) {}
    } catch (e) {
      Get.snackbar("Error", "$e");
    } finally {
      isLoadingD.value = false;
    }
  }
}
