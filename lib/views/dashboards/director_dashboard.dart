import 'dart:io';

import 'package:cottonist/controller/checkQuality_metrics_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cottonist/components/addGrader.dart';
import 'package:cottonist/views/director/showMetrics_screen.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class DirectorDashboard extends StatefulWidget {
  const DirectorDashboard({super.key});

  @override
  State<DirectorDashboard> createState() => _DirectorDashboardState();
}

class _DirectorDashboardState extends State<DirectorDashboard> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final checkQualityController = Get.put(CheckqualityMetricsController());
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid && checkQualityController.controller != null) {
      checkQualityController.controller!.pauseCamera();
    }
    checkQualityController.controller!.resumeCamera();
    //print("camera started");
  }

  @override
  void dispose() {
    checkQualityController.controller?.dispose();
    super.dispose();
  }

  void _showQRScannerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Scan QR Code"),
          content: Container(
            height: (320 / 800) * MediaQuery.of(context).size.height,
            width: (220 / 360) *
                MediaQuery.of(context).size.height, // Adjust height as needed
            child: QRView(
              key: qrKey,
              onQRViewCreated: checkQualityController.onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
              ),
              onPermissionSet: (ctrl, p) =>
                  checkQualityController.onPermissionSet(ctrl, p),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                checkQualityController.controller?.pauseCamera();
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F3E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF65B845),
        title: const Center(
          child: Text(
            "Dashboard",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.03,
          vertical: height * 0.03,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    text: "Add Grader",
                    icon: Icons.person_add,
                    onPressed: () {
                      Get.to(() => AddGrader());
                    },
                  ),
                ),
                SizedBox(width: width * 0.02),
                Expanded(
                  child: CustomElevatedButton(
                    text: "Check Quality Metrics",
                    icon: Icons.bar_chart,
                    onPressed: () {
                      _showQRScannerDialog();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.02),
            Center(
              child: CustomElevatedButton(
                text: "Show Metrics",
                icon: Icons.analytics,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShowMetricsPage(),
                      ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const CustomElevatedButton({
    required this.text,
    required this.icon,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: height * 0.12,
      width: width * 0.9,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF65B845),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
          padding: EdgeInsets.symmetric(
            vertical: height * 0.015,
            horizontal: width * 0.04,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            SizedBox(height: height * 0.01),
            Flexible(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
