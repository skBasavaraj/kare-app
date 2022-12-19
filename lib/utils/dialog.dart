 import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../network/apiService.dart';
import 'appCommon.dart';
import 'color_use.dart';

 var formKey = GlobalKey<FormState>();

 TextEditingController emailCount = TextEditingController();
 TextEditingController newPassCont = TextEditingController();
 TextEditingController confNewPassCont = TextEditingController();

 FocusNode newPassFocus = FocusNode();
 FocusNode confPassFocus = FocusNode();

 bool oldPasswordVisible = false;
 bool newPasswordVisible = false;
 bool confPasswordVisible = false;
 AlertDialog  forgotAlertDialog(BuildContext context)  {
   Size size = MediaQuery.of(context).size;

   var height =size.height ;
   var width =size.width ;
    return  AlertDialog(
      title: Text("forgot password?",style: GoogleFonts.jost(height: 1,fontSize: 30),),
      content: Container(
        width: width/2,
        height: height/6,
        child: Column(
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


            30.height,
            AppButton(
              color: primaryColor,
              onTap: () {
                hideKeyboard(context);

                submit();
                Navigator.of(context, rootNavigator: true).pop('dialog');
              //  submit();
              },
              text:  'submit',
              textStyle: GoogleFonts.jost(color:  Colors.white,fontSize: 14),
              width: context.width(),
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
    );
  }

  Future<void> submit() async {
    var info = await  forgotPasswrd(emailCount.text,"");
     if(info!.error=="000"){
       emailCount.clear();
       successToast("password sent to your email");
     }
    {
      errorToast(info!.message!);
    }
  }
