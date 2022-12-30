import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:nb_utils/nb_utils.dart';

import '../appConstants.dart';
import '../network/apiService.dart';
import '../screens/notificsion.dart';
import '../utils/appwigets.dart';
import '../utils/color_use.dart';

class TopNameWidget extends StatefulWidget {
  const TopNameWidget({Key? key}) : super(key: key);

  @override
  State<TopNameWidget> createState() => _TopNameWidgetState();
}

class _TopNameWidgetState extends State<TopNameWidget>with WidgetsBindingObserver  {
  // var countShow =   _SplashScreenState();
  Color textColor = Colors.blue;
  List<Notifications>? last;

  var num;

  @override
  void initState() {
    //init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationWithShadow(
        borderRadius: radius(0),
        backgroundColor: scaffoldBgColor,
      ),
      child: Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                2.height,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      direction: Axis.vertical,
                      children: [
                        // Image.asset("images/icons/hi.png", width: 22, height: 22, fit: BoxFit.cover),
                        Text(
                          greeting(),
                          style: GoogleFonts.jost(
                              color: textColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(' ${getStringAsync(USER_NAME)}  ',
                            style: GoogleFonts.jost(fontSize: 16)),
                      ],
                    ).paddingOnly(left: 10),
                    Stack(
                      children: [
                        InkWell(
                          child: Image.asset('images/notify.png', height: 30),
                          onTap: () {
                            UserNotification().launch(context,
                                pageRouteAnimation: PageRouteAnimation.Scale);
                          },
                        ),
                        FutureBuilder<List<Notifications>>(
                          future:  getNotificaton(),
                          builder: (context, snapshot) {
                            if (snapshot.data == null) {
                              return snapWidgetHelper(snapshot,
                                  errorWidget: noAppointmentDataWidget(
                                      text: "No Data Found", isInternet: true));
                            } else {
                              last = snapshot.data;
                              return notifyText(last,last!.length!.toInt());

                            }
                          },
                        )

                      ],
                    ).paddingOnly(right: 5)
                  ],
                ),
              ],
            ).expand(),
          ],
        ).paddingSymmetric(horizontal: 12, vertical: 5),
      ),
    );
    /* Observer(
      builder: (_) =>
          Container(
        decoration: boxDecorationWithShadow(
          borderRadius: radius(0),
          backgroundColor: scaffoldBgColor,
        ),
        child: Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  2.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Wrap(
                        direction: Axis.vertical,
                        children: [
                          // Image.asset("images/icons/hi.png", width: 22, height: 22, fit: BoxFit.cover),
                          Text(
                            'Good Morning',
                            style: GoogleFonts.jost(
                                color: Colors.blue,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(' ${getStringAsync(USER_NAME)}  ',
                              style: GoogleFonts.jost(fontSize: 16)),
                        ],
                      ).paddingOnly(left: 10),
                      Stack(
                        children: [
                          InkWell(
                            child: Image.asset('images/notify.png', height: 30),
                            onTap: () {
                              UserNotification().launch(context,
                                  pageRouteAnimation: PageRouteAnimation.Scale);
                            },
                          ),
                          Positioned(
                              right: 3,
                              child: Container(
                                  height: 15,
                                  width: 12,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.red),
                                  child: Center(
                                      child: Text(
                                        countShow,
                                    style: GoogleFonts.jost(
                                        color: Colors.white, fontSize: 10),
                                  ))))
                        ],
                      ).paddingOnly(right: 5)
                    ],
                  ),
                ],
              ).expand(),
            ],
          ).paddingSymmetric(horizontal: 12, vertical: 5),
        ),
      ),
    );*/
  }
    void refresh(){
     setState(() {

     });
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
      // --

        print('Resumed'+"topwidget");
        break;
      case AppLifecycleState.inactive:
      // --
        print('Inactive');
        break;
      case AppLifecycleState.paused:
      // --
        print('Paused'+"topwidget");
        break;
      case AppLifecycleState.detached:
      // --
        print('Detached');
        break;
    }
  }

  notifyText(List<Notifications>? lastItem, int count  ) {

    if (lastItem!.last.status=="not seen") {
      return Positioned(
          right: 9,
          top:3,
          child: Container(
              height: 6,
              width: 5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.red),
              child: Center(
                  child: Text(
                  "",
                style: GoogleFonts.jost(color: Colors.white, fontSize: 10),
              ))));
    }
    return Text("");
  }

  /* Future<void> init() async {
      num =await count().toString();

  }*/
  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      textColor = Colors.orangeAccent;
      return 'Good Morning';
    }
    if (hour < 17) {
      textColor = Colors.deepOrangeAccent;

      return 'Good Afternoon';
    }
    textColor = Colors.blue;

    return 'Good Evening';
  }
}

/*class TopNameWidget extends StatelessWidget {
  const TopNameWidget({
    Key? key,
  }) : super(key: key);


}*/
