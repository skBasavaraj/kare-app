import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
 import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'dart:developer'as logDev;
//import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../appConstants.dart';
import '../bottomNav/PatientAppointmentFragment.dart';
import '../network/apiService.dart';
import 'PaymentPendingList.dart';

class CheckOut extends StatefulWidget {
  Appointments? appointments;

  CheckOut(
      this.appointments); // const CheckOut(Appointments appointments, {Key? key}) : super(key: key);

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  static String? statusPay;
    Razorpay? _razorpay ;

  @override
  void initState() {
    super.initState();
     _razorpay = Razorpay();

      _pay(widget.appointments!.name!,
           widget.appointments!.patientName!);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
         body:Container(),
    );
  }

  _pay(String doctorName, String  patientName) {


    var options = {
      'key': 'rzp_live_ILgsfZCZoFIKMb',
      'amount': 100,
      'name': 'Dr.'+doctorName,
     // 'order_id': 'order_EMBFqjDHEE312h',
      'description': getStringAsync(USER_NAME) ,
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': "91"+getStringAsync(USER_MOBILE), 'email': ''+getStringAsync(USER_EMAIL)},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay!.open(options);
    }catch(e){
      print("jk"+e.toString());
    }
  }


  _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print("paymentId"+response.paymentId!);
    print( response.paymentId);
   await uploadPaymentInfo( widget.appointments!.appointmentId!,widget.appointments!.doctorID!,widget.appointments!.userID!,
       widget.appointments!.fees!,
       'success',response.paymentId!,widget.appointments!.appointmentId!,widget.appointments!.role!);

    await setBook(widget.appointments!.id!);
      statusPay = "done";

    Navigator.pop(context);
    print('widget.appointments!.appointmentId!${widget.appointments!.appointmentId!}');

  }
  _handlePaymentError(PaymentFailureResponse response)    {
    statusPay = "000";
    print(response.message);
    print(statusPay);


  }

  _handleExternalWallet(ExternalWalletResponse response)   {
    statusPay = "000";
    print(response);
    print(statusPay);


  }
  @override
  void dispose() {
    super.dispose();
   _razorpay?.clear(); //
  }


}
