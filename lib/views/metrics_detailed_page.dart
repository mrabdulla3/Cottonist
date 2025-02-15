import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class MetricDetailPage extends StatelessWidget {
  final Map<String, dynamic> metric;

  const MetricDetailPage({super.key, required this.metric});

  void _shareMetric(BuildContext context) {
    String shareText =
        "**Cotton Quality Metrics**\n\n Date: ${metric["date"]}\n"
        "Quality: ${metric["quality"]}\n"
        "Impurities: ${metric["impurities"]}\n"
        "Moisture: ${metric["moisture"]}\n\n"
        "Shared via Cotton Metrics App.";

    Share.share(shareText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0077B6),
        title:
            const Text("Metric Details", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () => _shareMetric(context),
          ),
        ],
      ),
      body: Center(
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.all(16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Table(
              border: TableBorder.all(width: 1, color: Colors.black26),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3)
              },
              children: [
                _buildTableRow("Date", metric["date"]),
                _buildTableRow("Quality", metric["quality"]),
                _buildTableRow("Impurities", metric["impurities"]),
                _buildTableRow("Moisture", metric["moisture"]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value),
        ),
      ],
    );
  }
}
