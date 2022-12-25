import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt_io.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:crypto/crypto.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:pointycastle/asymmetric/api.dart';

import 'package:http/http.dart' as http;
import 'dart:developer' as logDev;

import '../appConstants.dart';
import '../screens/ApointmentscreenBooking.dart';
import '../screens/checkout.dart';
import '../utils/appCommon.dart';
import '../utils/appwigets.dart';
import '../utils/color_use.dart';
import 'cerateAppointment.dart';

class PatientAppointmentFragment extends StatefulWidget {
  @override
  _PatientAppointmentFragmentState createState() =>
      _PatientAppointmentFragmentState();
}

class _PatientAppointmentFragmentState
    extends State<PatientAppointmentFragment> {
  List<String> pStatus = [];
  ScrollController _controller = new ScrollController();
  String? currentUserId;
  String? statusType="pending";

  int selectIndex = -1;
  List<Appointments>? _app;

  static String? urlLink = "https://admin.verzat.com/user-api/";
  static String? url = "";

  TextEditingController searchCont = TextEditingController();

  DateTime current = DateTime.now();

  @override
  void initState() {
    super.initState();

    init();
  }

  init() async {
    //
    currentUserId = getStringAsync(USER_ID);
    pStatus.add("Approved");
    pStatus.add("Pending");
    pStatus.add("Booked");
    pStatus.add('Completed');
    pStatus.add('Cancelled');
    pStatus.add('Past');
    selectIndex = 0;

    // await getConfiguration().catchError(log);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void didUpdateWidget(covariant PatientAppointmentFragment oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  Widget body() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //TODO Not implement the Functionality
          /*  16.height.visible(false),
          AppTextField(
            textStyle: primaryTextStyle(color: !appStore.isDarkModeOn ? textPrimaryBlackColor : textPrimaryWhiteColor),
            controller: searchCont,
            textAlign: TextAlign.start,
            textFieldType: TextFieldType.NAME,
            decoration: speechInputWidget(context, hintText: languageTranslate('SearchDoctor'), iconColor: primaryColor),
          ).paddingSymmetric(horizontal: 16).visible(true),*/
          16.height,
          HorizontalList(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: pStatus.length,
            itemBuilder: (context, index) {
              return Container(
                alignment: Alignment.center,
                padding:
                    EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
                margin: EdgeInsets.only(left: 0, right: 8, top: 4, bottom: 4),
                decoration: BoxDecoration(
                  color:
                      selectIndex == index ? primaryColor : scaffoldBgColor,
                  // ? appStore.isDarkModeOn
                  // ? cardDarkColor
                  //: black
                  // // : appStore.isDarkModeOn
                  //? scaffoldDarkColors

                  borderRadius:
                      BorderRadius.all(Radius.circular(defaultRadius)),
                ),
                child: FittedBox(
                  child: Text(
                    pStatus[index],
                    style: primaryTextStyle(
                        size: 14,
                        color: selectIndex == index
                            ? white
                            : Theme.of(context).iconTheme.color),
                    textAlign: TextAlign.center,
                  ).paddingSymmetric(horizontal: 16, vertical: 2),
                ),
              ).onTap(
                () {
                  selectIndex = index;
                  if (index == 0) {

                    statusType = "approved";

                    url = urlLink! + '/UserApi/getAppointments.php';
                    successToast("Approved");

                    // appStore.setStatus('all');
                  } else if (index == 1) {
                    statusType = "pending";

                    url = urlLink! + '/UserApi/getAppointments.php';
                    successToast("pending");


                    // appStore.setStatus('-1');
                  } else if (index == 2) {
                    successToast("booked");
                    statusType = "booked";

                    url = urlLink! + 'appointmentDone.php';


                    //appStore.setStatus('3');
                  } else if (index == 3) {
                    successToast("Completed");
                    statusType = "Completed";
                    url = urlLink! + 'appointmentDone.php';

                  } else if (index == 4) {
                    successToast("Cancel");
                    statusType = "Cancel";
                    url = urlLink! + 'appointmentDone.php';
                    //appStore.setStatus('0');



                    //appStore.setStatus('past');
                  } else if(index == 5){
                    successToast("closed");
                    statusType = "closed";
                    url = urlLink! + 'appointmentDone.php';
                  } //
                  setState(() {});
                },
              );
            },
          ),
          // NoDataFoundWidget(iconSize: 120).center(),
          16.height,
          Container(
             color: scaffoldBgColor,
            child:
            FutureBuilder<List<Appointments>>(
              future: get(currentUserId!,statusType!),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  // logDev.log(snapshot.data,name:"123");
                  print(snapshot.data);
                  return  Image.asset('images/noFound.png');
                } else {
                  _app = [];
                  _app = snapshot.data;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    // new
                    scrollDirection: Axis.vertical,
                    controller: _controller,
                    padding: EdgeInsets.all(10),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return appointments(_app![index]);
                    },
                  );
                }
              },
            ),
          )
          // PatientAppointment().paddingAll(16),
        ],
      ).expand(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: scaffoldBgColor,
        floatingActionButton: AddFloatingButton(
          onTap: () {
            //appStore.setBookedFromDashboard(false);

            AddAppointmentScreenStep1()
                .launch(context, pageRouteAnimation: PageRouteAnimation.Scale);
            // // isProEnabled() ? AddAppointmentScreenStep3().launch(context, pageRouteAnimation: PageRouteAnimation.Scale) : AddAppointmentScreenStep1().launch(context, pageRouteAnimation: PageRouteAnimation.Scale);
          },
        ),
        body: body(),
      ),
    );
  }

  appointments(Appointments appointments) {
    bool buttonenabled = false;
    if (appointments.status == "pending") {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.white),
        margin: EdgeInsets.all(10),
        height: 160,
        child: Wrap(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15,top: 15,bottom: 5),
                    child: Text(
                      "Dr.${appointments.name!}",
                      style: GoogleFonts.jost(
                          fontSize: 30,
                          color: Colors.black,
                          decoration: TextDecoration.none),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          color: Colors.blue,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            "${appointments.apptDate}",
                            style: GoogleFonts.jost(
                                fontSize: 16,
                                color: Colors.black,
                                decoration: TextDecoration.none),
                            maxLines: 2,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.watch_later_outlined,
                              color: Colors.blue,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                "${appointments.apptTime}",
                                style: GoogleFonts.jost(
                                    fontSize: 16,
                                    color: Colors.black,
                                    decoration: TextDecoration.none),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                        onPressed: buttonenabled ? () {} : null,
                        child:
                            Center(child: Text("appointment not approved "))),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    } else if (appointments.status == "approved") {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.white),
        margin: EdgeInsets.all(10),

        child: Wrap(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, top: 10),
                          child: Text(
                            "Dr.${appointments.name}",
                            style:   GoogleFonts.jost(
                                fontSize: 30,
                                color: Colors.black,
                                 decoration: TextDecoration.none),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          color: Colors.blue,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            "${appointments.apptDate}",
                            style: GoogleFonts.jost(
                                fontSize: 16,
                                color: Colors.black,
                                decoration: TextDecoration.none),
                            maxLines: 2,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.watch_later_outlined,
                              color: Colors.blue,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                "${appointments.apptTime}",
                                style: GoogleFonts.jost(
                                    fontSize: 16,
                                    color: Colors.black,
                                    decoration: TextDecoration.none),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                        onPressed: () async {
                          //  var info =    await get();
                          CheckOut(appointments).launch(context);
                          //_pay(appointments.doctorName!,appointments.id!,appointments.dEmail!,appointments.patientName!);
                        },
                        child: Center(child: const Text("Payment pending"))),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    } else if (appointments.status == "booked") {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.white),
        margin: EdgeInsets.all(10),
        height: 200,
        child: Expanded(
          child: Wrap(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, top: 10),
                      child: Text(
                        "Dr.${appointments.name}",
                        style:   GoogleFonts.jost(
                            fontSize: 30,
                            color: Colors.black,
                            decoration: TextDecoration.none),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15,top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      color: Colors.blue,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        "${appointments.apptDate}",
                        style: GoogleFonts.jost(
                            fontSize: 16,
                            color: Colors.black,
                            decoration: TextDecoration.none),
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.watch_later_outlined,
                          color: Colors.blue,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text(
                            "${appointments.apptTime}",
                            style: GoogleFonts.jost(
                                fontSize: 16,
                                color: Colors.black,
                                decoration: TextDecoration.none),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding:   EdgeInsets.only(left: 15, top: 0),
                child: Expanded(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_city_rounded,
                          size: 24,
                          color: Colors.green,
                        ),
                        Padding(
                          padding:   EdgeInsets.only(left: 10),
                          child:  SizedBox(

                            width: 260,
                            height: 30,
                            child: Text(
                            "Hospital: ${appointments.hospital} " ,
                                  style: GoogleFonts.jost(
                                color: Colors.black,
                                fontSize: 20,

                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,

                            ),
                          ),
                        ),

                        SizedBox(
                          width: 10,
                        )
                      ]),
                ),
              ),
              Padding(
                padding:   EdgeInsets.only(left: 15, top: 0),
                child: Expanded(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on_sharp,
                          size: 24,
                          color: Colors.red,
                        ),
                        Padding(
                          padding:   EdgeInsets.only(left: 4),
                          child:  SizedBox(

                            width: 260,
                            height: 30,
                            child: Text(
                              " ${appointments.location} " ,
                              style: GoogleFonts.jost(
                                color: Colors.black,
                                fontSize: 20,

                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,

                            ),
                          ),
                        ),

                        SizedBox(
                          width: 10,
                        )
                      ]),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 15,top:5),
                child: Container(
                  width: 200,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.green),
                  child: Center(
                      child: Text(
                    "Booked",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  )),
                ),
              ),
              /* Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                    onPressed: () async {
                      //  var info =    await get();

                      _pay(appointments.doctorUpiAddress!,appointments.doctorName!);
                    },
                    child: Center(child: const Text("Payment pending"))),
              )*/
            ],
          ),
        ),
      );
    } else {
      NoDataFoundWidget();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}

