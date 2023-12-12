
import 'package:app/screens/performance/implants_performance.dart';
import 'package:app/screens/performance/job_type_performance.dart';
import 'package:app/screens/performance/quality_control_performance.dart';
import 'package:app/screens/performance/units_count_performance.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
class PerformanceScreen extends StatefulWidget {
   PerformanceScreen({Key? key}) : super(key: key);

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  int _currentIndex = 0;
  PageController _pageController = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    _pageController.keepPage;
    return  Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (page){
          setState(() {
            _pageController.keepPage;

            _currentIndex=page;
          });

        },
        children: [
          UnitsCountsPerformance(),
          JobTypePerformance(),
          QualityControlPerformance(),
          ImplantsPerformance(),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.grey.shade100,
          selectedIconTheme: IconThemeData(size: 26.h),
          selectedItemColor: kGreen ,
          unselectedItemColor: Colors.black54,
          selectedFontSize: 15.sp,
          unselectedFontSize: 13.sp,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          items: [BottomNavigationBarItem(

            icon: SizedBox(
              height: 24.0.h,
              width: 24.0.w,
              child: SvgPicture.asset(
                "assets/icons/unit-counts.svg",
                  colorFilter: _currentIndex == 0 ? ColorFilter.mode(kGreen, BlendMode.srcIn) : ColorFilter.mode(Colors.black54, BlendMode.srcIn)
              ),

            ),
            label: 'Units Count',),
            BottomNavigationBarItem(

              icon: SizedBox(
                height: 24.0.h,
                width: 24.0.w,
                child: SvgPicture.asset(
                  "assets/icons/job-type.svg",
                    colorFilter: _currentIndex == 1 ? ColorFilter.mode(kGreen, BlendMode.srcIn) : ColorFilter.mode(Colors.black54, BlendMode.srcIn)
                ),
              ),
              label: 'Job Types',),

            BottomNavigationBarItem(
              icon:  SizedBox(
                height: 24.0.h,
                width: 24.0.w,
                child: SvgPicture.asset(
                    "assets/icons/QC.svg",
                    colorFilter: _currentIndex == 2 ? ColorFilter.mode(kGreen, BlendMode.srcIn) : ColorFilter.mode(Colors.black54, BlendMode.srcIn)
                ),
              ),
              label: 'QC',),
            BottomNavigationBarItem(
              icon: SizedBox(
                height: 24.0.h,
                width: 24.0.w,
                child: SvgPicture.asset(
                  "assets/icons/screw-retained.svg",
                    colorFilter: _currentIndex == 3 ? ColorFilter.mode(kGreen, BlendMode.srcIn) : ColorFilter.mode(Colors.black54, BlendMode.srcIn)
                ),
              ),
              label: 'Implants',)],
          onTap: (index) {

            _currentIndex = index;
            print(_currentIndex);
            _pageController.jumpToPage(
              index
            );
            setState((){});
          },
          //type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}