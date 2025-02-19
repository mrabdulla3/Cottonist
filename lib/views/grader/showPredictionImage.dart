import 'package:cottonist/controller/save_prediction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowPredictionImage extends StatefulWidget {
  final Map<String, dynamic> mapGrader;
  const ShowPredictionImage({Key? key, required this.mapGrader})
      : super(key: key);

  @override
  State<ShowPredictionImage> createState() => _ShowPredictionImageState();
}

final saveController = Get.put(SavePredictionController());

class _ShowPredictionImageState extends State<ShowPredictionImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0077B6),
        title: const Text("Prediction", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          elevation: 6,
          shadowColor: Colors.black26,
          margin: const EdgeInsets.all(16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildPredictionTable(),

                  const SizedBox(height: 20),

                  // Buttons with better design
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Obx(
                        () => saveController.isLoadingS.value
                            ? CircularProgressIndicator()
                            : _buildButton(Icons.save, "Save", Colors.green),
                      ),
                      Obx(
                        () => saveController.isLoadingD.value
                            ? CircularProgressIndicator()
                            : _buildButton(Icons.save, "Cancel", Colors.red),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPredictionTable() {
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
    if (predictions == null || predictions is! Map) {
      return const Center(
        child: Text(
          "Invalid data format",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Table(
      border: TableBorder.all(width: 1, color: Colors.black26),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(3),
      },
      children: predictions.entries.map((entry) {
        return _buildTableRow(entry.key, entry.value.toString());
      }).toList(),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.blue.shade50, // Alternating colors
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            value.isNotEmpty ? value : "N/A",
            style: const TextStyle(),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildButton(IconData icon, String label, Color color) {
    return ElevatedButton.icon(
      onPressed: () async {
        print("45");
        var metric = widget.mapGrader;
        var doc_id = metric["doc_id"];
        if (label == "Cancel") {
          print(doc_id);
          await saveController.deleteprediction(doc_id);
          Navigator.pop(context);
        } else if (label == "Save") {
          print(doc_id);

          await saveController.saveprediction(doc_id,);
          Navigator.pop(context);
        }
      },
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
