import 'package:app/widgets/case_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/remote_services_controller.dart';
import '../utils/constants.dart';

class CasesScreen extends StatefulWidget {
  const CasesScreen({Key? key}) : super(key: key);

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
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
    _tabController?.addListener((){
      setState(() {
      });
    });



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
              Expanded(
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
