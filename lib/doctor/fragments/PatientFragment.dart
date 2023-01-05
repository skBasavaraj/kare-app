
 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../appConstants.dart';
import '../../network/apiService.dart';
import '../../network/doctorApiService.dart';
import '../../utils/appCommon.dart';
import '../../utils/appwigets.dart';
import '../../utils/color_use.dart';
import '../../utils/marqeeWidget.dart';
import '../utils/calender.dart';
import '../utils/dateUtils.dart';

class PatientFragment extends StatefulWidget {
  const PatientFragment({Key? key}) : super(key: key);

  @override
  State<PatientFragment> createState() => _PatientFragmentState();
}

class _PatientFragmentState extends State<PatientFragment> {
  final itemsList = List<String>.generate(10, (n) => "List item ${n}");

  Map<DateTime, List> _events = Map<DateTime, List>();
  List<UpcomingAppointment> filterList = [];

  bool isLoading = false;
  bool isLoad = false;

  String startDate = '';
  String endDate = '';
  DateTime todayDate = DateTime.now();
  String dateAppt= "";

  TextEditingController searchCont = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setStatusBarColor(  scaffoldBgColor);

    startDate = DateTime(DateTime.now().year, DateTime.now().month, 1).getFormattedDate(CONVERT_DATE);
    endDate = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      Utils.lastDayOfMonth(DateTime.now()).day,
    ).getFormattedDate(CONVERT_DATE);
   // loadData();

    LiveStream().on(APP_UPDATE, (isUpdate) {
      if (isUpdate as bool) {
        setState(() {});
      //  loadData();
      }
    });
  }

 /* void loadData() {
    isLoading = true;
    setState(() {});
    getAppointmentData(startDate: startDate, endDate: endDate).then(
          (value) {
        value.appointmentData!.forEach(
              (element) {
            DateTime date = DateTime.parse(element.appointment_start_date!);
            _events.addAll(
              {
                DateTime(date.year, date.month, date.day): [
                  {'name': 'Event A', 'isDone': true, 'time': '9 - 10 AM'}
                ]
              },
            );
          },
        );
        setState(() {});
        if (DateTime.parse(startDate).month == DateTime.now().month) {
          showData(DateTime.now());
        }
      },
    ).catchError(
          (e) {
        isLoading = false;
        setState(() {});
        errorToast(e.toString());
      },
    );
  }*/

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void showData(DateTime dateTime) async {
    print("bsk"+dateTime.year.toString()+"-"+dateTime.month.toString().padLeft(2,"0")+"-"+dateTime.day.toString().padLeft(2,"0") );
setState(()   {
  dateAppt =  dateTime.year.toString()+"-"+dateTime.month.toString().padLeft(2,"0")+"-"+dateTime.day.toString().padLeft(2,"0");

})  ;

  }





  @override
  void dispose() {
    super.dispose();
    LiveStream().dispose(APP_UPDATE);
  }

  Widget body() {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          8.height.visible(false),
          AppTextField(
            textStyle: primaryTextStyle(color:   textPrimaryWhiteColor),
            controller: searchCont,
            textAlign: TextAlign.start,
            textFieldType: TextFieldType.NAME,
            decoration: speechInputWidget(context),
          ).visible(false),
          8.height,
          Container(
            decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor),
            child: Calendar(
              startOnMonday: true,
              weekDays: [
                "MON",
                "TUE",
                "WED",
                "THU",
                "FRI",
                "SAT",
                "SUN",
              ],
              events: _events,
              onDateSelected: (e) => showData(e),
              onRangeSelected: (Range range) {
                startDate = range.from.getFormattedDate(CONVERT_DATE);
                endDate = range.to.getFormattedDate(CONVERT_DATE);
                //loadData();
              },
              isExpandable: true,
              locale:  "en-US",
              isExpanded: false,
              eventColor: appSecondaryColor,
              selectedColor: primaryColor,
              todayColor: primaryColor,
              bottomBarArrowColor: Theme.of(context).buttonColor,
              dayOfWeekStyle: TextStyle(
                color:   Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: 11,
              ),
            ),
          ),
          42.height,

          Container(
             height:500,
            width: context.width(),
            child:
            FutureBuilder<List<doctorGetAppointments>>(
              future:  dateAppointment(dateAppt),
              builder: (_, snap) {
                if (snap.hasData) {
                  List<doctorGetAppointments> list = snap!.data!;
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemBuilder:(context, index) {
                      return todayCard(list[index]);
                    },itemCount: snap.data!.length,);

                }
                return snapWidgetHelper(snap, errorWidget: noDataWidget(text: errorMessage, isInternet: true));
              },
            ),
          ),

           //noDataWidget(text: translate('lblNotAppointmentForThisDay')).visible(filterList.isEmpty && !isLoading).center(),
        ],
      ),
    );
  }
  Widget todayCard(doctorGetAppointments list){
    return  GestureDetector(
      onTap: () {
        // showDialog(context: context, builder:    (context) =>
        //   //  CheckOutDialog(context ,list)
        //  ,  );
        //CheckOutDialog
      },
      child:
      Container(
        width: context.width(),
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            2.height,

            Padding(
              padding: EdgeInsets.only(left: 15,top: 10),
              child: MarqueeWidget(
                child: Text(
                  "${list.status.capitalizeFirstLetter()} Appointment",
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
                        Text(list.patientAge!,style: GoogleFonts.jost(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.white70),).paddingLeft(5),
                        Text("Blood:",style: GoogleFonts.jost(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.white70),).paddingLeft(10),
                        Text(list.bloodGroup!,style: GoogleFonts.jost(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.white70),).paddingLeft(5),

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
      ).paddingOnly(left: 0,top: 0,bottom: 10,right: 00),
    );

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: scaffoldBgColor,
         body: body(),
      ),
    );
  }
}