import 'dart:ui';

import 'package:cron/cron.dart';
import 'package:flutter/material.dart';

import 'package:nb_utils/nb_utils.dart';

import '../../bottomNav/settintgs.dart';
import '../../bottomNav/topWidget.dart';
import '../../utils/color_use.dart';
import '../fragments/AppointmentFragment.dart';
import '../fragments/DashboardFragment.dart';
import '../fragments/PatientFragment.dart';

class DoctorDashboardScreen extends StatefulWidget {
  @override
  _DoctorDashboardScreenState createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  int currentIndex = 0;
  double iconSize = 24;
  final cron = Cron();

  Color disabledIconColor =   secondaryTxtColor;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
       setStatusBarColor(  scaffoldBgColor);
      cron.schedule(Schedule.parse('*/1 * * * * *'), () async {
        setState(() { });

        print('Runs every Five seconds');
      });
    /*window.onPlatformBrightnessChanged = () {
      if (getIntAsync(THEME_MODE_INDEX) == ThemeModeSystem) {
        appStore.setDarkMode(MediaQuery.of(context).platformBrightness == Brightness.light);
      }
    };*/
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
                margin: EdgeInsets.only(top: 66),
                child: [
                  DashboardFragment(),
                  AppointmentFragment(),
                  PatientFragment(),
                 SettingFragment(),
                ][currentIndex],
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (i) {
              currentIndex = i;
              setState(() {});
            },
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: Theme.of(context).iconTheme.color,
            backgroundColor: Theme.of(context).cardColor,
            mouseCursor: MouseCursor.uncontrolled,
            elevation: 12,
            items: [
              BottomNavigationBarItem(
          icon: Image.asset('images/icons/dashboard.png', height: iconSize, width: iconSize, color: disabledIconColor),
          activeIcon: Image.asset('images/icons/dashboardFill.png', height: iconSize, width: iconSize),
                label:  "Dashboard",
              ),

              BottomNavigationBarItem(
                icon: Image.asset('images/icons/patient.png', height: iconSize, width: iconSize, color: disabledIconColor),
                activeIcon: Image.asset('images/icons/patientFill.png', height: iconSize, width: iconSize),
                label:  "Patients",
              ),
              BottomNavigationBarItem(
                icon: Image.asset('images/icons/calendar.png', height: iconSize, width: iconSize, color: disabledIconColor),
                activeIcon: Image.asset('images/icons/calendarFill.png', height: iconSize, width: iconSize),
                label:  "Appointments",
              ),
              BottomNavigationBarItem(
                icon: Image.asset('images/icons/user.png', height: iconSize, width: iconSize, color: disabledIconColor),
                activeIcon: Image.asset('images/icons/profile_fill.png', height: iconSize, width: iconSize),
                label: "Settings",
              ),
            ],
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cancel();
  }
  cancel() async {
    await cron.close();

  }
}
