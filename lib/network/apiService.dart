import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'dart:developer' as logDev;
import 'package:geolocator/geolocator.dart';
import 'package:nb_utils/nb_utils.dart';

import '../appConstants.dart';
import '../bottomNav/PatientAppointmentFragment.dart';
import '../signInScreen.dart';
import '../utils/appCommon.dart';

class ApiService {
  //192.168.1.138
  static String notiCount="";
  static String url ="http://192.168.0.102";
 // static String url ="http://192.168.1.138";
  static Future<loginInfo?> register
      (
      String file,
      String name,
      String username,
      String email,
      String mobile,
      String location,
      String password,
      String dob,
      String gender,

      ) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://admin.verzat.com/user-api/register.php'));
    request.fields.addAll({

      'type':  'user',
      'name': name,
      'username':  username,
      'email': email,
      'mobile': mobile,
      'location':  location,
      'password': password,
      'dob':  dob,
      'gender':  gender,
      'status': 'online'
    });
    request.files.add(await http.MultipartFile.fromPath('file',  file));
    var Stremresponse = await request.send();

    if (Stremresponse.statusCode == 200) {
      var response = await http.Response.fromStream(Stremresponse);
      final result = jsonDecode(response.body);
      return loginInfo.fromJson(result);
      print(result);
    } else {
      return null;
      print(Stremresponse.reasonPhrase);
    }
  }



  static Future<loginInfo?> login(String email, String password,String type) async {
    var request = http.MultipartRequest(
      //  'POST', Uri.parse(url+'/UserApi/login.php'));
        'POST', Uri.parse("https://admin.verzat.com/user-api/login.php"));
    request.fields.addAll({
      'email': email,
      'password': password,
      'type':type
    });

    var Stremresponse = await request.send();

    if (Stremresponse.statusCode == 200) {
      var response = await http.Response.fromStream(Stremresponse);
      final result = jsonDecode(response.body);
      return loginInfo.fromJson(result);
    } else {
      return null;
    }
  }

  static Future<BookSucessful?> bookAppointments
      (String userId,String doctorId,String patientName,patientAge,patientNumber,patientEmail,patientGender,
      apptDate,apptTime,bloodGroup,subject,description) async {
    var request = http.MultipartRequest('POST', Uri.parse('https://admin.verzat.com/user-api/bookAppointment.php'));
    request.fields.addAll({
      'userId': userId,
      'role': getStringAsync(USER_TYPE),
      'doctorId': doctorId,
      'patientName': patientName,
      'patientAge': patientAge,
      'patientNumber': patientNumber,
      'patientEmail': patientEmail,
      'patientGender': patientGender,
      'apptDate':  apptDate,
      'apptTime': apptTime,
      'bloodGroup': bloodGroup,
      'subject': subject,
      'description': description,
      'status': 'pending'
    });
    // request.files
    //     .add(await http.MultipartFile.fromPath('sendimage', sendimage));

    var Stremresponse = await request.send();

    if (Stremresponse.statusCode == 200) {
      var response = await http.Response.fromStream(Stremresponse);
      final result = jsonDecode(response.body);
      return BookSucessful.fromJson(result);
    } else {
      return null;
    }
  }



/*static Future<List<Msg>> getMsg() async {
    var request = http.MultipartRequest('POST', Uri.parse('http://192.168.0.104/UserApi/messages.php'));
    request.fields.addAll({
      'receiverId': '12'
    });
    logDev.log('1',name:"12");

    http.StreamedResponse response = await request.send();
    var response1 = await http.Response.fromStream(response);
    logDev.log('2',name:"12");

    var jsonData = json.decode(response1.body);
    var jsonArray = jsonData['msg'];
    List<Msg> msgList = [];
    logDev.log('3',name:"12");

    for (var item in jsonArray) {
      Msg msgs = Msg(
          id: item['id'],
          receiverId: item['receiverId'],
          senderId: item['senderId'],
          message: item['message'],
          messageDate: item['messageDate'],
          messageTime: item['messageTime']);
      msgList.add(msgs);
      logDev.log('4',name:"12");

    }
    return msgList;
  }*/
}

Future<Timers?> updateTime(String senderId, String receiverId,String time) async {
  var request = http.MultipartRequest(
      'POST', Uri.parse(ApiService.url+'/UserApi/updateTime.php'));
  request.fields.addAll({
    'senderId': senderId,
    'receiverId':receiverId,
    'doneTime': time
  });


  var Stremresponse = await request.send();

  if (Stremresponse.statusCode == 200) {
    var response = await http.Response.fromStream(Stremresponse);
    final result = jsonDecode(response.body);
    print("updateee");
    return Timers.fromJson(result);
  } else {
    print("updateee22");

    return null;

  }
}

