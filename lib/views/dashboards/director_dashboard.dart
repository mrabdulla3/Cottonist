import 'dart:io';

import 'package:cottonist/controller/checkQuality_metrics_controller.dart';
import 'package:cottonist/credentials/auth_preference.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cottonist/components/addGrader.dart';
import 'package:cottonist/views/director/showMetrics_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class DirectorDashboard extends StatefulWidget {
  const DirectorDashboard({super.key});

  @override
  State<DirectorDashboard> createState() => _DirectorDashboardState();
}

class _DirectorDashboardState extends State<DirectorDashboard> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final checkQualityController = Get.put(CheckqualityMetricsController());
  final authPrefernce = Get.put(AuthPreferences());
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid && checkQualityController.controller != null) {
      checkQualityController.controller!.pauseCamera();
    }
    checkQualityController.controller?.resumeCamera();
  }

  @override
  void dispose() {
    checkQualityController.controller?.dispose();
    super.dispose();
  }

  void _showQRScannerDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "QR Scanner",
      barrierColor: Colors.black, // Semi-transparent background
      pageBuilder: (context, anim1, anim2) {
        return Scaffold(
          backgroundColor:
              Colors.transparent.withOpacity(0.9), // Ensures full transparency
          body: Stack(
            children: [
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height, // Square scanner
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: checkQualityController.onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                      borderColor: Colors.blueAccent,
                      borderRadius: 12,
                      borderLength: 50,
                      borderWidth: 10,
                      cutOutSize: MediaQuery.of(context).size.width * 0.7,
                    ),
                    onPermissionSet: (ctrl, p) =>
                        checkQualityController.onPermissionSet(ctrl, p),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () {
                    checkQualityController.controller?.pauseCamera();
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
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
        title: Center(
          child: Text(
            "Dashboard",
            style: GoogleFonts.lato(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                authPrefernce.clearCredentials();
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
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
                      Get.to(() => const AddGrader());
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
                        builder: (context) => const ShowMetricsPage(),
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
                style: GoogleFonts.raleway(
                    fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
