import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zatcare/appConstants.dart';
import 'dart:developer'as logDev;

import '../bottomNav/PatientAppointmentFragment.dart';
import '../verzat/sharedPrefs.dart';
class PaymentPendingList extends StatefulWidget {
    PaymentPendingList({Key? key}) : super(key: key);

  @override
  State<PaymentPendingList> createState() => _PaymentPendingListState();
}

class _PaymentPendingListState extends State<PaymentPendingList> {
  List<Appointments>? _app;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyanAccent,
      body:
      Column(
        children: <Widget>[
          Expanded(

            child:FutureBuilder<List<Appointments>> (
              future:  get(getStringAsync(USER_ID)),

              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  // logDev.log(snapshot.data,name:"123");
                  print(snapshot.data);
                  return CircularProgressIndicator();
                }
                else
                {
                  _app=[];
                  _app = snapshot.data;
                  return   ListView.builder(
                    shrinkWrap: true,
                    // controller: _scrollController,
                    padding: EdgeInsets.all(20),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return appointments(_app![index]);
                    },
                  );

                }
              },
            ),
          ),



        ],
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Dr.${appointments.doctorName!}",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                            decoration: TextDecoration.none),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
    }else if(appointments.status =="approved"){
      return  Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.white),
        margin: EdgeInsets.all(10),
        height: 200,
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 20,),
                      Expanded(
                        child: Text(
                          "Dr.${appointments.doctorName}",
                          style: const TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                              decoration: TextDecoration.none),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:   EdgeInsets.only(bottom: 10, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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


                        },
                        child: Center(child: const Text("Payment pending"))),
                  )
                ],
              ),
            ),
          ],
        ),
      );

    }

  }
}/*
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
Future<List<Appointments>> get() async {

  var request = http.MultipartRequest(
      'POST', Uri.parse('http://192.168.0.101/UserApi/getAppointments.php'));
  request.fields.addAll({'userId': '11'});


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
}*/