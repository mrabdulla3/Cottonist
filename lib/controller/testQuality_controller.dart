import 'dart:convert';
import 'dart:io';
import 'package:cottonist/controller/login_controller.dart';
import 'package:cottonist/views/grader/showPrediction.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class TestQualityMetricsController extends GetxController {
  var selectedImage = Rxn<File?>();
  RxMap<String, dynamic> MapPred = <String, dynamic>{}.obs;
  final _loginController = Get.put(LoginController());

  RxBool isLoading = false.obs;

  // Function to pick an image from Camera or Gallery
  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  // Function to send image to AI model (to be implemented)
  Future<void> sendToAI() async {
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
      request.headers['Authorization'] =
          'Bearer ${_loginController.accessToken.value}';
      request.headers['Accept'] = 'application/json';

      request.files.add(await http.MultipartFile.fromPath(
        'file',
        selectedImage.value!.path,
        filename: basename(selectedImage.value!.path),
      ));
      var response = await request.send();
      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = await response.stream.bytesToString();
        Map<String, dynamic> responseMap = json.decode(responseData);
        print(responseMap);
        MapPred.value = responseMap;
        print(responseMap['prediction']);
        Get.snackbar("Success", "Analysis Complete !");
        selectedImage.value = null;
        Get.to(() => Showprediction());
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
