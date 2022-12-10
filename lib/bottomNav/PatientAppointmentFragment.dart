import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt_io.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:crypto/crypto.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:pointycastle/asymmetric/api.dart';


import 'package:http/http.dart' as http;
import 'dart:developer'as logDev;

import '../appConstants.dart';
import '../screens/ApointmentscreenBooking.dart';
import '../screens/checkout.dart';
import '../utils/appCommon.dart';
import '../utils/appwigets.dart';
import '../utils/color_use.dart';
import 'cerateAppointment.dart';


class PatientAppointmentFragment extends StatefulWidget {
  @override
  _PatientAppointmentFragmentState createState() => _PatientAppointmentFragmentState();
}

class _PatientAppointmentFragmentState extends State<PatientAppointmentFragment> {

  List<String> pStatus = [];
  ScrollController _controller = new ScrollController();
  String? currentUserId;
  int selectIndex = -1;
  List<Appointments>? _app;

  static String? urlLink="http://192.168.0.102";
  static String? url =  urlLink!+'/UserApi/getAppointments.php';

  TextEditingController searchCont = TextEditingController();

  DateTime current = DateTime.now();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
    currentUserId =getStringAsync(USER_ID);
    pStatus.add( "All");
    pStatus.add( "Latest");
    pStatus.add( 'Completed');
    pStatus.add('Cancelled');
    pStatus.add( 'Past');
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

  Widget body(

      ) {

    return SingleChildScrollView(
      child: Container(
        color:scaffoldBgColor,
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
                  padding: EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
                  margin: EdgeInsets.only(left: 0, right: 8, top: 4, bottom: 4),
                  decoration: BoxDecoration(
                    color: selectIndex == index
                    ?primaryColor
                        :scaffoldBgColor
                  ,
                        // ? appStore.isDarkModeOn
                       // ? cardDarkColor
                        //: black
                        // // : appStore.isDarkModeOn
                        //? scaffoldDarkColors

                    borderRadius: BorderRadius.all(Radius.circular(defaultRadius)),
                  ),
                  child: FittedBox(
                    child: Text(
                      pStatus[index],
                      style: primaryTextStyle(size: 14, color: selectIndex == index ? white : Theme.of(context).iconTheme.color),
                      textAlign: TextAlign.center,
                    ).paddingSymmetric(horizontal: 16, vertical: 2),
                  ),
                ).onTap(
                      () {
                    selectIndex = index;
                    if (index == 0) {
                      url   =  urlLink!+'/UserApi/getAppointments.php';
                      successToast("all");
                     // appStore.setStatus('all');
                    } else if (index == 1) {
                      successToast("latest");
                      url   =  urlLink!+'/UserApi/appointmentDone.php';

                     // appStore.setStatus('-1');
                    } else if (index == 2) {

                      successToast("Completd");

                      //appStore.setStatus('3');
                    } else if (index == 3) {
                      //appStore.setStatus('0');
                    } else if (index == 4) {
                      //appStore.setStatus('past');
                    }//
                    setState(() {});
                  },
                );
              },
            ),
            // NoDataFoundWidget(iconSize: 120).center(),
            16.height,
            Container(
              height: 600,
              child: FutureBuilder<List<Appointments>> (

                future:  get(currentUserId!),

                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    // logDev.log(snapshot.data,name:"123");
                    print(snapshot.data);
                    return  Lottie.network("https://assets2.lottiefiles.com/packages/lf20_eMqO0m.json",height: 400,width: 200,);
                  }
                  else
                  {
                    _app=[];
                    _app = snapshot.data;
                    return   ListView.builder(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(), // new
                      scrollDirection: Axis.vertical,
                      controller:  _controller,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: AddFloatingButton(
          onTap: () {
            //appStore.setBookedFromDashboard(false);

            AddAppointmentScreenStep1().launch(context, pageRouteAnimation: PageRouteAnimation.Scale);
           // // isProEnabled() ? AddAppointmentScreenStep3().launch(context, pageRouteAnimation: PageRouteAnimation.Scale) : AddAppointmentScreenStep1().launch(context, pageRouteAnimation: PageRouteAnimation.Scale);
          },
        ),
        body: body(),
      ),
    );
  }
  appointments(Appointments appointments){
    bool buttonenabled = false;
    if(appointments.status =="pending"){
      return  Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.white),
        margin: EdgeInsets.all(10),

        height: 200,
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "Dr.${appointments.doctorName!}",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.black,
                          decoration: TextDecoration.none),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15,top:10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,

