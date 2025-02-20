import 'package:cottonist/controller/showMetrics_controller.dart';
import 'package:cottonist/views/director/metrics_detailed_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class ShowMetricsPage extends StatefulWidget {
  const ShowMetricsPage({super.key});

  @override
  State<ShowMetricsPage> createState() => _ShowMetricsPageState();
}

class _ShowMetricsPageState extends State<ShowMetricsPage> {
  final metricsController = Get.put(ShowmetricsController());
  @override
  void initState() {
    super.initState();
    metricsController.showMetrics();
  }

  DateTime? startDate;
  DateTime? endDate;

  List<Map<String, dynamic>> get filteredMetrics {
    if (startDate == null || endDate == null) {
      return metricsController.metricsData;
    }
    return metricsController.filteredMatrics(startDate!, endDate!);
  }

  Future<void> _selectDateRange(BuildContext context) async {
    DateTimeRange? pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedRange != null) {
      setState(() {
        startDate = pickedRange.start;
        endDate = pickedRange.end;
      });
    }
  }

  void _shareMetric(Map<String, dynamic> metric) {
    String shareText =
        "**Cotton Quality Metrics**\n\n Date: ${metric["date"]}\n"
        "Quality: ${metric["quality"]}\n"
        "Impurities: ${metric["impurities"]}\n"
        "Moisture: ${metric["moisture"]}\n\n"
        "Shared via Cotton Metrics App.";

    Share.share(shareText);
  }

  void _showMetricDetails(Map<String, dynamic> metric) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MetricDetailPage(metric: metric),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF65B845),
        title: Center(
          child: Text("Show Metrics",
              style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.white),
            onPressed: () => _selectDateRange(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Range Display
            Text(
              startDate == null || endDate == null
                  ? "Select Date Range"
                  : "Metrics from ${DateFormat('yyyy-MM-dd').format(startDate!)} to ${DateFormat('yyyy-MM-dd').format(endDate!)}",
              style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w600, fontSize: 18),
            ),
            const SizedBox(height: 10),

            // Show Loading Indicator
            Obx(() {
              if (metricsController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return Expanded(
                child: filteredMetrics.isEmpty
                    ? const Center(child: Text("No metrics available"))
                    : ListView.builder(
                        itemCount: filteredMetrics.length,
                        itemBuilder: (context, index) {
                          var metric = filteredMetrics[index];
                          return GestureDetector(
                            onTap: () => _showMetricDetails(metric),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                leading: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    child: Image.network(
                                      metric["image"],
                                      fit: BoxFit.cover,
                                      height: 110,
                                      width: 80,
                                    )),
                                title: Text("Pridiction: ${index + 1}",
                                    style: GoogleFonts.raleway(
                                      fontWeight: FontWeight.w600,
                                    )),
                                subtitle: Text(
                                  "Date: ${metric["upload_date"]}",
                                  style: GoogleFonts.raleway(
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.share,
                                      color: Color(0xFF65B845)),
                                  onPressed: () => _shareMetric(metric),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