Future<loginInfo?> editRegister( String id,String name,
     String email,
    String number,
    String city,
    String password,

    ) async {
  var request = http.MultipartRequest('POST', Uri.parse('https://admin.verzat.com/user-api/editProfile.php'));
  request.fields.addAll({
    'id': id,
    'name': name,
    'email': email,
    'mobile': number,
    'location': city,
    'password': password
  });

  // request.files.add(await http.MultipartFile.fromPath('photo',  file));
  var Stremresponse = await request.send();

  if (Stremresponse.statusCode == 200) {
    var response = await http.Response.fromStream(Stremresponse);
    final result = jsonDecode(response.body);
    return loginInfo.fromJson(result);
    print(result);
  } else {
    return null;
    print(Stremresponse.reasonPhrase);
  }
}
Future<loginInfo?> uploadPaymentInfo(
    String doctorID,String userID,String amount, String statusType,String? paymentID,String? orderId,String role
    )async{
  var request = http.MultipartRequest('POST',  Uri.parse('https://admin.verzat.com/user-api/paymentInfo.php'));
  request.fields.addAll({
    'doctorID': doctorID,
    'userID': userID,
    'role': role,
    'amount':  amount,
    'status': statusType,
    'paymentID': paymentID!,
    'orderID':  orderId!
  });

  var Stremresponse = await request.send();

  if (Stremresponse.statusCode == 200) {
    var response = await http.Response.fromStream(Stremresponse);
    final result = jsonDecode(response.body);
     return loginInfo.fromJson(result);

  } else {
    return null;
    print(Stremresponse.reasonPhrase);
  }

}
Future<loginInfo?> forgotPasswrd(String email, String password) async {
  var request = http.MultipartRequest('POST', Uri.parse('https://admin.verzat.com/user-api/forgotPassword.php'));
  request.fields.addAll({
    'email': email
    // 'password': password,
  });

  var Stremresponse = await request.send();

  if (Stremresponse.statusCode == 200) {
    var response = await http.Response.fromStream(Stremresponse);
    final result = jsonDecode(response.body);
    return loginInfo.fromJson(result);
  } else {
    return null;
  }
}


Future<List<Doctors>> getDoctors() async {
  var response =
  await http.get(Uri.parse("https://admin.verzat.com/user-api/doctorsList.php"));

  var jsonData = json.decode(response.body);
  var jsonArray = jsonData['doctors'];

  List<Doctors> docList = [];

  for (var item in jsonArray) {
    Doctors doctors = Doctors(
        id: item['id'],
        name: item['name'],
        lastName: item['lastName'],
        gender: item['gender'],
        email: item['email'],
        description: item['description'],
        exp: item['exp'],
        expertise: item['expertise'],
        hospital: item['hospital'],
        location: item['location'],
        number: item['mobile'],
        ratings: item['ratings']);

    docList.add(doctors);
  }
  return docList;
}

