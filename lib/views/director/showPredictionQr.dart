import 'package:flutter/material.dart';

class ShowpredictionQR extends StatefulWidget {
  final Map<String, dynamic> mapGrader; // Ensure it's a Map type

  ShowpredictionQR({required this.mapGrader});

  @override
  State<ShowpredictionQR> createState() => showpredictionPageState();
}

class showpredictionPageState extends State<ShowpredictionQR> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0077B6),
        title: const Text("Prediction", style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.all(16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildTable(widget.mapGrader),
          ),
        ),
      ),
    );
  }

  Widget _buildTable(Map<String, dynamic> metric) {
    if (metric.isEmpty) {
      return const Center(
        child: Text("No data available",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      );
    }

    return Table(
      border: TableBorder.all(width: 1, color: Colors.black26),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(3),
      },
      children: [
        _buildTableRow("Lot", metric["lot"].toString()),
        _buildTableRow("Trash", metric["trash"].toString()),
        _buildTableRow("2.5% SL", metric["2.5%sl"].toString()),
        _buildTableRow("50% SL", metric["50%sl"].toString()),
        _buildTableRow("U.R", metric["U.R"].toString()),
        _buildTableRow("MIC", metric["MIC"].toString()),
        _buildTableRow("STR", metric["Str"].toString()),
        _buildTableRow("ELG", metric["Elg"].toString()),
        _buildTableRow("AMT", metric["amt"].toString()),
        _buildTableRow("RD", metric["Rd"].toString()),
        _buildTableRow("B+", metric["b+"].toString()),
        _buildTableRow("MR", metric["MR"].toString()),
        _buildTableRow("C.G", metric["C.G"].toString()),
        _buildTableRow("SFI", metric["SFI"].toString()),
      ],
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
