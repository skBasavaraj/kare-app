import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'package:nb_utils/nb_utils.dart';

import '../network/apiService.dart';
import '../screens/ApointmentscreenBooking.dart';
import '../screens/doctorDetilas2.dart';
import '../utils/appCommon.dart';
import '../utils/color_use.dart';

class FeedListFragment extends StatefulWidget {


  @override
  _FeedListFragmentState createState() => _FeedListFragmentState();
}

class _FeedListFragmentState extends State<FeedListFragment> {
  bool descTextShowFlag = false;
  int charLength = 0;
  double? ratingBarValue;
  TextEditingController searchCont = TextEditingController();
  @override
  void initState() {
    searchCont.text ="";
     super.initState();
  }


  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
   return    Scaffold(
      backgroundColor: scaffoldBgColor,
      body: Container(
        child:   Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20),
              child: AppTextField(
                onChanged: _onChanged,
                textStyle: primaryTextStyle(
                    color:   Colors.black),
                controller: searchCont,
                textAlign: TextAlign.start,
                textFieldType: TextFieldType.NAME,
                decoration: speechInputWidget(context,
                    hintText:  "Search a doctor or specialization or location",
                    iconColor: primaryColor
                ),
              ),
            ),
           Expanded(
               flex: 1,
               child:FutureBuilder<List<Doctors>>(
          future:getSearchDoctors(searchCont.text) ,
        builder: (context, snapshot) {
        if (snapshot.data == null) {
          // logDev.log(snapshot.data.toString(),name:"show");
          return Container(
             child:  Lottie.network(
              'https://assets2.lottiefiles.com/packages/lf20_bo8vqwyw.json'),

          );
        } else {
          List<Doctors>? doctors = snapshot.data;

          return ListView.builder(
            shrinkWrap: true,
            addAutomaticKeepAlives:true,

            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              return  topDoctorList(doctors![index]);

            },
          );
        }
        },
      ))
          ],
        ),
      ),

    );

  }
 Widget topDoctorList(Doctors doctor) {

    return
      Padding(
        padding:   EdgeInsets.only(left: 20,right: 20,top: 10),
        child: Material(
          color: Colors.white,
          elevation: 3,
          animationDuration: ScrollDragController.momentumRetainStationaryDurationThreshold,
          borderRadius: BorderRadius.circular(10),
          child:  Ink(


            height: 130,
            width: double.infinity,
            child: InkWell(
              splashColor: Colors.blue.shade100,
              onTap: () {
                DetailsDoctors(doctor).launch(context,pageRouteAnimation: PageRouteAnimation.Slide);
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
                                     ApointmentScreen(doctor).launch(context,pageRouteAnimation: PageRouteAnimation.SlideBottomTop,duration: Duration(milliseconds: 1000));

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
  @override
  void dispose() {
  //Navigator.pop(context);
     super.dispose();
  }
  _onChanged(String value) {
    setState(() {
      charLength = value.length;
      if(charLength>=0) {

       // searchCont.clear();
      }else if(charLength==0){

      }
    });
  }
}