Future<List<Doctors>> getSearchDoctors(String text) async {
  // var response =
  // await http.get(Uri.parse(ApiService.url+'/UserApi/doctorsList.php'));
  var request = http.MultipartRequest('POST', Uri.parse("https://admin.verzat.com/user-api/searchList.php"));
  request.fields.addAll({
    'text':  text
  });
  var Stremresponse = await request.send();
  var response = await http.Response.fromStream(Stremresponse);

  var jsonData = json.decode(response.body);
  var jsonArray = jsonData['doctors'];

  List<Doctors> docList = [];

  for (var item in jsonArray) {
    Doctors doctors = Doctors(
        id: item['id'],
        name: item['name'],
        lastName: item['lastName'],
        gender: item['gender'],
        email: item['email'],
        description: item['description'],
        exp: item['exp'],
        expertise: item['expertise'],
        hospital: item['hospital'],
        location: item['location'],
        number: item['mobile'],
        ratings: item['ratings']);

    docList.add(doctors);
  }
  print('hey${docList.toString()}');
  return docList;
}
Future<List<CatList>> getCatList() async {
  // var response =
  // await http.get(Uri.parse(ApiService.url+'/UserApi/category.php'));
  //
  // var jsonData = json.decode(response.body);
  // var jsonArray = jsonData['catList'];

  List<CatList> catList = [];
   catList.add(CatList(categoryUrl:   "https://static.thenounproject.com/png/2683238-200.png", catName:  "Anxiety"));
   catList.add(CatList(categoryUrl:   "https://cdn-icons-png.flaticon.com/512/7145/7145185.png", catName:  "Depression"));
   catList.add(CatList(categoryUrl:   "https://cdn-icons-png.flaticon.com/512/4939/4939498.png", catName:  "Activity & Nutrition"));
   catList.add(CatList(categoryUrl:   "https://cdn.iconscout.com/icon/premium/png-256-thumb/obesity-1573349-1332894.png", catName:  "Over weight "));
   catList.add(CatList(categoryUrl:   "https://static.thenounproject.com/png/3199163-200.png", catName:  "Eye care"));
    catList.add(CatList(categoryUrl:   "https://cdn-icons-png.flaticon.com/512/7075/7075766.png", catName:  "Skin care"));
  catList.add(CatList(categoryUrl:   "https://cdn.iconscout.com/icon/premium/png-256-thumb/cardiology-2383070-2014925.png", catName:  "CardioLogy"));
  catList.add(CatList(categoryUrl:  "https://static.thenounproject.com/png/3627839-200.png", catName:  " Neurology"));
  catList.add(CatList(categoryUrl:  "https://cdn.iconscout.com/icon/free/png-256/dental-1537082-1302669.png", catName:  "Dental"));
  catList.add(CatList(categoryUrl:  "https://cdn.iconscout.com/icon/premium/png-256-thumb/ear-nose-throat-3281171-2750704.png", catName:  "ENT"));
  catList.add(CatList(categoryUrl:  "https://static.thenounproject.com/png/3429664-200.png", catName:  "Orthopaedic"));
   /*for (var item in jsonArray) {
       CatList list = CatList(categoryUrl: item['categoryUrl'],
       catName: item['catName']);


  }*/
  return catList;
}
class CatList {
  String? categoryUrl;
  String? catName;

  CatList({this.categoryUrl, this.catName});

  CatList.fromJson(Map<String, dynamic> json) {
    categoryUrl = json['categoryUrl'];
    catName = json['catName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryUrl'] = this.categoryUrl;
    data['catName'] = this.catName;
    return data;
  }
}
Future<Timers?> getTime(String senderId, String receiverId) async {
  var request = http.MultipartRequest(
      'POST', Uri.parse(ApiService.url+'/UserApi/getTime.php'));
  request.fields.addAll({
    'senderId': senderId,
    'receiverId':receiverId
  });


  var Stremresponse = await request.send();

  if (Stremresponse.statusCode == 200) {
    var response = await http.Response.fromStream(Stremresponse);
    final result = jsonDecode(response.body);
    return Timers.fromJson(result);
  } else {
    return null;
  }
}
Future<Timers?> setTime(String senderId, String receiverId,String time) async {
  var request = http.MultipartRequest(
      'POST', Uri.parse(ApiService.url+'/UserApi/setTime.php'));
  request.fields.addAll({
    'senderId': senderId,
    'receiverId':receiverId,
    'doneTime': time
  });


  var Stremresponse = await request.send();

  if (Stremresponse.statusCode == 200) {
    var response = await http.Response.fromStream(Stremresponse);
    final result = jsonDecode(response.body);
    print("setTime${result}");
    return Timers.fromJson(result);
  } else {
    return null;
  }
}

Future<List<Msg>> getMessages(String? currentUserId, String? receiverId) async {
   var type;
 if(getStringAsync(USER_TYPE)=="user"){
   type="doctor";

 }else{
   type="user";
 }
  var request = http.MultipartRequest('POST', Uri.parse('https://admin.verzat.com/user-api/messages.php'));
  request.fields.addAll({
    'receiver_type': type,
    'sender_type': getStringAsync(USER_TYPE),
    'sender_id': currentUserId!,
    'receiver_id': receiverId!
  });

  logDev.log('1',name:"12");

  http.StreamedResponse response = await request.send();
  var response1 = await http.Response.fromStream(response);
  logDev.log('2',name:"12");

  var jsonData = json.decode(response1.body);
  var jsonArray = jsonData['msg'];
  List<Msg> msgList = [];
  print(jsonArray);
  logDev.log('3',name:"27-12");

  for (var item in jsonArray) {
    Msg msg = Msg(
        id: item['id'],
        receiverId: item['receiver_id'],
        senderId: item['sender_id'],
        message: item['message'],
        messageDate: item['messageDate'],
         messageTime: item['messageTime']);

    msgList.add(msg);
    logDev.log('4',name:"27-12");

  }
  logDev.log('5',name:"27-12");
  return msgList;

}

