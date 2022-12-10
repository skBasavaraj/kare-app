import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hovering/hovering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

 import '../appConstants.dart';
import '../network/apiService.dart';
import 'ApointmentscreenBooking.dart';
import 'ChatDetails.dart';

class DoctorDetails extends StatefulWidget {
  final Doctors? doctors;

  DoctorDetails(this.doctors);

  @override
  State<DoctorDetails> createState() => _DoctorDetailsState(doctors);
}

class _DoctorDetailsState extends State<DoctorDetails> {
  final Doctors? doctors;
  _DoctorDetailsState(this.doctors);
  bool fBtn=false;

  var drName;
  var drLocation;
  var drExp;
  var drSplzn;
  var drNumber;
  var drDescription;
  double? ratings;



  @override
  void initState() {
    super.initState();
    init();
  }
  void init() {
   String?  drLastName = doctors!.lastName;
   String?  name= doctors!.name;
    drName =  name! +" "+ drLastName!;
    drDescription = doctors!.description;
    drExp = doctors!.exp;
    drNumber = doctors!.number;
    drSplzn = doctors!.expertise;
    String? hospital = doctors!.hospital;
    String? location = doctors!.location;
    drLocation = hospital! +" "+ location!;
    ratings = doctors!.ratings.toDouble();
  }
  @override
  Widget build(BuildContext context) {
    return
    Scaffold(

      body: Container(
        color: Colors.white,

        child: SingleChildScrollView(

          child:
          Container(
            
               margin: EdgeInsets.only(top: 10.0),
            decoration: const BoxDecoration(
                image: DecorationImage(
                  alignment: Alignment.topCenter,
                  image:NetworkImage( "https://media.istockphoto.com/id/138205019/photo/happy-healthcare-practitioner.jpg?s=612x612&w=0&k=20&c=b8kUyVtmZeW8MeLHcDsJfqqF0XiFBjq6tgBQZC7G0f0="),
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 30,),
                Row(
                  children: [
                    SizedBox(width: 10,),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                        child: Icon(Icons.arrow_back,color: Colors.blue,size: 30,))
                  ],
                ),
                /*  SizedBox(
                  height: 330,
                ),*/
                Container(
                  margin: const EdgeInsets.only(top: 340),
                  height: 700,
                  decoration: const BoxDecoration(
                    color:Colors.blue,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        topLeft: Radius.circular(50))

                    ,boxShadow: [
                    BoxShadow(
                        color: Colors.black54,
                        blurRadius: 1,
                        spreadRadius: 2,
                        offset: Offset(2, 2)
                    ),
                  ],


                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(

                        children: [

                        /*  Container(

                            decoration:   const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle
                              , boxShadow: [
                              BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 2,
                                  spreadRadius: 1,

                                  offset: Offset(2, 2)
                              ),

                            ],
                            ),
                            margin: EdgeInsets.only(left: 5,bottom: 90 ),
                            child:   CircleAvatar(backgroundImage: AssetImage('assets/dprofile.jpg'), radius: 40,),
                          )*/
                          Expanded(
                            child: Container(
                              // color: Colors.white,
                              child: Column(

                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:    [

                                      Padding(
                                      padding: EdgeInsets.only(top:10,left: 20),
                                      child: Text("Dr."+drName,style:  GoogleFonts.poppins(color: Colors.white,fontSize: 35,fontWeight: FontWeight.w500, shadows:  [
                                        BoxShadow(
                                            color: Colors.black45,
                                            blurRadius: 2,
                                            spreadRadius: 1,
                                            offset: Offset(2, 2)
                                        ),
                                      ]),
                                      maxLines: 2,softWrap: true,overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.justify,
                                      ),

                                    )
                                    ,  Padding(
                                      padding: EdgeInsets.only(top:2,left: 20),
                                      child: Row(

                                         children: [

                                           Text( "Specialization: "+drSplzn!,style: GoogleFonts.poppins(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w300,shadows:  [
                                             BoxShadow(
                                                 color: Colors.black45,
                                                 blurRadius: 2,
                                                 spreadRadius: 1,
                                                 offset: Offset(2, 2)
                                             ),
                                           ]),
                                               maxLines: 2,softWrap: true,overflow: TextOverflow.ellipsis,
                                               textAlign: TextAlign.justify),
                                         ],

                                      ),
                                    ),
                                    Row(
                                      children:   [
                                       /* Padding(
                                          padding: EdgeInsets.only(left: 8,top: 5),
                                          child:
                                          Icon(Icons.location_on,size: 20,color: Colors.green,shadows: [
                                            BoxShadow(
                                                color: Colors.black45,
                                                blurRadius: 2,
                                                spreadRadius: 1,
                                                offset: Offset(2, 2)
                                            ),
                                          ]),
                                        )
                                        ,*/
                                        Expanded(child: Padding(
                                          padding: EdgeInsets.only(top:2,left: 20),
                                          child: Text("Location: ${drLocation}" ,style: GoogleFonts.poppins(color: Colors.white,fontSize: 20, shadows: [
                                            BoxShadow(
                                                color: Colors.black45,
                                                blurRadius: 2,
                                                spreadRadius: 1,
                                                offset: Offset(2, 2)
                                            ),
                                          ],),),
                                        ))
                                      ],
                                    ),
                                    /*Padding(
                                      padding:   EdgeInsets.only(left: 8,top:10),
                                      child: Row(


                                        children:   [
                                          InkWell(
                                            child: Icon(Icons.call,color: Colors.deepOrange,size: 30,shadows: [
                                              BoxShadow(
                                                  color: Colors.grey,
                                                  blurRadius: 2,
                                                  spreadRadius: 1,
                                                  offset: Offset(2, 2)
                                              ),
                                            ],),
                                            onTap: () {
                                              _makingPhoneCall(doctors?.number);
                                            },
                                          )
                                          ,Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("Call" ,style: GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 20, shadows: [
                                              BoxShadow(
                                                  color: Colors.black45,
                                                  blurRadius: 2,
                                                  spreadRadius: 1,
                                                  offset: Offset(2, 2)
                                              ),
                                            ],),),
                                          ),
                                          SizedBox(width: 20,),
                                          InkWell(
                                            child: Icon(Icons.local_post_office_rounded,color: Colors.yellow,size: 30,
                                              shadows: [
                                              BoxShadow(
                                                  color: Colors.black45,
                                                  blurRadius: 2,
                                                  spreadRadius: 1,
                                                  offset: Offset(2, 2)
                                              ),
                                            ],),
                                            onTap: () {
                                              ChatScreen(doctors).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                                              },
                                          )
                                          ,Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("Message" ,style: GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 20, shadows: [
                                              BoxShadow(
                                                  color: Colors.black45,
                                                  blurRadius: 2,
                                                  spreadRadius: 1,
                                                  offset: Offset(2, 2)
                                              ),
                                            ],),
                                            ),
                                          )
                                        ],
                                      ),
                                    )*/
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            _makingPhoneCall( doctors?.number!);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(15))),
                                            height: 30,
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 5,right: 5),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,

                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Icon( Icons.phone,size: 28,color: Colors.blue, )
                                                    ,           SizedBox(width: 5,)
                                                    , Text("Voice Call",style: GoogleFonts.poppins(fontSize: 16,color: Colors.blue
                                                        ,fontWeight: FontWeight.bold ),)
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        /*   Container(
                                  decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(15))),
                                  height: 30,
                                  width: 100,
                                  child: Center(
                                    child: Row(

                                      children: [
                                        SizedBox(width: 5),
                                        Icon( Icons.video_call,size: 28,color: Colors.blue, )
                                        ,           SizedBox(width: 5,)
                                        , Text("Video",style: GoogleFonts.poppins(fontSize: 16,color: Colors.blue
                                            ,fontWeight: FontWeight.bold ),)
                                      ],
                                    ),
                                  ),
                                ),*/
                                        InkWell(
                                          onTap: ()   {
                                           /* await setTime(getStringAsync(USER_ID),
                                                doctors!.id!,  "80");*/

                                            ChatScreen(doctors).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);

                                          },
                                          child: Container(
                                            decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(15))),
                                            height: 30,
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 5,right: 5),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Icon( Icons.local_post_office,size: 28,color: Colors.blue, )
                                                    ,           SizedBox(width: 5,)
                                                    , Text("Message",style: GoogleFonts.poppins(fontSize: 16,color: Colors.blue
                                                        ,fontWeight: FontWeight.bold ),)
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ]

                              ),
                            ),
                          )
                          ,

                        ],
                      )
                      ,
                      Container(
                        margin: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Container(

                                child: Column(
                                  children:     [
                                    Text("Exp",style:  GoogleFonts.poppins(fontStyle: FontStyle.normal,color: Colors.white,fontSize: 25,shadows: [
                                      BoxShadow(
                                          color: Colors.black45,
                                          blurRadius: 2,
                                          spreadRadius: 1,
                                          offset: Offset(2, 2)
                                      ),
                                    ]),)
                                    , Center(child: Text( drExp+"+Years",style:  GoogleFonts.poppins(fontStyle: FontStyle.normal,color: Colors.white,fontSize: 20, shadows: [
                        BoxShadow(
                            color: Colors.black45,
                            blurRadius: 2,
                            spreadRadius: 1,
                            offset: Offset(2, 2)
                        ),
                      ]),))

                                  ],
                                ),

                              ),
                            ),
                            Expanded(
                              child: Container(
                                child:Column(
                                  children: [
                                      Text("Ratings",style:  GoogleFonts.poppins(fontStyle: FontStyle.normal,color: Colors.white,fontSize: 25,
                                          shadows: [
                                      BoxShadow(
                                          color: Colors.black45,
                                          blurRadius: 2,
                                          spreadRadius: 1,
                                          offset: Offset(2, 2)
                                      ),
                                    ]),),
                                    RatingBarIndicator(
                                      rating: ratings!,
                                      itemBuilder: (context, index) => const Icon(
                                        Icons.star,

                                        color: Colors.white,
                                      ),
                                      itemCount: 5,
                                      itemSize: 22.0,
                                      direction: Axis.horizontal,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                        Padding(
                        padding: EdgeInsets.only(left: 15,top:30),
                        child: Text(
                          "Description:"
                          ,style:GoogleFonts.poppins(shadows:[
                          BoxShadow(
                              color: Colors.black45,
                              blurRadius: 2,
                              spreadRadius: 1,
                              offset: Offset(2, 2)
                          ),
                        ] ,fontSize: 30,color: Colors.white,
                            fontWeight: FontWeight.w500 ),
                        ),
                      )
                      , Row(
                        children: [
                          Expanded(child:
                          Container(
                            margin:   EdgeInsets.all(15),
                            height: 250,
                            decoration: BoxDecoration(borderRadius: BorderRadius.all( Radius.circular( 8)),color: Colors.white,boxShadow:[

                            ], ),
                            child:   Scrollbar(
                              trackVisibility: true,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,

                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                   // "Doctors, also known as physicians, are licensed health professionals who maintain and restore human health through the practice of medicine. They examine patients, review their medical history, diagnose illnesses or injuries, administer treatment, and counsel patients on their health and well-being"
                                    drDescription!
                                    ,style: GoogleFonts.poppins(fontSize: 20,color: Colors.black,fontStyle: FontStyle.normal,letterSpacing: 1.0), ),
                                ),
                              ),
                            ),
                          ))
                        ],
                      )
                    ],

                  ),
                )
              ],
            ),
          ),
        ),
      ),

      floatingActionButton:
      HoverButton(
        hoverColor: Colors.blue,
        hoverElevation: 100,
        height: 50,

        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        onpressed: () {
          ApointmentScreen(doctors!).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);

        },
        color: Colors.white,
        child: Text("Book Appointment",
            style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Colors.blue)),
      )
  // This t/railing comma makes auto-formatting nicer for build methods.
    );
  }
  _makingPhoneCall(String? doctorNumber) async {
    var url = Uri.parse("tel:$doctorNumber");
    if (await canLaunchUrl(url)) {
      await  launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}
