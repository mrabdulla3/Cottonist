import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;

class TestQualityMetricsController extends GetxController {
  var selectedImage = Rxn<Uint8List?>(); // Now storing image as bytes

  // Function to pick an image from Camera or Gallery
  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      var file = File(pickedFile.path);

      // Compress the image
      final compressedBytes = await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        quality: 50, // Adjust the quality (1-100, lower means more compression)
      );

      if (compressedBytes != null) {
        selectedImage.value = Uint8List.fromList(compressedBytes);
      }
    }
  }

  // Function to send image to AI model in bytes
  Future<void> sendToAI() async {
    if (selectedImage.value == null) {
      Get.snackbar("Error", "Please select an image first",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    Uint8List imageBytes = selectedImage.value!;

    // Resize the image before sending
    img.Image? decodedImage = img.decodeImage(imageBytes);
    if (decodedImage != null) {
      img.Image resizedImage =
          img.copyResize(decodedImage, width: 600); // Resize width to 600px
      imageBytes = Uint8List.fromList(img.encodeJpg(resizedImage, quality: 50));
    }

    var url =
        Uri.parse("https://www.shreshtacotton.com/api/upload-and-predict/");

    try {
      var request = http.MultipartRequest('POST', url);
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: "image.jpg",
      ));

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        Get.snackbar("Success", "Analysis Complete: $responseData");
      } else {
        Get.snackbar("Error", "Failed to analyze image.");
      }
    } catch (e) {
      Get.snackbar("Error", "Error sending image: $e");
    }
  }
}
