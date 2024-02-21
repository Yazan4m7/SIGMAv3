import 'dart:convert';

import 'package:app/controllers/remote_services_controller.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/encrypt.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';
import 'auth_controller.dart';

class ReportsDataController extends GetxController{
  static ReportsDataController get instance => Get.find();
  final authController = Get.find<AuthController>();
  final remoteServiceController =Get.find<RemoteServicesController>();
  RxList unitsCounts = [].obs;
  RxList jobTypesCounts = [].obs;
  RxList QCCounts = [].obs;
  RxList implantsCounts = [].obs;
  Rx<Jiffy> date = Jiffy.now().obs;
  @override
  void onReady() {
    super.onReady();

    authController.isDoctorAccount.listen((event) {
      if(event == true)
        _fetchReportsData();
    });

  }

  _fetchReportsData(){
    getUnitCountsReportData();
    getJobTypesReportData();
    getQCReportData();
    getImplantsReportData();
  }
  void getUnitCountsReportData() async{

    var response = await http.post(Uri.parse(getUnitCountsReportAddress),
        body: {'phoneNum': encrypt(authController.client.value.phone!),"month": "${date.value.year}-${date.value.month}"
        });
    var jsons = jsonDecode(response.body);
    unitsCounts.value=jsons;

  }
  void getJobTypesReportData() async{

    var response = await http.post(Uri.parse(getJobTypesReportAddress),
        body: {'phoneNum': encrypt(authController.client.value.phone!),"month": "${date.value.year}-${date.value.month}"
        });
    var jsons = jsonDecode(response.body);
    jobTypesCounts.value=jsons;

  }
  void getQCReportData() async{

    var response = await http.post(Uri.parse(getQCReportAddress),
        body: {'phoneNum': encrypt(authController.client.value.phone!),"month": "${date.value.year}-${date.value.month}"
        });
    var jsons = jsonDecode(response.body);
    QCCounts.value=jsons;
  }
  void getImplantsReportData() async{

    var response = await http.post(Uri.parse(getImplantsReportAddress),
        body: {'phoneNum': encrypt(authController.client.value.phone!),"month": "${date.value.year}-${date.value.month}"
        });
    var jsons = jsonDecode(response.body);
    implantsCounts.value=jsons;

  }

}