import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ShowmetricsController extends GetxController {
  var metricsData =
      <Map<String, dynamic>>[].obs; // Observable List to store API data
  var isLoading = false.obs; // Loading state

  Future<void> showMetrics() async {
    var url = Uri.parse("https://www.shreshtacotton.com/api/director/images/");

    try {
      isLoading.value = true;
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        metricsData.value =
            List<Map<String, dynamic>>.from(data["images"]); // Store API data
        //print(metricsData);
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }

  List<Map<String, dynamic>> filteredMatrics(
      DateTime startDate, DateTime endDate) {
    return metricsData.where((metric) {
      DateTime metricDate =
          DateFormat('yyyy-MM-dd').parse(metric["upload_date"]);
      return metricDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
          metricDate.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }
}
