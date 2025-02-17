import 'package:cottonist/controller/testQuality_controller.dart';
import 'package:get/get.dart';

class ShowPredictionController extends GetxController{
   final testQualityController= Get.put(TestQualityMetricsController());
    RxMap<String, dynamic> MapPredGrader = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    predictGrader(); // Assign the entire MapPred
  }

  void predictGrader(){
    MapPredGrader.value = testQualityController.MapPred;
  }
}