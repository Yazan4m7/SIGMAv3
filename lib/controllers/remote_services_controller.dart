import 'dart:io';

import 'package:app/controllers/reports_data_controller.dart';
import 'package:app/models/galleryMedia.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/utils/encrypt.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';
import '../models/AccountStatementEntry.dart';
import '../models/case.dart';
import '../utils/storage_service.dart';
import 'auth_controller.dart';
import 'package:app/utils/constants.dart';
import 'package:app/models/client.dart';
import 'dart:convert';
import 'package:app/models/job.dart';
import '../models/employee.dart';
import 'package:flutter/foundation.dart';
class RemoteServicesController extends GetxController{
  static RemoteServicesController get instance => Get.find();
  final authController = Get.find<AuthController>();
  //final reportsController =Get.find<ReportsDataController>();


  Rx<String> openingBalance = "0".obs;
  Rx<Jiffy> date = Jiffy.now().obs;
  Rx<String> currentBalance = "".obs;
  RxList waitingCases = [].obs ;
  RxList completedCases = [].obs;
  List<GalleryMedia> galleryMedia = <GalleryMedia>[].obs;
  RxMap<String, List<AccountStatementEntry>> entries =<String, List<AccountStatementEntry>>{}.obs;
  Map<int, Employee> employees =<int, Employee>{};
  Rx<bool> isAllMediaViewed = false.obs;
  @override
  void onReady() async{
    super.onReady();
  }
  void fetchData() async{
    await getOpeningBalance();
    getStatement();
    getInProgressCases();
    getCompletedCases();
    getCurrentBalance();
    getEmployees();
  }
  void _fetchReportsData() async{
    //reportsController.fetchReportsData();
  }


  Future<void> getOpeningBalance() async {
    var response = await http.post(Uri.parse(openingBalanceAddress),
        body: {'phoneNum': encrypt(authController.client.value.phone!),
          'month' : "${date.value.year}-${date.value.month}"});
    // var response = await http.post(Uri.parse(openingBalanceAddress),
    //     body: {'phoneNum': encrypt(authController.phoneNumber),
    //       'month' : "2023-05"});
    openingBalance.value = response.body;
  }
  Future<void> getStatement() async {
    if (entries[date.value.yM] != null) return;
    var response = await http.post(Uri.parse(accountStatementAddress),
        body: {'phoneNum': encrypt(authController.client.value.phone!),
          'month' : "${date.value.year}-${date.value.month}"});


      var jsons = jsonDecode(response.body);
    if(kDebugMode) {
      print(encrypt(authController.client.value.phone!));
    }
    if(jsons is Map)
      jsons = jsons.values;


      entries[date.value.yM] = [];
      double balance= double.parse(openingBalance.value);

      for (var element in jsons) {
        AccountStatementEntry ASE = AccountStatementEntry.fromJson(element);
        if (ASE.status == 1) {
          balance += ASE.amount ?? 0;
        } else {
          balance -= ASE.amount ?? 0;
        }
        ASE.balance = balance;
        entries[date.value.yM]?.add(ASE);
      }

    // }catch(e){
    //   print("No Entries this month");
    // }
  }
  Future<List<job>> getJobs(String caseId) async{
    List<job> jobs = [];
    var response = await http.post(Uri.parse(getJobsAddress),
        body: {'phoneNum': encrypt(authController.client.value.phone!),
          'month' : "${date.value.year}-${date.value.month}",
        'case_id' : caseId});

    List jsons = jsonDecode(response.body);
    for (var element in jsons) {
      jobs.add(job.fromJson(element));
    }
    return jobs;
  }
  void getInProgressCases() async{
    List<Case> casesList = [];
    var response = await http.post(Uri.parse(getInProgressCasesAddress),
        body: {'phoneNum': encrypt(authController.client.value.phone!)
          });

    List jsons = jsonDecode(response.body);
    for (var element in jsons) {
      casesList.add(Case.fromJson(element));
    }
    waitingCases.value = casesList;
  }
  void getCompletedCases() async{
    List<Case> casesList = [];
    var response = await http.post(Uri.parse(getCompletedCasesAddress),
        body: {'phoneNum': encrypt(authController.client.value.phone!)
        });

    List jsons = jsonDecode(response.body);
    for (var element in jsons) {
      casesList.add(Case.fromJson(element));
    }
    completedCases.value = casesList;
  }
  void nextMonth() {

      date.value = date.value.add(months: 1);
      getOpeningBalance();
      getStatement();
  }
  void previousMonth() {

      date.value = date.value.subtract(months: 1);
      getOpeningBalance();
      getStatement();
  }
  void getCurrentBalance() async{
    var response = await http.post(Uri.parse(getCurrentBalanceAddress),
        body: {'phoneNum': encrypt(authController.client.value.phone!)
        });
    currentBalance.value = response.body;
  }
  void getEmployees() async{
    var response = await http.post(Uri.parse(getEmployeesAddress),
        body: {'phoneNum': encrypt(authController.client.value.phone!)
        });
    List jsons = jsonDecode(response.body);
    for (var element in jsons) {
      Employee emp = Employee.fromJson(element);
      employees[emp.id!] = emp;
    }
  }
  Future<void> getGalleryItems() async {
    var response = await http.post(Uri.parse(getGalleryMediaAddress),
        body: {'phoneNum': encrypt(authController.client.value.phone!)});
    List jsons = jsonDecode(response.body);
    for (var element in jsons) {
      GalleryMedia media = GalleryMedia.fromJson(element);
      if (!galleryMedia.map((item) => item.id).contains(media.id))
      galleryMedia.add(media);
    }
    checkIfAllMediaViewed();
  }
  void setNotificationToken(String token) async{
        var response =await http.post(Uri.parse(setNotificationTokenAddress),
        body: {'phoneNum': encrypt(authController.client.value.phone!),
        "token":token});
  }
  void registerLogin() async {
    String device ="N/A";
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var release = androidInfo.version.release;
      var manufacturer = androidInfo.manufacturer;
      var model = androidInfo.model;
      device = "$manufacturer $model - $release";
      // Android 9 (SDK 28), Xiaomi Redmi Note 7
    }

    if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      var systemName = iosInfo.systemName;
      var version = iosInfo.systemVersion;
      var name = iosInfo.name;
      var model = iosInfo.model;
      print('$systemName $version, $name $model');
      device = "$name $model - $systemName $version";
    }
    print("device $device");
     http.post(Uri.parse(registerLoginAddress),
        body: {'phoneNum': encrypt(authController.client.value.phone!),
        'device': device});
  }
}