Future<MsgSend?> sendMsg(String msg , String senderId,String receiverId) async{
  var request = http.MultipartRequest('POST', Uri.parse('https://admin.verzat.com/user-api/send_messages.php'));
  request.fields.addAll({
    'message': msg,
    'sender_id': senderId,
    'receiver_id': receiverId,
    'type':getStringAsync(USER_TYPE)
  });


  var Stremresponse = await request.send();

  if (Stremresponse.statusCode == 200) {
    var response = await http.Response.fromStream(Stremresponse);
    final result = jsonDecode(response.body);
    return  MsgSend.fromJson(result);
  } else {
    return null;
  }

}
Future<void> profileListCreate(String? senderID,String? receiverID )async {
  var request = http.MultipartRequest('POST', Uri.parse('https://admin.verzat.com/user-api/profileList.php'));
  request.fields.addAll({
    'sender_id': senderID!,
    'receiver_id': receiverID!
  });


  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
    print("27-12-Dec");
  }
  else {
    print(response.reasonPhrase);
  }

}
Future<void> setBook(String id ) async{
  var request = http.MultipartRequest('POST', Uri.parse('https://admin.verzat.com/user-api/setBook.php'));
  request.fields.addAll({
    'id': id
  });


  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
  }
  else {
    print(response.reasonPhrase);
  }
}


class BookSucessful {
  String? message;
  String? status;

  BookSucessful({this.message, this.status});

  BookSucessful.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class MsgSend {
  String? msg;
  bool? msgSend;

  MsgSend({this.msg, this.msgSend});

  MsgSend.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    msgSend = json['msgSend'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['msgSend'] = this.msgSend;
    return data;
  }
}
class loginInfo {
  String? token;
  String? error;
  String? id;
  String? type;
  String? message;
  String? name;
  String? email;
  String? address;
  String? city;
  String? state;
  String? lastName;
  String? photo;
  String? mobile;
  String? file;



  loginInfo(this.token, this.error, this.id,this.type, this.message, this.email,this.name,
      this.address, this.city, this.state, this.lastName, this.photo,this.mobile);

  loginInfo.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    error = json['error'];
    id = json['id'];
    type = json['type'];
    message = json['message'];
    email = json['email'];
    name = json['name'];
    city = json['city'];
    state = json['state'];
    lastName = json['lastName'];
    photo = json['photo'];
    mobile = json['mobile'];
    file = json['file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['error'] = this.error;
    data['id'] = this.id;
    data['message'] = this.message;

    return data;
  }
}
class GetAllDoctorsList {
  List<Doctors>? doctors;

  GetAllDoctorsList({this.doctors});

