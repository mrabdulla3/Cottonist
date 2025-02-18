import 'dart:io';

import 'package:cottonist/controller/checkQuality_metrics_controller.dart';
import 'package:cottonist/views/grader/testQuality_metrics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class GraderDashboard extends StatefulWidget {
  const GraderDashboard({super.key});

  @override
  State<GraderDashboard> createState() => _GraderDashboardState();
}

class _GraderDashboardState extends State<GraderDashboard> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final checkQualityController = Get.put(CheckqualityMetricsController());
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      checkQualityController.controller!.pauseCamera();
    }
    checkQualityController.controller!.resumeCamera();
    print("camera started");
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
            height: (320/ 800) * MediaQuery.of(context).size.height,
            width: (220/ 360) * MediaQuery.of(context).size.height, // Adjust height as needed
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
            )
             
             
            
          
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
    double width = MediaQuery.of(context).size.width; // Fixed this line

    return Scaffold(
      backgroundColor: const Color(0xFFF7F3E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0077B6),
        title: const Center(
          child: Text(
            "Dashboard",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: (11 / 360) * width,
          vertical: (20 / 800) * height,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomElevatedButton(
                    text: "Test Quality Metrics",
                    icon: Icons.analytics,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TestQualityMetricsScreen(),
                          ));
                    }),
                SizedBox(width: width * 0.02),
                CustomElevatedButton(
                    text: "Check Quality Metrics",
                    icon: Icons.bar_chart,
                    onPressed: () {
                      _showQRScannerDialog();
                    }),
              ],
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
      width: width * 0.4, // Adjusted width dynamically
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0077B6),
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
            SizedBox(height: height * 0.01), // Adjusted dynamically
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