Future<List<Appointments>> get(String userId ,String statusType) async {
  var request = http.MultipartRequest('POST', Uri.parse('https://admin.verzat.com/user-api/appointmentDone.php'));
  request.fields.addAll({
    'userID':  userId,
    'text': statusType
  });


  http.StreamedResponse response = await request.send();

  var response1 = await http.Response.fromStream(response);
  List<Appointments> apptmntList = [];
  var appList = jsonDecode( response1.body);
  for(var item in appList){
    Appointments appointments = Appointments(
        id: item['id'],
        userID: item['userID'],
        role: item['role'],
        doctorID: item['doctorID'],
        patientName: item['patientName'],
        patientAge: item['patientAge'],
        patientNumber: item['patientNumber'],
        patientEmail: item['patientEmail'],
        patientGender: item['patientGender'],
        apptDate: item['apptDate'],
        apptTime: item['apptTime'],
        bookDate: item['bookDate'],
        bookTime: item['bookTime'],
        bloodGroup: item['bloodGroup'],
        subject: item['subject'],
        description: item['description'],
        appointmentId: item['appointmentId'],
        status: item['status']
        ,mobile: item['mobile'],
        location: item['location'],
        name:item['name'],
        hospital: item['hospital'],
        fees: item['fees']
    );

    apptmntList.add(appointments);
    print("hiii${item['patientName']}");
  }


  return apptmntList;
}

