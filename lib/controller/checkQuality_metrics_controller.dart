import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class CheckqualityMetricsController extends GetxController {
  QRViewController? controller;
  Rx<String> scannedResult = "Scan a QR code".obs;

  void onQRViewCreated(QRViewController controller) {
    print("OnQRCODECREATED");
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null) {
        print("Scanned QR Code: ${scanData.code}");
      }
      scannedResult.value = scanData.code!;
    });
    print(scannedResult);
  }

  void onPermissionSet(QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p' as num);
    if (!p) {
      Get.snackbar("Error", "permission is required");
    }
  }
}
