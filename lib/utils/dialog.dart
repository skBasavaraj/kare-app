 import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../network/apiService.dart';
import '../signInScreen.dart';
import 'appCommon.dart';
import 'color_use.dart';

 var formKey = GlobalKey<FormState>();

 TextEditingController emailCount = TextEditingController();
 TextEditingController newPassCont = TextEditingController();
 TextEditingController confNewPassCont = TextEditingController();

 FocusNode newPassFocus = FocusNode();
 FocusNode confPassFocus = FocusNode();
  int selectedIndex = 0;

 List<DemoLoginModel> demoLoginData =  [];

 bool oldPasswordVisible = false;
 bool newPasswordVisible = false;
 bool confPasswordVisible = false;


 class forgotDialog extends StatefulWidget {
   const forgotDialog({Key? key}) : super(key: key);

   @override
   State<forgotDialog> createState() => _forgotDialogState();
 }
 enum Type{user,doctor}

 class _forgotDialogState extends State<forgotDialog> {
   Type _types = Type.user;
  String? LoginType="user";
   @override
   Widget build(BuildContext context) {
     Size size = MediaQuery.of(context).size;

     return Container(
       decoration: BoxDecoration(borderRadius: BorderRadius.circular(40),shape: BoxShape.rectangle),
       width: size.width/2,
        child:
       Wrap(
         children: [
           AppTextField(
             controller: emailCount,
             textFieldType: TextFieldType.EMAIL,
             decoration: textInputStyle(context: context, label: 'lblEmail',text:'Email'),
             nextFocus: newPassFocus,

             suffixPasswordVisibleWidget: commonImage(
               imageUrl: "images/icons/showPassword.png",
               size: 10,
             ),
             suffixPasswordInvisibleWidget: commonImage(
               imageUrl: "images/icons/hidePassword.png",
               size: 10,
             ),
             textStyle: primaryTextStyle(),
           ),
           20.height,
           Row(
             mainAxisAlignment: MainAxisAlignment.start,
             children: [
               Radio(value: Type.user, groupValue:  _types, onChanged: (value) {
                 setState(() {
                   _types = value!;
                    LoginType="user";
                   successToast(LoginType);
                 });
               },),
               Text(
                 "user",style: GoogleFonts.jost(fontSize: 20,color:Colors.black),),
               Radio(value: Type.doctor, groupValue:  _types, onChanged: (value) {
                 setState(() {
                   _types = value!;
                   LoginType="doctor";

                   successToast(LoginType);

                 });
               },),
               Text("doctor",style:GoogleFonts.jost(fontSize: 20,color:Colors.black)),


             ],
           ),
           10.height,
           AppButton(
             color: primaryColor,
             onTap: () {
               hideKeyboard(context);

               submit(context,LoginType!);
               //  submit();
             },
             text:  'submit',
             textStyle: GoogleFonts.jost(color:  Colors.white,fontSize: 14),
             width: context.width(),
           ),
         ],
       ),
     );
   }
 }
 Future<void> submit(BuildContext context,String type) async {

   var info = await  forgotPasswrd(emailCount.text, type );
   if(info!.error=="000"){
     emailCount.clear();
     successToast("password sent to your email");
     Navigator.of(context, rootNavigator: true).pop('dialog');

   }
   {
     errorToast(info!.message!);
   }
 }