                      children: [

                        const Icon(
                          Icons.calendar_month,
                          color: Colors.blue,
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child:   Text(
                            "${appointments.date}",
                            style: TextStyle(
                                fontSize:16,
                                color: Colors.black,
                                decoration: TextDecoration.none),
                            maxLines: 2,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Row(
                          children:  [
                            Icon(
                              Icons.watch_later_outlined,
                              color: Colors.blue,
                            ),

                            Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                "${appointments.time}",
                                style: TextStyle(
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
                    padding:   EdgeInsets.all(10),
                    child: ElevatedButton(

                        onPressed: buttonenabled?(){}:null ,
                        child:   Center(child: Text("appointment not approved "))),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    } else if(appointments.status =="approved"){
      return  Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.white),
        margin: EdgeInsets.all(10),
        height: 200,
        child: Column(
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
                          padding: const EdgeInsets.only(left:15,top:10),
                          child: Text(
                            "Dr.${appointments.doctorName}",
                            style: const TextStyle(
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
                    padding: const EdgeInsets.only(left:15,top:15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        const Icon(
                          Icons.calendar_month,
                          color: Colors.blue,
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child:   Text(
                            "${appointments.date}",
                            style: TextStyle(
                                fontSize:16,
                                color: Colors.black,
                                decoration: TextDecoration.none),
                            maxLines: 2,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Row(
                          children:   [
                            Icon(
                              Icons.watch_later_outlined,
                              color: Colors.blue,
                            ),

                            Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                "${appointments.time}",
                                style: TextStyle(
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

    }else if(appointments.status == "booked"){
      return  Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.white),
        margin: EdgeInsets.all(10),
        height: 200,
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15,top:10),
                          child: Text(
                            "Dr.${appointments.doctorName}",
                            style: const TextStyle(
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
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        const Icon(
                          Icons.calendar_month,
                          color: Colors.blue,
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child:   Text(
                            "${appointments.date}",
                            style: TextStyle(
                                fontSize:16,
                                color: Colors.black,
                                decoration: TextDecoration.none),
                            maxLines: 2,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Row(
                          children:   [
                            Icon(
                              Icons.watch_later_outlined,
                              color: Colors.blue,
                            ),

                            Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                "${appointments.time}",
                                style: TextStyle(
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15,top: 5),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.location_on_sharp,size: 20,color: Colors.green,)

                              ,Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(appointments.doctorLocation!,style: TextStyle(color: Colors.black,fontSize: 20,)
                                  ,overflow: TextOverflow.ellipsis,),
                              ), SizedBox(width: 10,)

                            ]
                        ),

                      )
                      ,
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container
                          (
                          width: 200,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.green
                          ),
                          child: Center(child: Text("Booked",style: TextStyle(color: Colors.white,fontSize: 15),)),
                        ),
                      )
                    ],
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
          ],
        ),
      );

    }else {
      NoDataFoundWidget();
    }

  }

  @override
  void dispose() {
    super.dispose();
  }

}




class Appointments {
  String? id;
  String? name;
  String? doctorName;
  String? userId;
  String? clinic;
  String? patientName;
  String? doctorNumber;
  String? patientAge;
  String? patientNumber;
  String? date;
  String? time;
  String? bloodGroup;
  String? doctorLocation;
  String? description;
  String? gender;
  String? dEmail;
  String? doctorUpiAddress;
  String? uEmail;
  String? status;

  Appointments(
      {this.id,
        this.name,
        this.doctorName,
        this.userId,
        this.clinic,
        this.patientName,
        this.doctorNumber,
        this.patientAge,
        this.patientNumber,
        this.date,
        this.time,
        this.bloodGroup,
        this.doctorLocation,
        this.description,
        this.gender,
        this.dEmail,
        this.doctorUpiAddress,
        this.uEmail,
        this.status});

  Appointments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    doctorName = json['doctorName'];
    userId = json['userId'];
    clinic = json['clinic'];
    patientName = json['patientName'];
    doctorNumber = json['doctorNumber'];
    patientAge = json['patientAge'];
    patientNumber = json['patientNumber'];
    date = json['date'];
    time = json['time'];
    bloodGroup = json['bloodGroup'];
    doctorLocation = json['doctorLocation'];
    description = json['description'];
    gender = json['gender'];
    dEmail = json['dEmail'];
    doctorUpiAddress = json['doctorUpiAddress'];
    uEmail = json['uEmail'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['doctorName'] = this.doctorName;
    data['userId'] = this.userId;
    data['clinic'] = this.clinic;
    data['patientName'] = this.patientName;
    data['doctorNumber'] = this.doctorNumber;
    data['patientAge'] = this.patientAge;
    data['patientNumber'] = this.patientNumber;
    data['date'] = this.date;
    data['time'] = this.time;
    data['bloodGroup'] = this.bloodGroup;
    data['doctorLocation'] = this.doctorLocation;
    data['description'] = this.description;
    data['gender'] = this.gender;
    data['dEmail'] = this.dEmail;
    data['doctorUpiAddress'] = this.doctorUpiAddress;
    data['uEmail'] = this.uEmail;
    data['status'] = this.status;
    return data;
  }
}
Future<List<Appointments>> get(String userId) async {

  var request = http.MultipartRequest(
      'POST', Uri.parse(_PatientAppointmentFragmentState.url!));
  request.fields.addAll({'userId': userId});


  http.StreamedResponse response = await request.send();

  var response1 = await http.Response.fromStream(response);


  var jsonData = json.decode(response1.body);
  List<Appointments> apptmntList = [];
  var jsonArray = jsonData['appointments'];

  //logDev.log('3'+jsonArray['status'],name:"12");

  for (var item in jsonArray) {
    Appointments appointments = Appointments(
        id: item['id'],
        doctorName: item['doctorName'],
        userId: item['userId'],
        clinic: item['clinic'],
        patientName: item['patientName'],
        doctorNumber: item['doctorNumber'],
        patientAge: item['patientAge'],
        patientNumber: item['patientNumber'],
        date: item['date'],
        time: item['time'],
        bloodGroup: item['bloodGroup'],
        doctorLocation: item['doctorLocation'],
        description: item['description'],
        gender: item['gender'],
        dEmail: item['dEmail'],
        doctorUpiAddress: item['doctorUpiAddress'],
        uEmail: item['uEmail'],
        status: item['status']);

    apptmntList.add(appointments);
    logDev.log('4'+ item['status'],name:"12");

  }
  logDev.log('5$apptmntList',name:"12");
  return apptmntList;
}