  GetAllDoctorsList.fromJson(Map<String, dynamic> json) {
    if (json['doctors'] != null) {
      doctors = <Doctors>[];
      json['doctors'].forEach((v) {
        doctors!.add(new Doctors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.doctors != null) {
      data['doctors'] = this.doctors!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Doctors {
  String? id;
  String? name;
  String? lastName;
  String? gender;
  String? exp;
  String? expertise;
  String? hospital;
  String? location;
  String? ratings;
  String? number;
  String? description;
  String? email;


  Doctors(
      {
        this.id,
        this.name,
        this.lastName,
        this.gender,
        this.exp,
        this.expertise,
        this.hospital,
        this.location,
        this.ratings,
        this.number,
        this.description,
        this.email});

  Doctors.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lastName = json['lastName'];
    gender = json['gender'];
    exp = json['exp'];
    expertise = json['expertise'];
    hospital = json['hospital'];
    location = json['location'];
    ratings = json['ratings'];
    number = json['mobile'];
    description = json['description'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['lastName'] = this.lastName;
    data['gender'] = this.gender;
    data['exp'] = this.exp;
    data['expertise'] = this.expertise;
    data['hospital'] = this.hospital;
    data['location'] = this.location;
    data['ratings'] = this.ratings;
    data['number'] = this.number;
    data['description'] = this.description;
    data['email'] = this.email;
    return data;
  }
}
class Msg {
  String? id;
  String? receiverId;
  String? senderId;
  String? message;
  String? messageDate;
  String? messageTime;

  Msg(
      {this.id,
        this.receiverId,
        this.senderId,
        this.message,
        this.messageDate,
        this.messageTime});

  Msg.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    receiverId = json['receiver_id'];
    senderId = json['sender_id'];
    message = json['message'];
    messageDate = json['messageDate'];
    messageTime = json['messageTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['receiver_id'] = this.receiverId;
    data['sender_id'] = this.senderId;
    data['message'] = this.message;
    data['messageDate'] = this.messageDate;
    data['messageTime'] = this.messageTime;
    return data;
  }
}
class AppointmentSlotModel {
  String? time;
  bool? available;
  bool isSelected = false;

  AppointmentSlotModel({this.time, this.available});

  AppointmentSlotModel.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    available = json['available'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['available'] = this.available;
    return data;
  }
}
class ServiceData {
  String? charges;
  String? doctor_id;
  String? id;
  String? name;
  String? service_id;
  String? status;
  String? type;
  String? mapping_table_id;
  bool isCheck;

  ServiceData({this.charges, this.doctor_id, this.id, this.name, this.service_id, this.status, this.type, this.mapping_table_id, this.isCheck = false});

  factory ServiceData.fromJson(Map<String, dynamic> json) {
    return ServiceData(
      charges: json['charges'],
      doctor_id: json['doctor_id'],
      id: json['id'],
      name: json['name'],
      service_id: json['service_id'],
      status: json['status'],
      type: json['type'],
      mapping_table_id: json['mapping_table_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['charges'] = this.charges;
    data['doctor_id'] = this.doctor_id;
    data['id'] = this.id;
    data['name'] = this.name;
    data['service_id'] = this.service_id;
    data['status'] = this.status;
    data['type'] = this.type;
    data['mapping_table_id'] = this.mapping_table_id;
    return data;
  }
}

class GenderModel {
  String? name;
  IconData? icon;
  String? value;

  GenderModel({this.name, this.icon, this.value});
}
class UpcomingAppointment {
  String? appointment_end_date;
  String? appointment_end_time;
  String? appointment_start_date;
  String? appointment_start_time;
  String? clinic_id;
  String? clinic_name;
  String? created_at;
  String? description;
  String? doctor_id;
  String? doctor_name;
  String? encounter_id;
  String? id;
  String? patient_id;
  String? patient_name;
  String? status;
  String? visit_label;
 // List<VisitType>? visit_type;
 // ZoomData? zoomData;
  int? all_service_charges;
 // List<AppointmentReport>? appointment_report;
  String? discount_code;
  bool? video_consultation;

  UpcomingAppointment(
      {this.appointment_end_date,
        this.appointment_end_time,
        this.appointment_start_date,
        this.appointment_start_time,
        this.clinic_id,
        this.clinic_name,
        this.created_at,
        this.description,
        this.doctor_id,
        this.doctor_name,
        this.encounter_id,
        this.id,
        this.patient_id,
        this.patient_name,
        this.status,
        this.visit_label,
        // this.visit_type,
        // this.zoomData,
        this.all_service_charges,
      //  this.appointment_report,
        this.discount_code,
        this.video_consultation});

  factory UpcomingAppointment.fromJson(Map<String, dynamic> json) {
    return UpcomingAppointment(
      appointment_end_date: json['appointment_end_date'],
      appointment_end_time: json['appointment_end_time'],
      appointment_start_date: json['appointment_start_date'],
      appointment_start_time: json['appointment_start_time'],
      clinic_id: json['clinic_id'],
      clinic_name: json['clinic_name'],
      created_at: json['created_at'],
      description: json['description'],
   //   appointment_report: json['appointment_report'] != null ? (json['appointment_report'] as List).map((i) => AppointmentReport.fromJson(i)).toList() : [],
      doctor_id: json['doctor_id'],
      discount_code: json['discount_code'],
      doctor_name: json['doctor_name'],
      encounter_id: json['encounter_id'],
      id: json['id'],
      all_service_charges: json['all_service_charges'],
      patient_id: json['patient_id'],
      patient_name: json['patient_name'],
      status: json['status'],
      visit_label: json['visit_label'],
      // visit_type: json['visit_type'] != null
      //     ? (json['visit_type'] is String)
      //     ? json['visit_type']
      //     : (json['visit_type'] as List).map((i) => VisitType.fromJson(i)).toList()
      //     : null,
      //zoomData: json['zoom_data'] != null ? new ZoomData.fromJson(json['zoom_data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appointment_end_date'] = this.appointment_end_date;
    data['appointment_end_time'] = this.appointment_end_time;
    data['appointment_start_date'] = this.appointment_start_date;
    data['appointment_start_time'] = this.appointment_start_time;
    data['clinic_id'] = this.clinic_id;
    data['clinic_name'] = this.clinic_name;
    data['created_at'] = this.created_at;
    data['description'] = this.description;
    data['doctor_id'] = this.doctor_id;
    data['doctor_name'] = this.doctor_name;
    data['encounter_id'] = this.encounter_id;
    data['id'] = this.id;
    data['patient_id'] = this.patient_id;
    data['all_service_charges'] = this.patient_id;
    data['patient_name'] = this.patient_name;
    data['status'] = this.status;
    data['discount_code'] = this.discount_code;

    return data;
  }
}





class News {
  String? image;
  String? postDate;
  String? postTitle;
  String? postContent;

  News({this.image, this.postDate, this.postTitle, this.postContent});

  News.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    postDate = json['post_date'];
    postTitle = json['post_title'];
    postContent = json['post_content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['post_date'] = this.postDate;
    data['post_title'] = this.postTitle;
    data['post_content'] = this.postContent;
    return data;
  }
}
Future<List<News>> getNews() async{
  var response =
  await http.get(Uri.parse(ApiService.url+'/UserApi/news.php'));

  var jsonData = json.decode(response.body);
  var jsonArray = jsonData['news'];

  List<News> newsList = [];

  for (var item in jsonArray) {
    News news = News(
        image: item['image']
    ,postDate: item['postDate']
    ,postTitle: item['postTitle']
    ,postContent: item['postContent']);

    newsList.add(news);
  }
  return newsList;
}

class Timers {
  String? error;
  String? doneTime;

  Timers({this.error, this.doneTime});

  Timers.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    doneTime = json['doneTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['doneTime'] = this.doneTime;
    return data;
  }
}
Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    await Geolocator.openAppSettings();
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

Future<void> logout(BuildContext context) async {
  await removeKey(TOKEN);
  await removeKey(USER_ID);
  await removeKey(USER_NAME);
  await removeKey(USER_EMAIL);
  await removeKey(USER_DISPLAY_NAME);
  await removeKey(PROFILE_IMAGE);
  await removeKey(USER_MOBILE);
  await removeKey(USER_GENDER);
  await removeKey(USER_ROLE);
  await removeKey(USER_CITY);
  await removeKey(PASSWORD);
  await removeKey(USER_TIME);
  await removeKey(USER_LOCATION);
  await removeKey(USER_TYPE);
  await removeKey(IS_LOGGED_IN);

  //appStore.setLoggedIn(false);
  push(SignInScreen(), isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
}
Future<bool> connectivityChecker()   async {
  var connected = false;
  print("Checking internet...");
  try {
    final result = await InternetAddress.lookup('google.com');
    final result2 = await InternetAddress.lookup('facebook.com');
    final result3 = await InternetAddress.lookup('microsoft.com');
    if ((result.isNotEmpty && result[0].rawAddress.isNotEmpty) ||
        (result2.isNotEmpty && result2[0].rawAddress.isNotEmpty) ||
        (result3.isNotEmpty && result3[0].rawAddress.isNotEmpty)) {
    //  print('connected..');
      connected = true;
    } else {
    //  print("not connected from else..");
      connected = false;
    }
  } on SocketException catch (_) {
  //  print('not connected...');
    connected = false;
  }
  return connected;
}
Future<List<Appointments>> getNotificaton( ) async {
  var request = http.MultipartRequest('POST', Uri.parse('https://admin.verzat.com/user-api/appStatus.php'));
  request.fields.addAll({
    'userID': getStringAsync(USER_ID),

  });


  http.StreamedResponse response = await request.send();

  var response1 = await http.Response.fromStream(response);
  List<Appointments> apptmntList = [];
  var appList = jsonDecode( response1.body);
 // print("hiii${ appList }");
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
        fees: item['fees'],
        count:item['count'].toString()

    );

    apptmntList.add(appointments);
  //  ApiService.notiCount = apptmntList.length.toString();

  }


  return apptmntList;
}
/*

Future<String> count()
async {
  var countNum;
 var num = await getNotificaton();
 for(var item in num){
   countNum = item.count.toString();
   print(countNum+"ggg");
 }
  return countNum;
}
Future<String> status()
async {
  var countNum;
  var num = await getNotificaton();
  for(var item in num){
    countNum = item.status.toString();
    print(countNum+"ggg");
  }
  return countNum;
}
*/

