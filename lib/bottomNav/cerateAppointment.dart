import 'package:flutter/material.dart';

import 'package:nb_utils/nb_utils.dart';

import '../appConstants.dart';
import '../utils/appCommon.dart';
import '../utils/appwigets.dart';
import '../utils/color_use.dart';
import 'doctorlistwidget.dart';


class AddAppointmentScreenStep1 extends StatefulWidget {
  @override
  _AddAppointmentScreenStep1State createState() => _AddAppointmentScreenStep1State();
}

class _AddAppointmentScreenStep1State extends State<AddAppointmentScreenStep1> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setStatusBarColor(  appPrimaryColor, statusBarIconBrightness: Brightness.light);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() async {
    super.dispose();
    setStatusBarColor(
      appPrimaryColor,
      delayInMilliSeconds: 400,
      statusBarIconBrightness: Brightness.light,
    );
  }

  Widget body() {
    return SingleChildScrollView(
      child: Container(
        color: scaffoldBgColor,
        child: Column(
          children: [
            16.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                isProEnabled()
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                           'Step2Of3',
                          style: primaryTextStyle(size: 14, color: patientTxtColor),
                        ),
                        8.height,
                        Text( 'Choose Your Doctor', style: boldTextStyle(size: titleTextSize)),
                      ],
                    ),
                  ],
                )
                    : Text(
                  'Step 1 Of 2',
                  style: primaryTextStyle(size: 14, color: patientTxtColor),
                ),
                stepProgressIndicator(stepTxt: "1/2", percentage: 0.66),
              ],
            ),
            20.height,

            DoctorListWidget(),

            // ListPage(),
          ],
        ).paddingAll(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: scaffoldBgColor,
          appBar: appAppBar(context, name:  'Add New Appointment'),
          body: body()
          /*floatingActionButton:
          AddFloatingButton(
            icon: Icons.arrow_forward_outlined,
            onTap: () {
             *//* if (appointmentAppStore.mDoctorSelected == null)
                errorToast(languageTranslate('SelectOneDoctor'));
              else {
                AddAppointmentScreenStep2().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
              }*//*
            },
          )),*/
      ),
    );
  }
}
