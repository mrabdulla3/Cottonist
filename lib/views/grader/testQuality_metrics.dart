import 'package:cottonist/controller/testQuality_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class TestQualityMetricsScreen extends StatefulWidget {
  const TestQualityMetricsScreen({super.key});

  @override
  State<TestQualityMetricsScreen> createState() =>
      _TestQualityMetricsScreenState();
}

final testQualityController = Get.put(TestQualityMetricsController());

class _TestQualityMetricsScreenState extends State<TestQualityMetricsScreen> {

  void initState(){
    super.initState();

    testQualityController.selectedImage.value=null;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0077B6),
        title: const Text("Test Quality Metrics",
            style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Upload Cotton Image",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      label: const Text(
                        "Capture Image",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
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
                      label: const Text(
                        "Upload Image",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
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
                child:Obx(()=>
                 testQualityController.isLoading.value
                ? const SizedBox(
                                height: 30,
                                width: 30,
                                child:
                                    Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
                              ):
                ElevatedButton.icon(
                  onPressed: (){
                    if(testQualityController.selectedImage.value!=null)
                     testQualityController.sendToAI();

                     else{
                      Get.snackbar("ERROR", "Select an image!");
                     }

                  },
                  
                  icon: const Icon(
                    Icons.upload,
                    color: Colors.white,
                  ),
                  label:Text(
                    "Analyze Quality",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                )
                ) 
              ),
            ],
          ),
        ),
      ),
    );
  }
}
