import 'package:cottonist/views/dashboards/grader_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowPredictionQR extends StatefulWidget {
  final Map<String, dynamic> mapGrader;

  ShowPredictionQR({required this.mapGrader});

  @override
  State<ShowPredictionQR> createState() => _ShowPredictionQRState();
}

class _ShowPredictionQRState extends State<ShowPredictionQR> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Prediction", style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Card(
          elevation: 6,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTable(widget.mapGrader),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTable(Map<String, dynamic> metric) {
    if (metric.isEmpty) {
      return const Center(
        child: Text(
          "No data available",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Table(
      border: TableBorder.all(width: 1, color: Colors.black26),
      columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(3)},
      children: metric.entries.map((entry) {
        return _buildTableRow(entry.key, entry.value.toString());
      }).toList(),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      decoration: BoxDecoration(color: Colors.blue.shade50),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(label.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value),
        ),
      ],
    );
  }

}
