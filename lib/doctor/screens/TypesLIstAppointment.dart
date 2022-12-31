import 'package:cron/cron.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zatcare/network/doctorApiService.dart';
import 'package:zatcare/utils/color_use.dart';

import '../../utils/appwigets.dart';
import '../../utils/marqeeWidget.dart';
import 'PatientDetails.dart';

class TypesAppointmentList extends StatefulWidget {
   String? type;

   TypesAppointmentList(this.type);

  @override
  State<TypesAppointmentList> createState() => _TypesAppointmentListState();
}

class _TypesAppointmentListState extends State<TypesAppointmentList> {
  final cron = Cron();

  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
  }

  init() async {
    setStatusBarColor(scaffoldBgColor);
    cron.schedule(Schedule.parse('*/1 * * * * *'), () async {
      setState(() {});

      print('Runs every Five seconds');
    });
    /*window.onPlatformBrightnessChanged = () {
      if (getIntAsync(THEME_MODE_INDEX) == ThemeModeSystem) {
        appStore.setDarkMode(MediaQuery.of(context).platformBrightness == Brightness.light);
      }
    };*/
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: scaffoldBgColor,
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                    onTap: () {
                      pop(context);
                    },

                    child: Icon(Icons.arrow_back, size: 30,).paddingSymmetric(
                        vertical: 10, horizontal: 10))
                ,
                Text(widget.type!, style: GoogleFonts.poppins(
                    fontSize: 25, fontWeight: FontWeight.w400),)

              ],
            ),
          ),
          Expanded(
            flex: 10,
            child: FutureBuilder<List<doctorGetAppointments>>(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<doctorGetAppointments> list = snapshot!.data!;
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return todayCard(list[index]);
                    }, itemCount: snapshot.data!.length,);
                }
                return snapWidgetHelper(snapshot,
                    errorWidget: noAppointmentDataWidget(
                        text: "No Data Found", isInternet: true));
              }, future: typesAppointment(widget.type!),),
          )

        ],
      ),
    ));
  }

  Widget todayCard(doctorGetAppointments list) {
    if (widget.type == "booked" || widget.type == "pending" ||
        widget.type == "approved") {
      return GestureDetector(
        onTap: () {
          PatientDetails(list).launch(
              context, pageRouteAnimation: PageRouteAnimation.Scale);
        },
        child:
        Container(
          width: 350,
          height: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              2.height,

              Padding(
                padding: EdgeInsets.only(left: 15, top: 10),
                child: MarqueeWidget(
                  child: Text(
                    "${widget.type} appointments".toUpperCase(),
                    style:
                    GoogleFonts.jost(color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                    softWrap: false,
                  ),
                ),
              )
              ,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: boxDecorationWithShadow(
                      boxShape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.white, blurRadius: 0, spreadRadius: 1)
                      ],
                      backgroundColor: Colors.white,
                    ),
                    child: FaIcon(FontAwesomeIcons.user,).center(),
                  ).paddingOnly(left: 10, top: 5),
                  Wrap(
                    direction: Axis.vertical,
                    children: [
                      Marquee(child: Text(list.patientName!, style: GoogleFonts
                          .jost(fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: CupertinoColors.white),)).paddingLeft(9)
                      , Wrap(
                        direction: Axis.horizontal,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text("Gender:", style: GoogleFonts.jost(fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white70),).paddingLeft(10),
                          Text(list.patientGender!, style: GoogleFonts.jost(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white70),).paddingLeft(5),
                          Text("Age:", style: GoogleFonts.jost(fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white70),).paddingLeft(10),
                          Text("00", style: GoogleFonts.jost(fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white70),).paddingLeft(5),

                        ],
                      )
                    ],
                  ),

                ],
              )
              ,
              Container(
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5)),
                width: context.width(),
                height: 25,
                child: Center(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 15,
                    children: [
                      Icon(FontAwesomeIcons.calendarCheck, color: Colors.white,
                        size: 16,),
                      Text(list.apptDate!, style: GoogleFonts.jost(color: Colors
                          .white, fontSize: 14),),
                      Icon(
                        FontAwesomeIcons.clock, color: Colors.white, size: 16,),
                      Text(list.apptTime!, style: GoogleFonts.jost(color: Colors
                          .white, fontSize: 14),),

                    ],
                  ),
                ),
              ).paddingSymmetric(horizontal: 10, vertical: 10)


            ],
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue,
                  Colors.indigo,
                ],
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 6,
                    spreadRadius: 1)
              ]),
        ).paddingSymmetric(vertical: 10, horizontal: 20),
      );
    } else {
      return GestureDetector(
        onTap: () {
          // PatientDetails(list).launch(
          //     context, pageRouteAnimation: PageRouteAnimation.Scale);
        },
        child:
        Container(
          width: 350,
          height: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              2.height,

              Padding(
                padding: EdgeInsets.only(left: 15, top: 10),
                child: MarqueeWidget(
                  child: Text(
                    "${widget.type} appointments".toUpperCase(),
                    style:
                    GoogleFonts.jost(color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                    softWrap: false,
                  ),
                ),
              )
              ,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: boxDecorationWithShadow(
                      boxShape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.white, blurRadius: 0, spreadRadius: 1)
                      ],
                      backgroundColor: Colors.white,
                    ),
                    child: FaIcon(FontAwesomeIcons.user,).center(),
                  ).paddingOnly(left: 10, top: 5),
                  Wrap(
                    direction: Axis.vertical,
                    children: [
                      Marquee(child: Text(list.patientName!, style: GoogleFonts
                          .jost(fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: CupertinoColors.white),)).paddingLeft(9)
                      , Wrap(
                        direction: Axis.horizontal,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text("Gender:", style: GoogleFonts.jost(fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white70),).paddingLeft(10),
                          Text(list.patientGender!, style: GoogleFonts.jost(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white70),).paddingLeft(5),
                          Text("Age:", style: GoogleFonts.jost(fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white70),).paddingLeft(10),
                          Text("00", style: GoogleFonts.jost(fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white70),).paddingLeft(5),

                        ],
                      )
                    ],
                  ),

                ],
              )
              ,
              Container(
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5)),
                width: context.width(),
                height: 25,
                child: Center(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 15,
                    children: [
                      Icon(FontAwesomeIcons.calendarCheck, color: Colors.white,
                        size: 16,),
                      Text(list.apptDate!, style: GoogleFonts.jost(color: Colors
                          .white, fontSize: 14),),
                      Icon(
                        FontAwesomeIcons.clock, color: Colors.white, size: 16,),
                      Text(list.apptTime!, style: GoogleFonts.jost(color: Colors
                          .white, fontSize: 14),),

                    ],
                  ),
                ),
              ).paddingSymmetric(horizontal: 10, vertical: 10)


            ],
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue,
                  Colors.indigo,
                ],
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 6,
                    spreadRadius: 1)
              ]),
        ).paddingSymmetric(vertical: 10, horizontal: 20),
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    removeCron();
    super.dispose();
  }

  removeCron() async {
await cron.close();
  }
}