class Appointments {
  String? id;
  String? userID;
  String? role;
  String? doctorID;
  String? patientName;
  String? patientAge;
  String? patientNumber;
  String? patientEmail;
  String? patientGender;
  String? apptDate;
  String? apptTime;
  String? bookDate;
  String? bookTime;
  String? bloodGroup;
  String? subject;
  String? description;
  String? appointmentId;
  String? status;
  String? mobile;
  String? location;
  String? name;
  String? hospital;
  String? fees;
  String? count;

  Appointments(
      {this.id,
      this.userID,
      this.role,
      this.doctorID,
      this.patientName,
      this.patientAge,
      this.patientNumber,
      this.patientEmail,
      this.patientGender,
      this.apptDate,
      this.apptTime,
      this.bookDate,
      this.bookTime,
      this.bloodGroup,
      this.subject,
      this.description,
      this.appointmentId,
      this.status,
      this.mobile,
      this.location,
      this.name,this.hospital
      ,this.fees,this.count});

  Appointments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userID = json['userID'];
    role = json['role'];
    doctorID =
    json['doctorID'];
    patientName = json['patientName'];
    patientAge = json['patientAge'];
    patientNumber = json['patientNumber'];
    patientEmail = json['patientEmail'];
    patientGender = json['patientGender'];
    apptDate = json['apptDate'];
    apptTime = json['apptTime'];
    bookDate = json['bookDate'];
    bookTime = json['bookTime'];
    bloodGroup = json['bloodGroup'];
    subject = json['subject'];
    description = json['description'];
    appointmentId = json['appointmentId'];
    status = json['status'];
    mobile = json['mobile'];
    location = json['location'];
    name = json['name'];
    hospital = json['hospital'];
    fees = json['fees'];
    count =json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userID'] = this.userID;
    data['role'] = this.role;
    data['doctorID'] = this.doctorID;
    data['patientName'] = this.patientName;
    data['patientAge'] = this.patientAge;
    data['patientNumber'] = this.patientNumber;
    data['patientEmail'] = this.patientEmail;
    data['patientGender'] = this.patientGender;
    data['apptDate'] = this.apptDate;
    data['apptTime'] = this.apptTime;
    data['bookDate'] = this.bookDate;
    data['bookTime'] = this.bookTime;
    data['bloodGroup'] = this.bloodGroup;
    data['subject'] = this.subject;
    data['description'] = this.description;
    data['appointmentId'] = this.appointmentId;
    data['status'] = this.status;
    data['mobile'] = this.mobile;
    data['location'] = this.location;
    data['name'] = this.name;
    data['hospital'] = this.hospital;
    return data;
  }
}
