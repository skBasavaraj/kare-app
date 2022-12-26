import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zatcare/network/doctorApiService.dart';

import '../../utils/appCommon.dart';
import '../../utils/color_use.dart';


AlertDialog CheckOutDialog(BuildContext context, doctorGetAppointments list) {
  Size size = MediaQuery.of(context).size;

  var height = size.height;
  var width = size.width;
  return AlertDialog(
      title: Text(
        "Appointment Summary",
        style: GoogleFonts.jost(height: 1, fontSize: 20,fontWeight: FontWeight.w400),
      ),
      content:
      Container(
         width: context.width(),

        child: Wrap (
           children: [
           Text(list.patientName!,
                style: GoogleFonts.jost(fontSize: 20, color: Colors.blue,)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Sub:",
                    style: GoogleFonts.jost(fontSize: 16, color: Colors.grey)).paddingLeft(10),
                Text(list.subject!,
                    style: GoogleFonts.jost(fontSize: 16, color: Colors.black,fontWeight: FontWeight.w300)).paddingLeft(15),

              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Date:",
                    style: GoogleFonts.jost(fontSize: 16, color: Colors.grey)).paddingLeft(10),
                Text(list.apptDate!,
                    style: GoogleFonts.jost(fontSize: 16, color: Colors.black,fontWeight: FontWeight.w300)).paddingLeft(15),

              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Time:",
                    style: GoogleFonts.jost(fontSize: 16, color: Colors.grey)).paddingLeft(10),
                Text(list.apptTime!,
                    style: GoogleFonts.jost(fontSize: 16, color: Colors.black,fontWeight: FontWeight.w300)).paddingLeft(15),

              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Mobile:",
                    style: GoogleFonts.jost(fontSize: 16, color: Colors.grey)).paddingLeft(10),
                Text(list.patientNumber!,
                    style: GoogleFonts.jost(fontSize: 16, color: Colors.black,fontWeight: FontWeight.w300)).paddingLeft(15),

              ],
            ),
            Container(
              decoration: BoxDecoration(color: Colors.blue.withOpacity(0.2),borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.black,width: 1,style: BorderStyle.solid)),
              child:
              Wrap(
                 children: [
                  Center(child: Text("Price",style: GoogleFonts.jost(fontSize: 16,fontWeight: FontWeight.bold),)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Fees",style: GoogleFonts.jost(fontWeight: FontWeight.normal,fontSize: 16,color: Colors.grey.shade600),)
                   ,Text("Rs.200",style: GoogleFonts.jost(fontWeight: FontWeight.bold,fontSize: 16,color:Colors.blue),)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Text("Service",style: GoogleFonts.jost(fontWeight: FontWeight.normal,fontSize: 16,color: Colors.grey.shade600),)
                      ,Text("Rs.50",style: GoogleFonts.jost(fontWeight: FontWeight.bold,fontSize: 16,color:Colors.blue),)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Text("Total",style: GoogleFonts.jost(fontWeight: FontWeight.normal,fontSize: 20,color: Colors.grey.shade600),)
                      ,Text("Rs.250",style: GoogleFonts.jost(fontWeight: FontWeight.bold,fontSize: 20,color:Colors.blue),)
                    ],
                  ),

                ],
              ).paddingSymmetric(horizontal: 10),
            ).paddingSymmetric(vertical: 10),

            10.height,
            AppButton(
              height: 10,
              color: primaryColor,
              onTap: () {
                hideKeyboard(context);

                submit(list);
                Navigator.of(context, rootNavigator: true).pop('dialog');
                //  submit();
              },
              text: 'Check In',
              textStyle: GoogleFonts.jost(color: Colors.white, fontSize: 14),
              width: context.width(),
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)));
}

Future<void> submit(doctorGetAppointments list) async {
  var info = await  doctorApprove("closed",list.id!,list.doctorID,list.apptDate, list.apptTime);
  if(info!.error=="000"){
    successToast("Your successfully updated details");
    
  }else{
    errorToast(info.message!);
  }
}
