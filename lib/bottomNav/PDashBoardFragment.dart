 import 'dart:async';

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
import '../screens/connectionScreen.dart';
import '../screens/doctorDetilas2.dart';
import '../screens/search.dart';
import '../utils/appCommon.dart';
import '../utils/color_use.dart';
import '../utils/indicator.dart';
import '../utils/marqeeWidget.dart';



class PDashBoardFragment extends StatefulWidget {
  @override
  _PDashBoardFragmentState createState() => _PDashBoardFragmentState();
}

class _PDashBoardFragmentState extends State<PDashBoardFragment> with SingleTickerProviderStateMixin {
  int charLength = 0;
  double?  ratingBarValue;
  TextEditingController searchCont = TextEditingController();
   Color _color = Colors.white;
  List<String> name = [];
  List<String> hospital = [];
  List<String>  active = [];
  List<Doctors> doctorsList=[];

  late AnimationController _animationController;
  late Animation<double> _nextPage;
  int _currentPage = 0;
  int selectIndex =0;

  PageController _pageController = PageController(initialPage: 0 );
   var size,height,width;
   @override
  void initState() {
    super.initState();

    init();
  }

  init() async {

    //
    //Start at the controller and set the time to switch pages
    _animationController =
    new AnimationController(vsync: this, duration: Duration(seconds: 10));
    _nextPage = Tween(begin: 0.0, end: 1.0).animate(_animationController);

     _animationController.addListener(() {
      if (_animationController.status == AnimationStatus.completed) {
        _animationController.reset(); //Reset the controller
        final int page = 4; //Number of pages in your PageView
        if (_currentPage < page) {
          _currentPage++;
          _pageController.animateToPage(_currentPage,
              duration: Duration(milliseconds: 300), curve: Curves.easeInSine);
        } else {
          _currentPage = 0;
        }
      }
    });
    Timer.periodic(Duration(seconds: 1), (Timer t) =>   setState(() {
      NoNetwork.checkNet();
    }));

  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _animationController.dispose();
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

          return
            Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top:0),
                  height: 185,
                  decoration: BoxDecoration(
                    // color:Colors.purple,
                  ),
                  child: PageView.builder(
                    controller: _pageController,

                    onPageChanged: (value) {
                      _animationController!.forward();

                      setState(() {
                        selectIndex = value;

                      });
                    },
                    itemBuilder: ( context,index){
                      return Padding(
                        padding:   EdgeInsets.all(20.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(backgroundlist[index].url!),
                                fit:BoxFit.cover,
                              )
                          ),
                          child: Stack(

                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Container(

                                  width: width/2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child:
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:   EdgeInsets.only(left: 10,top: 5),
                                        child: Text( backgroundlist[index].labels!,style: GoogleFonts.jost(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white,height: 1.2 // the height between text, default is null
                                          ,  letterSpacing: .0 ),softWrap: true,maxLines: 2,),
                                      ),


                                      Padding(
                                        padding: const EdgeInsets.only(left: 15,top:30),
                                        child: Container(
                                          width: 100,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: Colors.white,width: 1,)
                                          ),
                                          child: Center(child: Text("Book Now",style: GoogleFonts.jost
                                            ( color: Colors.white ),)),),
                                      ),



                                    ],

                                  ),
                                ),
                              )
                              ,Positioned(
                                right: 0,

                                child: Container(
                                  height: 145,
                                  child:Padding(
                                    padding:   EdgeInsets.only(top: 5,right: 20),
                                    child: Image.network("https://pngimg.com/uploads/doctor/doctor_PNG15988.png",                      fit:BoxFit.cover,
                                    ),
                                  ),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),

                                ),
                              ),
                              Positioned(
                               left: 100,
                                   right: 100,
                                   bottom: 10,
                                   child:Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ...List.generate(backgroundlist.length, (index) =>     Indictor(isActive: selectIndex == index ? true : false
                                  ))
                                ],
                              ))
                            ],
                          ),
                        ),
                      );
                    },itemCount:backgroundlist.length,),
                ),

              ],
            );
        }
      },
    );
  }

  Widget patientSymptomsComponent() {
    return
      Column(
       children: [
        Container(
           child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text('Specialists',
                    style: GoogleFonts.poppins(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold)),
              ),
              TextButton(
                onPressed: () {
                  //  CategoryScreen(service: service).launch(context);
                },
                child: Text("See all",
                    style: GoogleFonts.poppins(color:  Colors.blue,fontSize: 12)),
              )
              //.visible(service.length >= 7),
            ],
          ).paddingSymmetric(horizontal: 10)
        ) ,
       /*  Wrap(
          direction: Axis.horizontal,
          spacing: 16,
          runSpacing:
          16,

        ).paddingSymmetric(horizontal: 4),*/
         Container(
          height:height/4,
          width: width,

          child: FutureBuilder<List<CatList>>(
            future:getCatList(),
            builder: (context, snapshot) {
              if(snapshot.data == null){
                logDev.log(snapshot.data.toString(),name:"show");
                return Lottie.network('https://assets9.lottiefiles.com/packages/lf20_MkWLYjEq5l.json',height: 20);
                //Text("LOading...",style: GoogleFonts.poppins(color: Colors.blue,fontSize: 20),);
              }else {
                List<CatList>? list = snapshot.data;

                return GridView.builder(itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return categoryList( list![index]) ;

                  },
                  scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                    childAspectRatio: 0.8

                    ), );
              }
            },
          ) ,
        )
      ],
    ) ;
  }
  Widget categoryList(CatList list){
  
    
    return
      Padding(
        padding: const EdgeInsets.only(left: 5,right: 5),
        child: CupertinoButton(onPressed:() {

        },  child:
        InkWell(
          onTap: () {
            SearchScreen(list.catName).launch(context,pageRouteAnimation: PageRouteAnimation.Scale);

          },
          child: Container(
            height: height/6,
            width: 150,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                2.height,
                Image.network(list.categoryUrl! ,height: 30,width: 30,color: Colors.white,)
                ,/*AutoSizeText(list.catName!,style: GoogleFonts.jost(color: Colors.white,
                     ),softWrap: false,
                maxFontSize:14 ,
                minFontSize: 10,)*/
             Padding(
               padding:   EdgeInsets.symmetric(horizontal: 6),
               child: MarqueeWidget(child:Text(list.catName!,style: GoogleFonts.jost(color: Colors.white,
                 fontSize: 14
               ),softWrap: false,
                 ),),
             )
              ],
            ),

            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(

                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue,
                    Colors.indigo,
                  ],
                ),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4),blurRadius: 6,spreadRadius: 1)]
            ),
          ),
        ),),
      );
    /*  Padding(

        padding: const EdgeInsets.only(left: 20,bottom: 5,),
        child:
        Material(
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

                       Image.network(list.categoryUrl! ,height: 30,width: 25,color: Colors.purple,)
                      , SizedBox(width: 5),

                          Expanded(child: Text(list.catName!,style: TextStyle(fontSize: 14,color: Colors.blue,overflow: TextOverflow.ellipsis,fontWeight: FontWeight.w400),))

                        ],
                      ),
                    ),
                  ),
                ),
              )

            ),
          ),
        ),
      );*/

  }
  Widget topDoctorComponent() {
    // if (doctorList.isEmpty) return Offstage();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text('Near by you',
                  style: GoogleFonts.poppins(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () {
                //  CategoryScreen(service: service).launch(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text("See all",
                    style: GoogleFonts.poppins(color:  Colors.blue,fontSize: 12)),
              ),
            )
            //.visible(service.length >= 7),
          ],
        )  ,
         Align(
          alignment: Alignment.topLeft,
          child: Wrap(
            runSpacing: 8,
            spacing: 16,
            //  children: doctorList.map((e) => DoctorDashboardWidget(data: e)).take(2).toList(),
          ),
        ),
        Container(
          height: 150,
          child: FutureBuilder<List<Doctors>>(
            future:getSearchDoctors(getStringAsync(USER_CITY)),
            builder: (context, snapshot) {
              if(snapshot.data == null){
                logDev.log(snapshot.data.toString(),name:"show");
                return   Lottie.network("https://assets2.lottiefiles.com/packages/lf20_eMqO0m.json",height: 150);

              }else {
                List<Doctors>? doctors = snapshot.data;

                return PageView.builder(itemCount: snapshot.data!.length,

                   itemBuilder: (BuildContext context, int index)
                  {
                    return topDoctorList(doctors![index]).paddingSymmetric(horizontal: 10);

                  },

                );
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
    _animationController.forward(); //Start controller with widget
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return   Scaffold(
      backgroundColor: scaffoldBgColor,
        body:  SingleChildScrollView(
          child: Column(
           children: [


             InkWell(


               child:
               AppTextField(

                 onChanged: _onChanged,
                 textStyle: GoogleFonts.jost(
                     color:   Colors.black26),
                 controller: searchCont,
                 textAlign: TextAlign.start,
                 textFieldType: TextFieldType.NAME,
                 decoration: speechInputWidget(context,
                     hintText:  "Search a doctor or specialization or location",
                     iconColor: primaryColor
                 ),
               ).paddingSymmetric(horizontal: 20).visible(true),
             ),

             patientTotalDataComponent() ,
             // 32.height,
             patientSymptomsComponent() ,


             /*    topDoctorComponent().paddingAll(8),*/
             topDoctorComponent()
           ],
         ),
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
                    padding:   EdgeInsets.only(left: 5,right: 5,),
                    child:ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        'https://img.freepik.com/free-photo/doctor-with-his-arms-crossed-white-background_1368-5790.jpg?w=2000',
                        width: 80,
                        height: 150,
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
                            "Dr.${doctor.name} "
                            ,style: GoogleFonts.poppins(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.blue),overflow: TextOverflow.ellipsis, ),
                        ).paddingTop(1)

                        ,SizedBox(height: 2,)
                        ,

                        Expanded
                          (
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text("${doctor.hospital} ${doctor.location}",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.blue
                                  ,

                                ),overflow: TextOverflow.ellipsis),
                          ),
                        ),

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
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    AutoSizeText("Available",style: GoogleFonts.poppins(
                                      fontSize: 12,color: Colors.blue,
                                    ),)
                                    , AutoSizeText("7am - 10 am",style: GoogleFonts.poppins(
                                      fontSize: 12,color: Colors.blue,
                                    ),)
                                  ],
                                ).paddingAll(4),
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
      width: 200,
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
 class Images {
   String? url;
   String? labels;
   Images(this.url,this.labels);

 }
 List<Images> backgroundlist =[
   Images("https://www.jqueryscript.net/images/Create-An-Animated-Radial-Gradient-Background-With-jQuery-CSS3.jpg","Find your Best Doctors"),
    Images("https://t4.ftcdn.net/jpg/02/21/39/93/360_F_221399332_MuA92wdjVCeRQv9AXY8p79hWGaTLMLWY.jpg","Find Best Specialists"),
   Images("https://www.jqueryscript.net/images/Create-An-Animated-Radial-Gradient-Background-With-jQuery-CSS3.jpg","Find your Near by Doctors"),

 ];
