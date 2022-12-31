
 import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../appConstants.dart';
import '../../network/apiService.dart';
import '../../utils/appCommon.dart';
import '../../utils/appwigets.dart';
import '../../utils/color_use.dart';
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

  void showData(DateTime dateTime) {
    isLoading = true;
    setState(() {});
    filterList.clear();

    // getAppointmentInCalender(todayDate: dateTime.getFormattedDate(CONVERT_DATE), page: 1).then((value) {
    //   filterList.addAll(value.appointmentData!);
    //
    //   setState(() {});
    // }).catchError(((e) {
    //   errorToast(e.toString());
    // })).whenComplete(() {
    //   isLoading = false;
    //   setState(() {});
    // });
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



           //noDataWidget(text: translate('lblNotAppointmentForThisDay')).visible(filterList.isEmpty && !isLoading).center(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: scaffoldBgColor,
        floatingActionButton: AddFloatingButton(
          onTap: () async {
            // appointmentAppStore.setSelectedDoctor(listAppStore.doctorList.firstWhere((element) => element.iD == getIntAsync(USER_ID)));

          },
        ),
        body: body(),
      ),
    );
  }
}