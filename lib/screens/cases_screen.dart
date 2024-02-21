import 'package:app/widgets/case_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/remote_services_controller.dart';
import '../utils/constants.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/local_auth_service.dart';


class CasesScreen extends StatefulWidget {
  const CasesScreen({Key? key,this.tabIndex}) : super(key: key);
  final int? tabIndex;
  @override
  State<CasesScreen> createState() => _CasesScreenState();
}

class _CasesScreenState extends State<CasesScreen>
    with SingleTickerProviderStateMixin {
  final remoteServices = Get.find<RemoteServicesController>();
  final List<Tab> myTabs = <Tab>[
    const Tab(text: 'In-Progress'),
    const Tab(text: 'Completed'),
  ];

  TabController? _tabController;
  
  @override
  void initState() {
    checkAuthorization();
    remoteServices.getCompletedCases();
    remoteServices.getInProgressCases();


    _tabController = TabController(vsync: this, length: myTabs.length);
    _tabController?.addListener((){
      setState(() {
      });
    });
    if(widget.tabIndex !=null) {
      _tabController?.animateTo(1);
    }

    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          foregroundColor: kWhite,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: const Text("CASES"),
            actions: <Widget>[IconButton(onPressed: (){
              remoteServices.getCompletedCases();
              remoteServices.getInProgressCases();
            }, icon: Icon(Icons.refresh_rounded))]
        ),
        body: Container(
          decoration:  BoxDecoration(
            image: DecorationImage(
              image: AssetImage(backgroundPath),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 85.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(kBlack),
                        backgroundColor:  MaterialStateProperty.all(_tabController?.index == 0 ? kBlue : Colors.transparent),
                        fixedSize: MaterialStateProperty.all(Size(120.w, 45.h)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                side: BorderSide(
                                    color: _tabController?.index == 0
                                        ? kBlue
                                        : Colors.grey,
                                    width: 3),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)))),
                      ),
                      onPressed: () {
                        _tabController?.animateTo(0);
                        setState(() {});
                      },
                      child:  Text(
                        "In-Progress",
                        style: TextStyle(fontWeight: _tabController?.index == 0 ? FontWeight.bold : FontWeight.normal,color:Colors.white),
                      )),
                  TextButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(kBlack),
                        backgroundColor:  MaterialStateProperty.all(_tabController?.index == 1 ? kGreen : Colors.transparent),
                        fixedSize: MaterialStateProperty.all(Size(120.w, 45.h)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                side: BorderSide(
                                    color: _tabController?.index == 1
                                        ? kGreen
                                        : Colors.grey,
                                    width: 3),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)))),
                      ),
                      onPressed: () {
                        _tabController?.animateTo(1);
                        setState(() {});
                      },
                      child:  Text("Completed",
                          style: TextStyle(fontWeight: _tabController?.index == 1 ? FontWeight.bold : FontWeight.normal,color:Colors.white)))
                ],
              ),
              SizedBox(height: 25.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("Delivery Date",style:TextStyle(color:Colors.white,fontSize: 16.sp))
                      ,Text("Patient name",style:TextStyle(color:Colors.white,fontSize: 16.sp))],),
                ),
              )
              ,Expanded(
                 //height: MediaQuery.of(context).size.height,
                child: TabBarView(controller: _tabController, children: [
                  Obx(
                        ()=> ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: remoteServices.waitingCases.value.length,
                        itemBuilder: (context, index) {
                          return CaseTile(caseItem: remoteServices.waitingCases.value[index],isCompleted: true)
                          ;
                        },
                      ),
                  ),

                   Obx(
                     ()=> ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: remoteServices.completedCases.value.length,
                        itemBuilder: (context, index) {
                          return  CaseTile(caseItem: remoteServices.completedCases.value[index],isCompleted: false);
                        },
                      ),
                   ),

                ]),
              ),
            ],
          ),
        ));
  }
}
