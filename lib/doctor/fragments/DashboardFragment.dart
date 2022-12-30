
import 'package:cron/cron.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zatcare/utils/appCommon.dart';

import '../../appConstants.dart';
import '../../network/doctorApiService.dart';
import '../../screens/ApointmentscreenBooking.dart';
import '../../utils/appwigets.dart';
import '../../utils/color_use.dart';
import '../../utils/marqeeWidget.dart';
import '../screens/TypesLIstAppointment.dart';
import '../utils/DashBoardCountWidget.dart';
import '../utils/PieChartSample2.dart';
import '../utils/checkOutDialog.dart';

class DashboardFragment extends StatefulWidget {
  @override
  _DashboardFragmentState createState() => _DashboardFragmentState();
}

class _DashboardFragmentState extends State<DashboardFragment> {
  List<DashBoardCountWidget> dashboardCount = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setStatusBarColor(  scaffoldBgColor);
    // final cron = Cron();
    // cron.schedule(Schedule.parse('*/1 * * * * *'), () async {
    //   setState(() { });
    //
    //   print('Runs every Five seconds');
    // });
  }

  @override
  void didUpdateWidget(covariant DashboardFragment oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
    print("refresh");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  scaffoldBgColor,
      body: FutureBuilder<List<getPatientCounts>>(
        future:  getDoctorRequested(  ),
        builder: (_, snap) {
          print(";;"+snap!.toString());
          if (snap.hasData) {
            List<getPatientCounts> list = snap!.data!;
            return ListView.builder(itemBuilder:(context, index) {

              return cards(list[index]);
            },itemCount: snap.data!.length,);

          }
          return snapWidgetHelper(snap, errorWidget: noDataWidget(text: errorMessage, isInternet: true));
        },
      ),
    );
  }

  Widget cards(getPatientCounts list) {
    return Column(
      children: [

        Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          children: [
            GestureDetector(
              onTap: () {
                successToast(list.booked.toString());
                TypesAppointmentList("booked").launch(context,pageRouteAnimation: PageRouteAnimation.Scale);
              },
              child: DashBoardCountWidget(
                title: " Up Coming Appointments",
                color1: Colors.blue,
                // color2: Color(0x8C58CDB2),
                subTitle: " Total Today Appointments",
                count: list.booked.toString(),
                icon: FontAwesomeIcons.calendarCheck,
              ),
            ),
            GestureDetector(
              onTap: () {
                successToast(list.pending.toString());
                TypesAppointmentList("pending").launch(context,pageRouteAnimation: PageRouteAnimation.Scale);

              },
              child: DashBoardCountWidget(
                title:  "pending",
                color1: Colors.yellow.shade800,
                //color2: Color(0x8C58CDB2),
                subTitle: "TotalVisitedAppointment",
                count:  list.pending.toString(),
                icon: FontAwesomeIcons.clock,
              ),
            ),

          ],
        ).paddingOnly(top:40,left: 5,right: 5,bottom: 10),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          children: [
            GestureDetector(
              onTap: () {
                successToast(list.rejected.toString());
                TypesAppointmentList("rejected").launch(context,pageRouteAnimation: PageRouteAnimation.Scale);

              },
              child: DashBoardCountWidget(
                title: "rejected",
                color1: Colors.black54,
                //  color2: Color(0x8CE2A17C),
                subTitle:  "Total Visited Patients",
                count:list.rejected.toString(),
                icon: FontAwesomeIcons.ban,
              ),
            ),
            GestureDetector(
              onTap: () {
                successToast(list.closed.toString());
                TypesAppointmentList("closed").launch(context,pageRouteAnimation: PageRouteAnimation.Scale);

              },
              child: DashBoardCountWidget(
                title: "closed",
                color1: Colors.red,
                //  color2: Color(0x8CE2A17C),
                subTitle:  "Total Visited Patients",
                count:list.closed.toString(),
                icon: FontAwesomeIcons.check,
              ),
            ),
          ],

        ).paddingOnly(top:40,left: 5,right: 5,bottom: 10)
        ,Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          children: [
            GestureDetector(
              onTap: () {
                successToast(list.approved.toString());
                TypesAppointmentList("approved").launch(context,pageRouteAnimation: PageRouteAnimation.Scale);

              },
              child: DashBoardCountWidget(
              title: "approved",
              color1: Colors.green,
              //  color2: Color(0x8CE2A17C),
              subTitle:  "Total Visited Patients",
              count:list.approved.toString(),
              icon: FontAwesomeIcons.calendar,
          ),
            ),
            GestureDetector(
              onTap: () {
                successToast(list.approved.toString());
              },
              child: DashBoardCountWidget(
                title: "Total",
                color1: Colors.purpleAccent,
                //  color2: Color(0x8CE2A17C),
                subTitle:  "Total Visited Patients",
                count:list.approved.toString(),
                icon: FontAwesomeIcons.listCheck,
              ),
            )
          ],
        ).paddingOnly(top:40,left: 5,right: 5,bottom: 10)
      ,
        Container(
        //  width: context.width(),
          height:180,
          child:
        FutureBuilder<List<doctorGetAppointments>>(
      future:  todayAppointment(),
      builder: (_, snap) {
         if (snap.hasData) {
          List<doctorGetAppointments> list = snap!.data!;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder:(context, index) {
            return todayCard(list[index]);
          },itemCount: snap.data!.length,);

        }
        return snapWidgetHelper(snap, errorWidget: noDataWidget(text: errorMessage, isInternet: true));
      },
    ),
    ),

        Container(
         child:   PieChartSample2(list)
            ).paddingSymmetric(horizontal: 20),

      ],
    );
  }
  Widget todayCard(doctorGetAppointments list){
    return  GestureDetector(
      onTap: () {
         showDialog(context: context, builder:    (context) =>
            CheckOutDialog(context ,list)
          ,  );
        //CheckOutDialog
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
              padding: EdgeInsets.only(left: 15,top: 10),
              child: MarqueeWidget(
                child: Text(
                  "Today Appointments",
                  style:
                  GoogleFonts.jost(color: Colors.white, fontSize: 20,fontWeight:FontWeight.w500),
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
                    boxShadow:  [BoxShadow(color: Colors.white,blurRadius: 0,spreadRadius: 1)],
                    backgroundColor:  Colors.white,
                  ),
                  child: FaIcon(FontAwesomeIcons.user,).center(),
                ).paddingOnly(left: 10,top: 5),
                Wrap(
                  direction: Axis.vertical,
                  children: [
                    Marquee(child: Text(list.patientName!,style: GoogleFonts.jost(fontSize: 20,fontWeight: FontWeight.w500,color: CupertinoColors.white),)).paddingLeft(9)
                    , Wrap(
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text("Gender:",style: GoogleFonts.jost(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.white70),).paddingLeft(10),
                        Text(list.patientGender!,style: GoogleFonts.jost(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.white70),).paddingLeft(5),
                        Text("Age:",style: GoogleFonts.jost(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.white70),).paddingLeft(10),
                        Text("00",style: GoogleFonts.jost(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.white70),).paddingLeft(5),

                      ],
                    )
                  ],
                ),

              ],
            )
            ,
            Container(
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2),borderRadius: BorderRadius.circular(5)),
              width: context.width(),
              height: 25,
              child: Center(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 15,
                  children: [
                    Icon(FontAwesomeIcons.calendarCheck,color: Colors.white,size: 16,),
                    Text(list.apptDate!,style: GoogleFonts.jost(color: Colors.white,fontSize: 14),),
                    Icon(FontAwesomeIcons.clock,color: Colors.white,size: 16,),
                    Text(list.apptTime!,style: GoogleFonts.jost(color: Colors.white,fontSize: 14),),

                  ],
                ),
              ),
            ).paddingSymmetric(horizontal: 10,vertical: 10)


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
      ).paddingOnly(left: 25,top: 10,bottom: 10),
    );

  }
 }
