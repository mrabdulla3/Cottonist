import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

class ShowmetricsController extends GetxController {
  var metricsData =
      <Map<String, dynamic>>[].obs; // Observable List to store API data
  var isLoading = false.obs; // Loading state

  Future<void> showMetrics() async {
    var url = Uri.parse("https://www.shreshtacotton.com/api/director/images/");

    try {
      isLoading.value = true;
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        metricsData.value =
            List<Map<String, dynamic>>.from(data["images"]); // Store API data
        //print(metricsData);
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }

  List<Map<String, dynamic>> filteredMatrics(
      DateTime startDate, DateTime endDate) {
    return metricsData.where((metric) {
      DateTime metricDate =
          DateFormat('yyyy-MM-dd').parse(metric["upload_date"]);
      return metricDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
          metricDate.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  Future<void> shareQrCode(String qrImageUrl) async {
    try {
      if (qrImageUrl.isEmpty) {
        print("Error: QR code image URL is empty!");
        return;
      }

      //Download the image
      var response = await http.get(Uri.parse(qrImageUrl));
      if (response.statusCode == 200) {
        //Get temporary directory
        final tempDir = await getTemporaryDirectory();
        final filePath = '${tempDir.path}/qr_code.png';

        //Save the image file
        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        //Share the image
        await Share.shareXFiles([XFile(file.path)], text: "Scan this QR code!");
      } else {
        print(
            "Error: Failed to download QR code image. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sharing QR code image: $e");
    }
  }
}
