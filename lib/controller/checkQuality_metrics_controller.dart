import 'dart:convert';
import 'dart:math';
import 'package:cottonist/views/grader/showPredictionQR.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class CheckqualityMetricsController extends GetxController {
  QRViewController? controller;
  Rx<String> scannedResult = "".obs;

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null) {
        try {
          scannedResult.value = scanData.code!;
          // CheckQulality metrics = CheckQulality.fromJson(scannedResult.value);
          String validJsonString = scannedResult.value.replaceAll("'", '"');
          Map<String, dynamic> responseMap = json.decode(validJsonString);

          Get.to(() => ShowPredictionQR(
                mapGrader: responseMap,
              ));
        } catch (e) {
          Get.snackbar("Error", "$e");
        }
      }
    });
  }

  void onPermissionSet(QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p' as num);
    if (!p) {
      Get.snackbar("Error", "permission is required");
    }
  }
}
