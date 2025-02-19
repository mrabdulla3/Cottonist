import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ShowmetricsController extends GetxController {
  var metricsData =
      <Map<String, dynamic>>[].obs; // Observable List to store API data
  var isLoading = false.obs; // Loading state

  Future<void> showMetrics(String startDate, String endDate) async {
    var url = Uri.parse("https://www.shreshtacotton.com/api/director/get-pdf/");

    Map<String, String> body = {
      "start_date": startDate,
      "end_date": endDate,
    };

    try {
      isLoading.value = true;
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        metricsData.value =
            List<Map<String, dynamic>>.from(data); // Store API data
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
