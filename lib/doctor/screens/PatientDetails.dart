import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zatcare/appConstants.dart';
import 'package:zatcare/network/doctorApiService.dart';
import 'package:zatcare/utils/appCommon.dart';
import 'package:zatcare/utils/color_use.dart';

class PatientDetails extends StatefulWidget {
  doctorGetAppointments? patientDetail;

 PatientDetails(this.patientDetail);

  @override
  State<PatientDetails> createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails> {
  TextEditingController DateCount = TextEditingController();
  TextEditingController TimeCount = TextEditingController();
  @override
  void initState() {
     super.initState();
    DateCount.text = widget.patientDetail!.apptDate!.toString();
    TimeCount.text = widget.patientDetail!.apptTime!.toString();

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        floatingActionButton:
        floatingButton(),
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

                    child: Icon(Icons.arrow_back,size: 25,).paddingSymmetric(vertical: 10,horizontal: 20))
                ,Text("Edit Date And Time",style: GoogleFonts.poppins(fontSize: 20,fontWeight: FontWeight.w500),)

              ],
            ),
          ),
          Expanded(
            flex: 10,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 40,
                      width: context.width(),
                      decoration: BoxDecoration(border: Border.all(color: Colors.blue,width: 1),borderRadius: BorderRadius.circular(5)),
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Name:",style: GoogleFonts.jost(fontSize: 16,color: Colors.grey),).paddingLeft(5),
                          Marquee(
                             child: Text( widget.patientDetail!.patientName!,style: GoogleFonts.jost(
                                 fontSize: 14,fontWeight: FontWeight.normal ,color: Colors.black
                             ),
                          )).paddingLeft(5),

                        ],
                       )
                  ).paddingSymmetric(vertical: 10,horizontal: 20),
                  Container(
                      height: 40,
                      width: context.width(),
                      decoration: BoxDecoration(border: Border.all(color: Colors.blue,width: 1),borderRadius: BorderRadius.circular(5)),
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Gender:",style: GoogleFonts.jost(fontSize: 16,color: Colors.grey),).paddingLeft(5),
                          Marquee(
                              child: Text( widget.patientDetail!.patientGender!,style: GoogleFonts.jost(
                                  fontSize: 14,fontWeight: FontWeight.normal ,color: Colors.black
                              ),
                              )).paddingLeft(5),

                        ],
                      )
                  ).paddingSymmetric(vertical: 10,horizontal: 20),
                  Container(
                      height: 40,
                      width: context.width(),
                      decoration: BoxDecoration(border: Border.all(color: Colors.blue,width: 1),borderRadius: BorderRadius.circular(5)),
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Age:",style: GoogleFonts.jost(fontSize: 16,color: Colors.grey),).paddingLeft(5),
                          Marquee(
                              child: Text( widget.patientDetail!.patientAge!,style: GoogleFonts.jost(
                                  fontSize: 14,fontWeight: FontWeight.normal ,color: Colors.black
                              ),
                              )).paddingLeft(5),

                        ],
                      )
                  ).paddingSymmetric(vertical: 10,horizontal: 20),
                  Container(
                      height: 40,
                      width: context.width(),
                      decoration: BoxDecoration(border: Border.all(color: Colors.blue,width: 1),borderRadius: BorderRadius.circular(5)),
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Blood Group:",style: GoogleFonts.jost(fontSize: 16,color: Colors.grey),).paddingLeft(5),
                          Marquee(
                              child: Text( widget.patientDetail!.bloodGroup!,style: GoogleFonts.jost(
                                  fontSize: 14,fontWeight: FontWeight.normal ,color: Colors.black
                              ),
                              )).paddingLeft(5),

                        ],
                      )
                  ).paddingSymmetric(vertical: 10,horizontal: 20),
                  Container(
                      height: 40,
                      width: context.width(),
                      decoration: BoxDecoration(border: Border.all(color: Colors.blue,width: 1),borderRadius: BorderRadius.circular(5)),
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Contact:",style: GoogleFonts.jost(fontSize: 16,color: Colors.grey),).paddingLeft(5),
                          Marquee(
                              child: Text( widget.patientDetail!.patientNumber!,style: GoogleFonts.jost(
                                  fontSize: 14,fontWeight: FontWeight.normal ,color: Colors.black
                              ),
                              )).paddingLeft(5),

                        ],
                      )
                  ).paddingSymmetric(vertical: 10,horizontal: 20),
                  Container(
                      height: 40,
                      width: context.width(),
                      decoration: BoxDecoration(border: Border.all(color: Colors.blue,width: 1),borderRadius: BorderRadius.circular(5)),
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Subject:",style: GoogleFonts.jost(fontSize: 16,color: Colors.grey),).paddingLeft(5),
                          Marquee(
                              child: Text( widget.patientDetail!.subject!,style: GoogleFonts.jost(
                                  fontSize: 14,fontWeight: FontWeight.normal ,color: Colors.black
                              ),
                              )).paddingLeft(5),

                        ],
                      )
                  ).paddingSymmetric(vertical: 10,horizontal: 20),
                  AppTextField(controller: DateCount,
                      textFieldType:  TextFieldType.USERNAME,decoration: textInputStyle(context:context,
                  isMandatory: true,text:"Date",)).paddingSymmetric(vertical: 10,horizontal: 20),
                  AppTextField(controller: TimeCount,
                      textFieldType:  TextFieldType.USERNAME,decoration: textInputStyle(context:context,
                          isMandatory: true,text:"Time")).paddingSymmetric(vertical: 10,horizontal: 20),

                  Container(
                      height: 200,
                      width: context.width(),
                      decoration: BoxDecoration(border: Border.all(color: Colors.blue,width: 1),borderRadius: BorderRadius.circular(5)),
                      child:
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        clipBehavior: Clip.antiAlias,
                        padding: EdgeInsets.all(5),
                        child: Text("Description: "+widget.patientDetail!.description!,style: GoogleFonts.jost(
                          fontSize: 14,fontWeight: FontWeight.normal ,color: Colors.black
                          , letterSpacing: 1,wordSpacing: 1,
                        ),
                          maxLines: 5,  ).paddingLeft(5),
                      ),

                  ).paddingSymmetric(vertical: 10,horizontal: 20),
                    70.height

                ],
              ),
            ),
          )

        ],

        ),
      ),
    );
  }

 Widget floatingButton() {
   if(widget.patientDetail!.status=="pending"  ){
   return Row(
     mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
        height: 50,
        width: 100,
        child: FloatingActionButton.small(
            backgroundColor: Colors.blue.withOpacity(0.7),

            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),onPressed: () async {
          hideKeyboard(context);
          var info = await  doctorApprove("approved",widget.patientDetail!.id!,widget.patientDetail?.doctorID!,DateCount.text.validate(),TimeCount.text.validate());
          if(info!.error=="000"){
            var notification = await setNotification("You have approved appointment",  "Your Appointment approved by Dr.${getStringAsync(USER_NAME)}",  widget.patientDetail!.doctorID!, getStringAsync(USER_TYPE),  widget.patientDetail!.userID!,  "user",  widget.patientDetail!.patientName!, "dateN", "timeN",  "not seen");
            if(notification!.error=="000"){
              successToast("Your successfully updated details");
              pop(context);
            }else{
              errorToast(notification!.error!);
            }

          }else{
            errorToast(info.message!);
          }
        },child: statusText()),
      ),
        Container(
          height: 50,
          width: 100,
          child: FloatingActionButton.small(
            backgroundColor: Colors.red.withOpacity(0.6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),onPressed: () async {
            hideKeyboard(context);
            var info = await  doctorApprove("rejected",widget.patientDetail!.id!,widget.patientDetail?.doctorID!,DateCount.text.validate(),TimeCount.text.validate());
            if(info!.error=="000"){
              var notification = await setNotification("You have rejected appointment",  "Your Appointment rejected by Dr.${getStringAsync(USER_NAME)} due to some issue",  widget.patientDetail!.doctorID!, getStringAsync(USER_TYPE),  widget.patientDetail!.userID!,  "user",  widget.patientDetail!.patientName!, "dateN", "timeN",  "not seen");
              if(notification!.error=="000"){
                successToast("Your successfully updated details");
                pop(context);
              }else{
                errorToast(notification!.error!);
              }
            }else{
              errorToast(info.message!);
            }
          },child: Text("Reject it",style: GoogleFonts.jost(color: Colors.white)).paddingAll(5)
          ),
        ),
      ],
   );
   }

   return FloatingActionButton(onPressed: () async {
     hideKeyboard(context);
     var info = await  editAppointment("doctorEditAppointment.php",widget.patientDetail!.id!,DateCount.text.validate(),TimeCount.text.validate());
     if(info!.error=="000"){
       successToast("Your successfully updated details");

     }else{
       errorToast(info.message!);
     }
   },child: Icon(Icons.check_sharp));
 }

Widget  statusText() {
  return Text("Approve it",style: GoogleFonts.jost(color: Colors.white)).paddingAll(5);

}

}
