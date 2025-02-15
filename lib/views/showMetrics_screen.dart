import 'package:cottonist/views/metrics_detailed_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class ShowMetricsPage extends StatefulWidget {
  const ShowMetricsPage({super.key});

  @override
  State<ShowMetricsPage> createState() => _ShowMetricsPageState();
}

class _ShowMetricsPageState extends State<ShowMetricsPage> {
  DateTime? selectedDate;
  Map<String, dynamic>? selectedMetric;

  final List<Map<String, dynamic>> metricsData = [
    {
      "date": "2024-02-10",
      "quality": "A+",
      "impurities": "Low",
      "moisture": "12%"
    },
    {
      "date": "2024-02-11",
      "quality": "B",
      "impurities": "Medium",
      "moisture": "15%"
    },
    {
      "date": "2024-02-12",
      "quality": "A",
      "impurities": "Low",
      "moisture": "10%"
    },
    {
      "date": "2024-02-13",
      "quality": "C",
      "impurities": "High",
      "moisture": "18%"
    },
  ];

  List<Map<String, dynamic>> get filteredMetrics {
    if (selectedDate == null) return metricsData;
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
    return metricsData
        .where((metric) => metric["date"] == formattedDate)
        .toList();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
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
        backgroundColor: const Color(0xFF0077B6),
        title:
            const Text("Show Metrics", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.white),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Filter
            Text(
              selectedDate == null
                  ? "All Metrics"
                  : "Metrics for ${DateFormat('yyyy-MM-dd').format(selectedDate!)}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Metrics List
            Expanded(
              child: filteredMetrics.isEmpty
                  ? const Center(
                      child: Text("No metrics available for selected date"))
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
                              leading: Icon(Icons.bar_chart,
                                  color: Colors.blue.shade700),
                              title: Text("Quality: ${metric["quality"]}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text("Date: ${metric["date"]}"),
                              trailing: IconButton(
                                icon:
                                    const Icon(Icons.share, color: Colors.blue),
                                onPressed: () => _shareMetric(
                                    metric), // Share button for each metric
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
