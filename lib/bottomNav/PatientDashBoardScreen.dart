import 'dart:ui';

 import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:nb_utils/nb_utils.dart';
import 'package:zatcare/bottomNav/settintgs.dart';
import 'package:zatcare/bottomNav/topWidget.dart';

import '../appConstants.dart';
import '../network/apiService.dart';
import '../network/doctorApiService.dart';
import '../utils/color_use.dart';
import 'PDashBoardFragment.dart';
import 'PatientAppointmentFragment.dart';
import 'feedList.dart';

class PatientDashBoardScreen extends StatefulWidget {
  @override
  _PatientDashBoardScreenState createState() => _PatientDashBoardScreenState();
}

class _PatientDashBoardScreenState extends State<PatientDashBoardScreen>with WidgetsBindingObserver {
  Color disableIconColor =   secondaryTxtColor;

  int currentIndex = 0;

  double iconSize = 24;
  final cron = Cron();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
      // --

        print('Resumed');
        break;
      case AppLifecycleState.inactive:
      // --
        print('Inactive');
        break;
      case AppLifecycleState.paused:
      // --
        print('Paused');
        break;
      case AppLifecycleState.detached:
      // --
        print('Detached');
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    init();
    WidgetsBinding.instance.addObserver(this);

  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    cronCancell();
    super.dispose();
  }
  init() async {
    setStatusBarColor(  scaffoldBgColor);
    //await getNotificaton();
    cron.schedule(Schedule.parse('*/1 * * * * *'), () async {
      setState(() { });

      print('Runs every Five seconds');
    });


    window.onPlatformBrightnessChanged = () {
      if (getIntAsync(THEME_MODE_INDEX) == ThemeModeSystem) {
       // appStore.setDarkMode(MediaQuery.of(context).platformBrightness == Brightness.light);
      }
    };
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return DoublePressBackWidget(
      child: SafeArea(

        child: Scaffold(
           body: Stack(
            children: [
              TopNameWidget() ,

              Container(
                margin: EdgeInsets.only(top: currentIndex != 3 ? 70 : 0),
                child: [

                  PDashBoardFragment(),
                  PatientAppointmentFragment(),
                  FeedListFragment(),
                  SettingFragment(),
                ][currentIndex],
              ),
            ],
          ),
          bottomNavigationBar:
        /*  AwesomeBottomNav(

            icons: [
              Icons.home_outlined,

              Icons.calendar_today_rounded,
              Icons.newspaper_outlined,
              Icons.account_circle_outlined,
            ],
            highlightedIcons: [
              Icons.home,
              Icons. calendar_month_sharp,
              Icons.featured_play_list_rounded,
              Icons.account_circle,
            ],
            onTapped: (int value) {
              setState(() {
                currentIndex = value;
              });
            },
            bodyBgColor:scaffoldBgColor,
            highlightColor: Colors.blue,
            navFgColor: Colors.blue.withOpacity(0.8),
            navBgColor: Colors.white,
          ),*/
          BottomNavigationBar(

            currentIndex: currentIndex,
            onTap: (i) {
              currentIndex = i;
              setState(() {});
            },

            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: Colors.blue,
            backgroundColor:  Colors.white,
            mouseCursor: MouseCursor.uncontrolled,
            elevation: 12,
            items: [
              BottomNavigationBarItem(
                icon: Image.asset('images/icons/dashboard.png', height: iconSize, width: iconSize, color: disableIconColor),
                activeIcon: Image.asset('images/icons/dashboardFill.png', height: iconSize, width: iconSize),
                label:  "Dashboard",
              ),
              BottomNavigationBarItem(
                icon: Image.asset('images/icons/calendar.png', height: iconSize, width: iconSize, color: disableIconColor),
                activeIcon: Image.asset('images/icons/calendarFill.png', height: iconSize, width: iconSize),
                label:  "Appointments",
              ),
              BottomNavigationBarItem(
                icon: Image.asset('images/icons/patient.png', height: iconSize, width: iconSize, color: disableIconColor),
                activeIcon: Image.asset('images/icons/patientFill.png', height: iconSize, width: iconSize),
                label:  "Patients",
              ),
              BottomNavigationBarItem(
                icon: Image.asset('images/icons/user.png', height: iconSize, width: iconSize, color: disableIconColor),
                activeIcon: Image.asset('images/icons/profile_fill.png', height: iconSize, width: iconSize),
                label: "Settings",
              ),
            ],
          )
        ),
      ),
    );
  }
 cronCancell() async {
    await cron.close();
  }
}
