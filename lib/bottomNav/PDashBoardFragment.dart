 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hovering/hovering.dart';
 import 'dart:io' show Platform, exit;
import 'package:nb_utils/nb_utils.dart';
import 'dart:developer' as logDev;
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:auto_size_text/auto_size_text.dart';

import '../appConstants.dart';
import '../network/apiService.dart';
import '../screens/DoctorDetails.dart';
import '../screens/doctorDetilas2.dart';
import '../screens/search.dart';
import '../utils/appCommon.dart';
import '../utils/color_use.dart';



class PDashBoardFragment extends StatefulWidget {
  @override
  _PDashBoardFragmentState createState() => _PDashBoardFragmentState();
}

class _PDashBoardFragmentState extends State<PDashBoardFragment> {
  int charLength = 0;
  double?  ratingBarValue;
  TextEditingController searchCont = TextEditingController();
   Color _color = Colors.white;
  List<String> name = [];
  List<String> hospital = [];
  List<String>  active = [];
  List<Doctors> doctorsList=[];
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
  void dispose() {

    super.dispose();
  }

  Widget patientTotalDataComponent() {
    return FutureBuilder<List<Doctors>>(
      future: getDoctors(),
      builder: (context, snapshot) {
        if(snapshot.data == null){
          logDev.log(snapshot.data.toString(),name:"show");
          return Lottie.network('https://assets9.lottiefiles.com/packages/lf20_MkWLYjEq5l.json',height: 20);
          //Text("LOading...",style: GoogleFonts.poppins(color: Colors.blue,fontSize: 20),);
        }else {
          List<Doctors>? list = snapshot.data;

          return Container(
            height: 150,
                child: Center(
                  child: ListView.builder(itemCount: snapshot.data!.length,

               shrinkWrap: true,

              itemBuilder: (BuildContext context, int index) {
                  return  topList (list![index]) ;

              },

        scrollDirection: Axis.horizontal,
            ),
                ),
          );
        }
      },
    );
  }

