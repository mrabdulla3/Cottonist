import 'package:flutter/material.dart';

class ShowpredictionImage extends StatefulWidget {
  final Map<String, dynamic> mapGrader;
  ShowpredictionImage({required this.mapGrader});

  @override
  State<ShowpredictionImage> createState() => _ShowpredictionPageState();
}

class _ShowpredictionPageState extends State<ShowpredictionImage> {
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Builder(builder: (context) {
              var metric = widget.mapGrader;

              if (metric.isEmpty) {
                return const Center(
                  child: Text(
                    "No data available",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                );
              }

              var predictions = metric["prediction"]?["prediction"];
              if (predictions == null) {
                return const Center(child: Text("Invalid data format"));
              }

              return Table(
                border: TableBorder.all(width: 1, color: Colors.black26),
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(3),
                },
                children: [
                  _buildTableRow("Trash", predictions["trash"].toString()),
                  _buildTableRow("2.5% SL", predictions["2.5%sl"].toString()),
                  _buildTableRow("50% SL", predictions["50%sl"].toString()),
                  _buildTableRow("U.R", predictions["U.R"].toString()),
                  _buildTableRow("MIC", predictions["MIC"].toString()),
                  _buildTableRow("STR", predictions["Str"].toString()),
                  _buildTableRow("ELG", predictions["Elg"].toString()),
                  _buildTableRow("AMT", predictions["amt"].toString()),
                  _buildTableRow("RD", predictions["Rd"].toString()),
                  _buildTableRow("B+", predictions["b+"].toString()),
                  _buildTableRow("MR", predictions["MR"].toString()),
                  _buildTableRow("C.G", predictions["C.G"].toString()),
                  _buildTableRow("SFI", predictions["SFI"].toString()),
                ],
              );
            }),
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
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value),
        ),
      ],
    );
  }
}
