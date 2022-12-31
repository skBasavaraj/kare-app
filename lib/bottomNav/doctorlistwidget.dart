import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:nb_utils/nb_utils.dart';
import 'package:zatcare/utils/color_use.dart';

import '../appConstants.dart';
import '../network/apiService.dart';
import '../screens/ApointmentscreenBooking.dart';
import '../screens/DoctorDetails.dart';
import '../screens/doctorDetilas2.dart';



class DoctorListWidget extends StatefulWidget {
  @override
  _DoctorListWidgetState createState() => _DoctorListWidgetState();
}

class _DoctorListWidgetState extends State<DoctorListWidget> {
 double? ratingBarValue;
  int selectedDoctor = -1;
  int page = 1;

  bool isLastPage = false;
  bool isReady = false;

  // List<DoctorList> doctorList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (dynamic n) {
        if (!isLastPage && isReady) {
          if (n is ScrollEndNotification) {
            page++;
            isReady = false;

            setState(() {});
          }
        }
        return !isLastPage;
      }, child: Container(
      color: scaffoldBgColor,
      child: FutureBuilder<List<Doctors>>(
        future: getSearchDoctors(getStringAsync(USER_CITY)),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            // logDev.log(snapshot.data.toString(),name:"show");
            return CircularProgressIndicator();
          } else {
            List<Doctors>? doctors = snapshot.data;

            return ListView.builder(
              shrinkWrap: true,
              addAutomaticKeepAlives:true,

              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return  topDoctorList(doctors![index]);
                /*  Container(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 5.0,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 6, bottom: 6, right: 2),
                        child: ListTile(
                          title: Text("Dr." + doctors![index].name!,
                              style: const TextStyle(fontSize: 18)),
                          subtitle: Container(
                            child: (Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    "Specialists: " +
                                        doctors[index].expertise!,
                                    style:
                                    const TextStyle(fontSize: 16)),
                                Text("Exps: " + doctors[index].exp!,
                                    style:
                                    const TextStyle(fontSize: 14)),
                                Text(
                                    "Location: " +
                                        doctors[index].hospital!,
                                    maxLines: 1,
                                    style:
                                    const TextStyle(fontSize: 12)),
                              ],
                            )),
                          ),
                          leading: Container(
                              alignment: Alignment.centerLeft,
                              height: 200,
                              width: 100,
                              child: Image.asset(
                                  'images/doctorAvatars/docpic.jpg',
                                  height: 200,
                                  width: 100,
                                  fit: BoxFit.cover).cornerRadiusWithClipRRect(
                                  defaultRadius)
                          ),
                          hoverColor: Colors.lightBlue,
                          horizontalTitleGap: 4.0,
                          onTap: () {
                           DoctorDetails(doctors![index]).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                          },
                        ),
                      ),
                    ),
                  ),
                );*/
              },
            );
          }
        },
      ),

    ),


    );
  }
  Widget topDoctorList(Doctors doctor) {
    return
      Padding(
        padding:   EdgeInsets.all(8.0),
        child: Material(
          color: Colors.white,
          elevation: 3,
          animationDuration: ScrollDragController.momentumRetainStationaryDurationThreshold,
          borderRadius: BorderRadius.circular(10),
          child:  Ink(


            height: 130,
            width: double.infinity,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),

              splashColor: Colors.blue.shade100,
              onTap: () {

              },
              child: Row(

                children:   [
                  Padding(
                    padding:   EdgeInsets.only(left: 5,right: 5,top: 2,bottom: 8),
                    child:ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        'https://img.freepik.com/free-photo/doctor-with-his-arms-crossed-white-background_1368-5790.jpg?w=2000',
                        width: 75,
                        height: 110,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 4,),
                  Expanded(
                    child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Padding(
                          padding: const EdgeInsets.only(left: 5,),
                          child: Text(
                            "Dr.${doctor.name}"
                            ,style: GoogleFonts.poppins(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.blue),overflow: TextOverflow.ellipsis, ),
                        ).paddingTop(1)

                        ,SizedBox(height: 2,)
                        ,

                        Expanded
                          (
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text("${doctor.hospital}${doctor.location}",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.blue
                                  ,

                                ),overflow: TextOverflow.ellipsis),
                          ),
                        )

                        ,

                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Container(
                            child: RatingBar.builder(
                              onRatingUpdate: (newValue) =>
                                  setState(() => ratingBarValue = newValue),
                              itemBuilder: (context, index) => Icon(
                                Icons.star_rounded,
                                color: Color(0xFF0A82CE),
                              ),
                              direction: Axis.horizontal,
                              initialRating: ratingBarValue ??= doctor.ratings.toDouble(),
                              unratedColor: Color(0x68B6B6B9),
                              itemCount: 5,
                              itemSize: 15,
                              glowColor: Color(0xFF0A82CE),
                            ).paddingBottom(14),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),shape: BoxShape.rectangle,border: Border.all(color: Colors.blue,width: 1)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  AutoSizeText("Available",style: GoogleFonts.poppins(
                                    fontSize: 12,color: Colors.blue,
                                  ),)
                                  , Padding(
                                    padding: const EdgeInsets.only(left: 3,right: 3),
                                    child: AutoSizeText("7am - 10 am",style: GoogleFonts.poppins(
                                      fontSize: 12,color: Colors.blue,
                                    ),),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding:   EdgeInsets.only(right: 10,bottom: 5),
                              child:Material(
                                elevation: 5,
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blue.shade300,
                                child: InkWell(
                                  splashFactory: InkRipple.splashFactory,
                                  splashColor: Colors.white,
                                  onTap: () {
                                    DetailsDoctors(doctor).launch(context,pageRouteAnimation: PageRouteAnimation.Scale);

                                  },
                                  child:  Container(
                                      height: 30,
                                      width: 100,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
                                      child:
                                      Center(child: Text("Book",style: GoogleFonts.poppins(fontSize: 12,fontWeight:FontWeight.bold,color: Colors.white),))),
                                ),
                              ),
                            )
                          ],
                        ).paddingOnly(bottom: 5,left: 10)

                      ],
                    ).paddingOnly(bottom: 3),
                  )
                ],
              ),
            ),
          ),
        ),
      );
  }
}

//