  Widget patientSymptomsComponent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Specialists',
                style: GoogleFonts.poppins(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () {
                //  CategoryScreen(service: service).launch(context);
              },
              child: Text("See all",
                  style: secondaryTextStyle(color:  Colors.blue)),
            )
            //.visible(service.length >= 7),
          ],
        ).paddingSymmetric(horizontal: 8),
        14.height,
      /*  Wrap(
          direction: Axis.horizontal,
          spacing: 16,
          runSpacing:
          16,

        ).paddingSymmetric(horizontal: 4),*/
         Container(
          height: 50,

          child: FutureBuilder<List<CatList>>(
            future:getCatList(),
            builder: (context, snapshot) {
              if(snapshot.data == null){
                logDev.log(snapshot.data.toString(),name:"show");
                return Lottie.network('https://assets9.lottiefiles.com/packages/lf20_MkWLYjEq5l.json',height: 20);
                //Text("LOading...",style: GoogleFonts.poppins(color: Colors.blue,fontSize: 20),);
              }else {
                List<CatList>? list = snapshot.data;

                return ListView.builder(itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return categoryList( list![index]) ;

                  },
                  scrollDirection: Axis.horizontal,);
              }
            },
          ) ,
        )
      ],
    );
  }
  Widget categoryList(CatList list){
    print("list${list!.categoryUrl}");
 
    
    return
      Padding(
        padding: const EdgeInsets.only(left: 10,right: 10,bottom: 5,top:10),
        child: Material(
          shadowColor: Colors.white,
          elevation: 5,
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          child: Ink(

            child: InkWell(
              splashColor: Colors.blue,

              onTap: () {
                print(list.catName);
              //  _color =Colors.blueAccent;
                  SearchScreen(list.catName).launch(context,pageRouteAnimation: PageRouteAnimation.Scale);
              },
              child:
              Center(
                child: Container(
                   width: 130,
                  height: 30,

                  child: Center(
                    child: Padding(
                      padding:   EdgeInsets.only(left: 10,right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.network(list.categoryUrl! ,height: 30,width: 25)
                      , SizedBox(width: 5),

                          Expanded(child: Text(list.catName!,style: TextStyle(fontSize: 14,color: Colors.blue,overflow: TextOverflow.ellipsis,fontWeight: FontWeight.w400),))

                        ],
                      ),
                    ),
                  ),
                ),
              )
              /*Container(
                height: 80,
                width: 110,
                decoration: BoxDecoration(boxShadow:[BoxShadow(
                    color: Colors.transparent
                    ,blurRadius: 5,spreadRadius: 5

                )]),


                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,

                  children: [
                    Card(
                      color:Colors.transparent.withBlue(50),
                      shadowColor: Colors.white38,
                      elevation: 15,
                      child: CircleAvatar(
                        maxRadius:  50,
                        minRadius: 25.0,

                        backgroundImage:  NetworkImage(list.categoryUrl!),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5,right: 5),
                      child: AutoSizeText(list.catName!,style: GoogleFonts.poppins( ),overflow: TextOverflow.ellipsis,minFontSize: 10,maxFontSize: 14,),
                    )
                  ],
                ),
              ),*/
            ),
          ),
        ),
      );

  }
  Widget topDoctorComponent() {
    // if (doctorList.isEmpty) return Offstage();
    return Column(
      children: [
        16.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Top Doctors',
                style: GoogleFonts.poppins(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16)),
            Text('ViewAll',
                style: GoogleFonts.poppins(color: Colors.blue,fontWeight: FontWeight.w400,fontSize: 14))
                .onTap(() {
            //  ListPage().launch(context);
            }),

            //.visible( ),
          ],
        ),
        16.height,
        Align(
          alignment: Alignment.topLeft,
          child: Wrap(
            runSpacing: 8,
            spacing: 16,
            //  children: doctorList.map((e) => DoctorDashboardWidget(data: e)).take(2).toList(),
          ),
        ),
        Container(
          height: 400,
          child: FutureBuilder<List<Doctors>>(
            future:getSearchDoctors(getStringAsync(USER_CITY)),
            builder: (context, snapshot) {
              if(snapshot.data == null){
                logDev.log(snapshot.data.toString(),name:"show");
                return CircularProgressIndicator();
              }else {
                List<Doctors>? doctors = snapshot.data;

                return ListView.builder(itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return topDoctorList(doctors![index]);

                  },/* gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing:4.0

                  )*/);
              }
            },
          ) ,
        )
      ],
    );
  }
  _showDialog(BuildContext context, Doctors doctors){
    showDialog(
      context: context,
      builder: (BuildContext context)=>
          CupertinoAlertDialog(

            title: Column(
              children: <Widget>[
                Text("Dr." +doctors.name!),
                Icon(
                  Icons.local_hospital_rounded,
                  color: Colors.green,
                ),
              ],
            ),
            content: new Text( "Available"),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },),

            ],
          ),   );
  }


  @override
  Widget build(BuildContext context) {
    return    SingleChildScrollView(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [


          InkWell(

            child:
            AppTextField(

              onChanged: _onChanged,
              textStyle: primaryTextStyle(
                  color:   Colors.black26),
              controller: searchCont,
              textAlign: TextAlign.start,
              textFieldType: TextFieldType.NAME,
              decoration: speechInputWidget(context,
                  hintText:  "Search a doctor or specialization or location",
                  iconColor: primaryColor
              ),
            ).paddingSymmetric(horizontal: 8).visible(true),
          ),
          20.height,

           patientTotalDataComponent(),
          // 32.height,
           patientSymptomsComponent().paddingSymmetric(vertical: 8),
                

          /*    topDoctorComponent().paddingAll(8),*/
          topDoctorComponent().paddingAll(5)
        ],
      ),
    );
  }
  _onChanged(String value) {
    setState(() {
      charLength = value.length;
      searchCont.text =value;
      if(charLength>=0) {
        SearchScreen(getStringAsync(USER_CITY)).launch(
            context, pageRouteAnimation: PageRouteAnimation.Fade);
        print("hips" + charLength.toString());
        searchCont.clear();
      }else if(charLength==0){

      }
    });
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
                            "Dr.${doctor.name} ${doctor.lastName}"
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

  Widget topList(Doctors doctors) {
    return Container(
    margin: EdgeInsets.only(left: 10,right: 10),
     decoration: BoxDecoration(color: Colors.white,borderRadius:
    BorderRadius.all( Radius.circular(20),)
      ,gradient: LinearGradient(colors: [Colors.blue.shade200,Colors.blue.shade700],)
      ,boxShadow: [BoxShadow(color: Colors.white,
          spreadRadius: 2, blurRadius: 5)],

    ),
    child: Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:   EdgeInsets.only(left: 10,top: 5),
              child: Text("Find Your Best Doctors",style: GoogleFonts.poppins(fontSize: 18,fontWeight: FontWeight.w400,color: Colors.white),maxLines: 2,),
            ),
            Padding(
              padding:   EdgeInsets.only(left: 10),
              child: Text("Dr.${doctors.name}",style:  GoogleFonts.poppins(fontSize: 14,color: Colors.white,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,),
            )
            ,Padding(
              padding:   EdgeInsets.only(left: 10),
              child: Text(" ${doctors.expertise}",style:  GoogleFonts.poppins(fontSize: 12,color: Colors.white,fontWeight: FontWeight.w400),overflow: TextOverflow.ellipsis,),
            )
            ,Padding(
              padding:   EdgeInsets.only(left: 10),
              child: Text(" ${doctors.location}",style:  GoogleFonts.poppins(fontSize: 12,color: Colors.white,fontWeight: FontWeight.w400),overflow: TextOverflow.ellipsis,),
            )
            ,Padding(
              padding:   EdgeInsets.only(left: 10),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding:   EdgeInsets.all(10.0),
                  child: Center(child: Text("Appoint Now",style: GoogleFonts.poppins(color: Colors.blue,fontSize: 12,fontWeight: FontWeight.bold),)),
                ),
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network("https://thefamilydoctor.co.in/wp-content/uploads/2020/01/I2-e1578898118449.png",width: 140,height: 100,),
        )
      ],
    ),
    );
  }

}
