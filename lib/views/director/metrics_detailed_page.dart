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
                _buildTableRow("Date", metric["upload_date"]),
                _buildTableRow("LOT", metric["lot"].toString()),
                _buildTableRow("Trash", metric["trash"].toString()),
                _buildTableRow(
                    "2.5% SL", metric["prediction"]["2.5%sl"].toString()),
                _buildTableRow(
                    "50% SL", metric["prediction"]["50%sl"].toString()),
                _buildTableRow("U.R", metric["prediction"]["U.R"].toString()),
                _buildTableRow("MIC", metric["prediction"]["MIC"].toString()),
                _buildTableRow("STR", metric["prediction"]["Str"].toString()),
                _buildTableRow("ELG", metric["prediction"]["Elg"].toString()),
                _buildTableRow("AMT", metric["prediction"]["amt"].toString()),
                _buildTableRow("RD", metric["prediction"]["Rd"].toString()),
                _buildTableRow("B+", metric["prediction"]["b+"].toString()),
                _buildTableRow("MR", metric["prediction"]["MR"].toString()),
                _buildTableRow("C.G", metric["prediction"]["C.G"].toString()),
                _buildTableRow("SFI", metric["prediction"]["SFI"].toString()),
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
