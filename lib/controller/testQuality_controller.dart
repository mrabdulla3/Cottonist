import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cottonist/controller/login_controller.dart';
import 'package:cottonist/credentials/auth_preference.dart';
import 'package:cottonist/views/grader/showPredictionImage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:image/image.dart' as img;

class TestQualityMetricsController extends GetxController {
  var selectedImage = Rxn<File?>();
  RxMap<String, dynamic> MapPred = <String, dynamic>{}.obs;
  RxBool isLoading = false.obs;
  final int maxPayloadSize = 46949; // 46KB limit

  // Function to pick an image from Camera or Gallery
  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      File originalImage = File(pickedFile.path);
      int fileSize = originalImage.lengthSync(); // Get image size in bytes

      print("Original Image Size: $fileSize bytes");

      // Check if the image size exceeds the max limit
      if (fileSize > maxPayloadSize) {
        print("Compressing image...");
        selectedImage.value = await compressImage(originalImage);
      } else {
        print("No compression needed.");
        selectedImage.value = originalImage;
      }
    }
  }

  // Function to compress image if it exceeds the size limit
  Future<File> compressImage(File file) async {
    List<int> imageBytes = await file.readAsBytes();
    img.Image? decodedImage = img.decodeImage(Uint8List.fromList(imageBytes));

    if (decodedImage != null) {
      // Resize and compress image
      img.Image resizedImage = img.copyResize(decodedImage, width: 800); // Resize if necessary
      List<int> compressedBytes = img.encodeJpg(resizedImage, quality: 70); // Adjust quality

      // Save compressed image to file
      File compressedFile = File(file.path)..writeAsBytesSync(compressedBytes);

      print("Compressed Image Size: ${compressedFile.lengthSync()} bytes");
      return compressedFile;
    }
    return file; // Return original file if compression fails
  }

  // Function to send image to AI model
  Future<void> sendToAI() async {
    final auth = Get.put(AuthPreferences());
    isLoading.value = true;

    if (selectedImage.value == null) {
      Get.snackbar("Error", "Please select an image first",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    var url =
        Uri.parse("https://www.shreshtacotton.com/api/upload-and-predict/");
    try {
      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer ${auth.accessToken}';
      request.headers['Accept'] = 'application/json';

      int fileSize = selectedImage.value!.lengthSync();
      print("Final Image Size Before Upload: $fileSize bytes");

      request.files.add(await http.MultipartFile.fromPath(
        'file',
        selectedImage.value!.path,
        filename: basename(selectedImage.value!.path),
      ));

      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = await response.stream.bytesToString();
        Map<String, dynamic> responseMap = json.decode(responseData);
        MapPred.value = responseMap;
        Get.snackbar("Success", "Analysis Complete !");
        selectedImage.value = null;
        Get.to(() => ShowPredictionImage(
              mapGrader: MapPred,
            ));

        MapPred.value = responseMap;
        Get.snackbar("Success", "Analysis Complete!");
        selectedImage.value = null;
        Get.to(() => ShowPredictionImage(mapGrader: MapPred));

      } else {
        Get.snackbar("Error", "Failed to analyze image.");
      }
    } catch (e) {
      Get.snackbar("Error", "Error sending image: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
