import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';

import '../bottomNav/PatientAppointmentFragment.dart';
import '../network/apiService.dart';
import '../utils/color_use.dart';
import 'ApointmentscreenBooking.dart';
class UserNotification extends StatefulWidget {
  const UserNotification({Key? key}) : super(key: key);

  @override
  State<UserNotification> createState() => _UserNotificationState();
}

class _UserNotificationState extends State<UserNotification> {
  List<Appointments>? _app;
  ScrollController _controller = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 30,
                    child: Icon(Icons.arrow_back,color: Colors.black,size: 30,),
                  ),
                ),
              ),
              FutureBuilder<List<Appointments>?>(
                future: getNotificaton( ),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    // logDev.log(snapshot.data,PatientName:"123");
                    print(snapshot.data);
                    return Lottie.network(
                      "https://assets2.lottiefiles.com/packages/lf20_eMqO0m.json",
                      height: 400,
                      width: 200,
                    );
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
                        print("kkl"+_app![index].patientName! );
                        return  appointments(_app![index]);
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),

    );
  }
  appointments(Appointments appointments) {
   // bool buttonenabled = false;
     if (appointments.status == "approved") {
      return
        InkWell(
          onTap:() {
             Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>  PatientAppointmentFragment()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Card(
              elevation: 5,
              shadowColor: Colors.green,
              color: Colors.blue.shade500,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),side: BorderSide(color: Colors.green,width: 1)),
          /*  decoration: BoxDecoration(
              border: Border.all(color: Colors.green,width: 1),
                 borderRadius: BorderRadius.circular(10), color: Colors.blue.withOpacity(0.3)),
            margin: EdgeInsets.all(10),*/

            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(10),border: Border.all(width: 1,color: Colors.green)),

                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(Icons.check,size: 30,color: Colors.green,),
                      )),
                )
                ,Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: [
                     Text("Make Payment Confirm Book",style: GoogleFonts.jost(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),)
                   ,  Text("Dr.${appointments.name}",style: GoogleFonts.jost(fontSize: 16,color: Colors.white),)

                   ],
                )

              ],
            ),
      ),
          ),
        );
    } else if (appointments.status == "booked") {
      return
        InkWell(
          onTap:() {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>  PatientAppointmentFragment()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Card(
              elevation: 5,
              shadowColor: Colors.blue,
              color: Colors.green.shade500,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),side: BorderSide(color: Colors.blue,width: 1)),
              /*  decoration: BoxDecoration(
              border: Border.all(color: Colors.green,width: 1),
                 borderRadius: BorderRadius.circular(10), color: Colors.blue.withOpacity(0.3)),
            margin: EdgeInsets.all(10),*/

              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(10),border: Border.all(width: 1,color: Colors.blue)),

                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(Icons.check,size: 30,color: Colors.blue,),
                        )),
                  )
                  ,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Today Your's Appointment",style: GoogleFonts.jost(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),)
                      ,  Text("Dr.${appointments.name}",style: GoogleFonts.jost(fontSize: 16,color: Colors.white),)
                      ,  Text("Hospital:${appointments.hospital}",style: GoogleFonts.jost(fontSize: 14,color: Colors.white),)
                      ,  Text("Address:${appointments.location}",style: GoogleFonts.jost(fontSize: 12,color: Colors.white),)
                      ,  Text("Contact:${appointments.mobile}",style: GoogleFonts.jost(fontSize: 10,color: Colors.white),)

                    ],
                  ).paddingSymmetric(vertical: 5)

                ],
              ),
            ),
          ),
        );
    } else {
      NoDataFoundWidget();
    }
  }
}
