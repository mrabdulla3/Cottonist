import 'package:cottonist/controller/testQuality_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class TestQualityMetricsScreen extends StatefulWidget {
  const TestQualityMetricsScreen({super.key});

  @override
  State<TestQualityMetricsScreen> createState() =>
      _TestQualityMetricsScreenState();
}

final testQualityController = Get.put(TestQualityMetricsController());

class _TestQualityMetricsScreenState extends State<TestQualityMetricsScreen> {
  void initState() {
    super.initState();

    testQualityController.selectedImage.value = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3E8),
      appBar: AppBar(
        backgroundColor: Color(0xFF65B845),
        title: Center(
          child: Text("Test Quality Metrics",
              style: GoogleFonts.lato(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 20)),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Upload Cotton Image",
                style: GoogleFonts.raleway(
                    fontWeight: FontWeight.w800, fontSize: 16),
              ),
              const SizedBox(height: 20),

              // Image Container with Proper Constraints
              Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Obx(
                    () => testQualityController.selectedImage.value != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              testQualityController.selectedImage.value!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )
                        : const Center(child: Text("No Image Selected")),
                  )),

              const SizedBox(height: 20),

              // Camera & Gallery Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          testQualityController.pickImage(ImageSource.camera),
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Capture Image",
                        style: GoogleFonts.raleway(
                            fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF65B845),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          testQualityController.pickImage(ImageSource.gallery),
                      icon: const Icon(
                        Icons.image,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Upload Image",
                        style: GoogleFonts.raleway(
                            fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF65B845),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Send to AI Button
              SizedBox(
                  width: double.infinity,
                  child: Obx(() => testQualityController.isLoading.value
                      ? const SizedBox(
                          height: 30,
                          width: 30,
                          child: Center(
                              child:
                                  CircularProgressIndicator(strokeWidth: 2.5)),
                        )
                      : ElevatedButton.icon(
                          onPressed: () {
                            if (testQualityController.selectedImage.value !=
                                null) {
                              testQualityController.sendToAI();
                            } else {
                              Get.snackbar("ERROR", "Select an image!");
                            }
                          },
                          icon: const Icon(
                            Icons.upload,
                            color: Colors.white,
                          ),
                          label: Text(
                            "Analyze Quality",
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF65B845),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ))),
            ],
          ),
        ),
      ),
    );
  }
}
