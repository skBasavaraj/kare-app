import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
 import 'dart:developer' as logDev;
 import 'package:nb_utils/nb_utils.dart';

import '../appConstants.dart';

Future<List<getPatientCounts>>? getDoctorRequested(  ) async {
  var request = http.MultipartRequest('POST', Uri.parse('https://admin.verzat.com/user-api/doctorGetAppointments.php'));
  request.fields.addAll({
    'doctorID': getStringAsync(USER_ID)
  });
  http.StreamedResponse response = await request.send();

  var response1 = await http.Response.fromStream(response);
  List<getPatientCounts> countList = [];
  var appList = jsonDecode( response1.body);
  // print("hiii${ appList }");
  for(var item in appList){
    getPatientCounts appointments = getPatientCounts(
      approved: item['approved'],booked: item['booked'],closed: item['closed'],pending: item['pending']
      , rejected: item['rejected']
    );
    print("printIDs"+getStringAsync(USER_ID));
    countList.add(appointments);
    print("printIDs"+appointments.toString());

    // ApiService.notiCount = countList.length.toString();

  }
  return countList;

}
Future<List<doctorGetAppointments>>? todayAppointment() async{
  var request = http.MultipartRequest('POST', Uri.parse('https://admin.verzat.com/user-api/dtodayAppointment.php'));
  request.fields.addAll({
    'doctorID': getStringAsync(USER_ID)
  });


 http.StreamedResponse response = await request.send();

 var response1 = await http.Response.fromStream(response);
 List<doctorGetAppointments> countList = [];
 var appList = jsonDecode( response1.body);
 // print("hiii${ appList }");
 for(var item in appList){
  doctorGetAppointments appointments = doctorGetAppointments(
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
      fees: item['fees'],
   //   count:item['count'].toString()

  );
  print("printID"+getStringAsync(USER_ID));
  countList.add(appointments);

 // ApiService.notiCount = countList.length.toString();

 }


 return countList;

}
Future<List<doctorGetAppointments>>? typesAppointment(String type) async{
  var request = http.MultipartRequest('POST', Uri.parse(
      'https://admin.verzat.com/user-api/typeAppointments.php'));
  request.fields.addAll({
    'doctorID': getStringAsync(USER_ID)
    ,'status': type
  });


  http.StreamedResponse response = await request.send();

  var response1 = await http.Response.fromStream(response);
  List<doctorGetAppointments> countList = [];
  var appList = jsonDecode( response1.body);
  // print("hiii${ appList }");
  for(var item in appList){
    doctorGetAppointments appointments = doctorGetAppointments(
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
      fees: item['fees'],
      //   count:item['count'].toString()

    );
    print("printID"+getStringAsync(USER_ID));
    countList.add(appointments);

    // ApiService.notiCount = countList.length.toString();

  }


  return countList;

}
Future<EditAppointment?> editAppointment(String? endPoint,String? id,String? date,String? time) async{
  var request = http.MultipartRequest('POST', Uri.parse('https://admin.verzat.com/user-api/${endPoint}'));
  request.fields.addAll({
    'id': id!,
    'apptDate':  date!,
    'apptTime':  time!
  });


  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var response1 = await http.Response.fromStream(response);
    final result = jsonDecode(response1.body);
     return EditAppointment.fromJson(result);
  }
  else {
    return null;
   }
}
Future<EditAppointment?> doctorApprove(String? status,String? id,String? doctorID,String? date,String? time) async{
  var request = http.MultipartRequest('POST', Uri.parse('https://admin.verzat.com/user-api/doctorApproveIt.php'));
  request.fields.addAll({
    'id': id!,
    'doctorID':doctorID!,
    'apptDate':  date!,
    'apptTime':  time!,
    'status':status!
  });


  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var response1 = await http.Response.fromStream(response);
    final result = jsonDecode(response1.body);
    return EditAppointment.fromJson(result);
  }
  else {
    return null;
  }
}

class EditAppointment {
  String? error;
  String? message;

  EditAppointment({this.error, this.message});

  EditAppointment.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['message'] = this.message;
    return data;
  }
}
class doctorGetAppointments {
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

 doctorGetAppointments(
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
      this.name,
      this.hospital,
      this.fees});

 doctorGetAppointments.fromJson(Map<String, dynamic> json) {
  id = json['id'];
  userID = json['userID'];
  role = json['role'];
  doctorID = json['doctorID'];
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
  data['fees'] = this.fees;
  return data;
 }
}
class getPatientCounts {
  int? pending;
  int? booked;
  int? approved;
  int? closed;
  int? rejected;

  getPatientCounts(
      {this.pending, this.booked, this.approved, this.closed, this.rejected});

  getPatientCounts.fromJson(Map<String, dynamic> json) {
    pending = json['pending'];
    booked = json['booked'];
    approved = json['approved'];
    closed = json['closed'];
    rejected = json['rejected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pending'] = this.pending;
    data['booked'] = this.booked;
    data['approved'] = this.approved;
    data['closed'] = this.closed;
    data['rejected'] = this.rejected;
    return data;
  }
}