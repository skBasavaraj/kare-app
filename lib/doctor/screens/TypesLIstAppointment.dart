import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zatcare/network/doctorApiService.dart';
import 'package:zatcare/utils/color_use.dart';

import '../../utils/appwigets.dart';
import '../../utils/marqeeWidget.dart';

class TypesAppointmentList extends StatefulWidget {
   String? type;

   TypesAppointmentList(this.type);

  @override
  State<TypesAppointmentList> createState() => _TypesAppointmentListState();
}

class _TypesAppointmentListState extends State<TypesAppointmentList> {
  @override
  Widget build(BuildContext context) {
    return  SafeArea(child: Scaffold(
      backgroundColor: scaffoldBgColor,
      body: Column(
       children: [
         Expanded(
           flex: 1,
           child: Row(
             mainAxisAlignment: MainAxisAlignment.start,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               InkWell(
                  onTap: () {
                    pop(context);
                  },

                   child: Icon(Icons.arrow_back,size: 30,).paddingSymmetric(vertical: 10,horizontal: 10))
               ,Text(widget.type!,style: GoogleFonts.poppins(fontSize: 30,fontWeight: FontWeight.w500),)

             ],
           ),
         ),
         Expanded(
           flex: 10,
           child: FutureBuilder<List<doctorGetAppointments>>(builder: (context, snapshot) {
             if (snapshot.hasData) {
               List<doctorGetAppointments> list = snapshot!.data!;
               return ListView.builder(
                 itemBuilder:(context, index) {
                   return   todayCard(list[index]);
                 },itemCount: snapshot.data!.length,);

             }
             return snapWidgetHelper(snapshot, errorWidget:  noAppointmentDataWidget(text: "No Data Found", isInternet: true));

           },future: typesAppointment(widget.type!),),
         )

       ],
       ),
    ));

  }
  Widget todayCard(doctorGetAppointments list){
    return  GestureDetector(
      onTap: () {

      },
      child:
      Container(
        width: 350,
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            2.height,

            Padding(
              padding: EdgeInsets.only(left: 15,top: 10),
              child: MarqueeWidget(
                child: Text(
                  "Today Appointments",
                  style:
                  GoogleFonts.jost(color: Colors.white, fontSize: 20,fontWeight:FontWeight.w500),
                  softWrap: false,
                ),
              ),
            )
            ,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: boxDecorationWithShadow(
                    boxShape: BoxShape.circle,
                    boxShadow:  [BoxShadow(color: Colors.white,blurRadius: 0,spreadRadius: 1)],
                    backgroundColor:  Colors.white,
                  ),
                  child: FaIcon(FontAwesomeIcons.user,).center(),
                ).paddingOnly(left: 10,top: 5),
                Wrap(
                  direction: Axis.vertical,
                  children: [
                    Marquee(child: Text(list.patientName!,style: GoogleFonts.jost(fontSize: 20,fontWeight: FontWeight.w500,color: CupertinoColors.white),)).paddingLeft(9)
                    , Wrap(
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text("Gender:",style: GoogleFonts.jost(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.white70),).paddingLeft(10),
                        Text(list.patientGender!,style: GoogleFonts.jost(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.white70),).paddingLeft(5),
                        Text("Age:",style: GoogleFonts.jost(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.white70),).paddingLeft(10),
                        Text("00",style: GoogleFonts.jost(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.white70),).paddingLeft(5),

                      ],
                    )
                  ],
                ),

              ],
            )
            ,
            Container(
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2),borderRadius: BorderRadius.circular(5)),
              width: context.width(),
              height: 25,
              child: Center(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 15,
                  children: [
                    Icon(FontAwesomeIcons.calendarCheck,color: Colors.white,size: 16,),
                    Text(list.apptDate!,style: GoogleFonts.jost(color: Colors.white,fontSize: 14),),
                    Icon(FontAwesomeIcons.clock,color: Colors.white,size: 16,),
                    Text(list.apptTime!,style: GoogleFonts.jost(color: Colors.white,fontSize: 14),),

                  ],
                ),
              ),
            ).paddingSymmetric(horizontal: 10,vertical: 10)


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
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 6,
                  spreadRadius: 1)
            ]),
      ).paddingSymmetric(vertical: 10,horizontal: 20),
    );

  }
}
