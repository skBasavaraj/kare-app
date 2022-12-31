import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';

import '../bottomNav/PatientAppointmentFragment.dart';
import '../bottomNav/topWidget.dart';
import '../network/apiService.dart';
import '../network/doctorApiService.dart';
import '../utils/color_use.dart';
import '../utils/marqeeWidget.dart';
import 'ApointmentscreenBooking.dart';

class UserNotification extends StatefulWidget {
  const UserNotification({Key? key}) : super(key: key);

  @override
  State<UserNotification> createState() => _UserNotificationState();
}

class _UserNotificationState extends State<UserNotification> {
  List<Notifications>? _app;
  ScrollController _controller = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 0,
              child:
              Padding(
                padding: EdgeInsets.only(
                   top: 0,
                ),
                child: Material(
                  elevation: 2,
                   color: Colors.blue,
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(

                              child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 30,
                          )
                          ,onTap: () {
                            pop(context);
                          },).paddingOnly(top: 8,bottom:8,left: 10),
                          5.width,
                          Text("Notifications",
                              style: GoogleFonts.jost(fontSize: 20,color: Colors.white)),
                        ],
                      ),
                      Container(
                        width: 100,
                        height: 30,
                        child: FutureBuilder<List<Notifications>>(
                          future: getNotificaton(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              _app = snapshot.data;

                              print(snapshot.data);
                              return markButton(_app);
                            }
                            return Text(" ");
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: SingleChildScrollView(
                child: FutureBuilder<List<Notifications>>(
                  future: getNotificaton(),
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
                        reverse: true,
                        physics: NeverScrollableScrollPhysics(),
                        // new
                        scrollDirection: Axis.vertical,
                        controller: _controller,
                        padding: EdgeInsets.all(0),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          // print("kkl"+_app![index].patientName! );
                          return appointments(_app![index]);
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  appointments(Notifications notifications) {
    return
      Material(
      elevation: 1,
      color: Colors.white,
      borderRadius: BorderRadius.circular(0),
      child: InkWell(
        borderRadius: BorderRadius.circular(0),
        onTap: () {

        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(width: 1, color: Colors.grey)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.grey,
                    ),
                  )),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notifications.name!,
                  style: GoogleFonts.jost(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ).paddingOnly(top: 5, right: 0, bottom: 5),
                Container(
                    width: 260,
                    child: Text(
                      notifications.activityB!,
                      style: GoogleFonts.jost(
                          fontSize: 16,
                          color: Colors.black.withOpacity(0.8),
                          letterSpacing: 0.2,
                          wordSpacing: 0.4,
                          height: 1),
                      maxLines: 3,
                    )).paddingBottom(5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 15, top: 4, bottom: 5),
                      child: Text(notifications.dateN!,
                          style: GoogleFonts.jost(
                              fontSize: 12,
                              color: Colors.black54,
                              fontWeight: FontWeight.normal)),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 15, top: 4, bottom: 5),
                      child: Text(notifications.timeN!,
                          style: GoogleFonts.jost(
                              fontSize: 12,
                              color: Colors.black54,
                              fontWeight: FontWeight.normal)),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 15, top: 4, bottom: 4),
                      child: Text(notifications.status!,
                          style: GoogleFonts.jost(
                              fontSize: 12,
                              color: Colors.black54,
                              fontWeight: FontWeight.normal)),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    ).paddingOnly(top: 0, left: 0, bottom: 0);
  }

  Widget markButton(List<Notifications>? app) {
    if (app?.last!.status == "not seen") {
      return Material(
          color: Colors.blue,
          child: InkWell(
            onTap: ()   {
              updateSeen();
            },
            child: Center(
                child: Text(
              "mark as read ",style: GoogleFonts.jost(color:Colors.white),
            )),
          ));
    } else {
      return Container(
        height: 40,
        child: Center(
            child: Text(
          "mark as read",
          style: GoogleFonts.jost(fontSize: 14, color: Colors.grey),
        )),
      );
    }
  }
 void updateSeen() async {
    await updateNotification();
      setState(() {
    
      });

  }
}
