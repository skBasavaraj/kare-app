import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:nb_utils/nb_utils.dart';
import 'package:zatcare/utils/appCommon.dart';
import 'package:zatcare/utils/appwigets.dart';
import 'package:zatcare/utils/changePassword.dart';
import 'package:zatcare/utils/color_use.dart';
import 'package:zatcare/utils/dialog.dart';
import 'package:zatcare/verzat/Signup.dart';

import 'dart:developer' as logDev;

import 'appConstants.dart';
import 'bottomNav/PatientDashBoardScreen.dart';
import 'network/apiService.dart';



class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  bool isRemember = false;
  var emailFocus = FocusNode();
  var passwordFocus = FocusNode();
   int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
       selectedIndex = 0;
    emailCont.text = "";
    passwordCont.text = "";
    if (getBoolAsync(IS_REMEMBER_ME)) {
      isRemember = true;
      emailCont.text = getStringAsync(USER_NAME);
      passwordCont.text = getStringAsync(USER_PASSWORD);
    }
  }

  void forgotPasswordDialog() {
  //  DoctorDashboardScreen()
    //CustomDailog().launch(context, isNewTask: true);

  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: scaffoldBgColor,
        body: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    32.height,
                    Image.asset('images/appIcon.png', height: 200, width: 150)
                        .center(),
                   /* 16.height,
                    RichTextWidget(
                      list: [
                        TextSpan(
                          text: appFirstName,
                          style: boldTextStyle(
                            size: 32,
                            letterSpacing: 1,
                            color:Colors.blue
                          ),
                        ),
                        TextSpan(
                          text: appSecondName,
                          style: primaryTextStyle(
                            size: 32,
                            letterSpacing: 1,
                            color:Colors.blue
                            ,
                          ),
                        ),
                      ],
                    ).center(),*/
                    16.height,

                    Text(
                       'Welcome Back, Login Account',
                      style: secondaryTextStyle(
                          size: 14,
                          color:  Colors.black),
                    ).center(),
                    32.height,
                    AppTextField(
                      controller: emailCont,
                      focus: emailFocus,
                      nextFocus: passwordFocus,
                      textStyle: primaryTextStyle(),
                      textFieldType: TextFieldType.EMAIL,

                      decoration: textInputStyle(
                        context: context,
                        label: 'Email',
                        text: 'Email',
                        suffixIcon: commonImage(
                            imageUrl: "images/icons/user.png", size: 18),
                      ),
                    ),
                    24.height,
                    AppTextField(
                      controller: passwordCont,
                      focus: passwordFocus,
                      textStyle: primaryTextStyle(),
                      textFieldType: TextFieldType.PASSWORD,
                      suffixPasswordVisibleWidget: commonImage(
                          imageUrl: "images/icons/showPassword.png", size: 18),
                      suffixPasswordInvisibleWidget: commonImage(
                          imageUrl: "images/icons/hidePassword.png", size: 18),
                      decoration: textInputStyle(
                          context: context, label: 'Password',text: 'Password'),
                    ),
                    4.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            4.width,
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: Theme(
                                data: ThemeData(
                                    unselectedWidgetColor: context.iconColor),
                                child: Checkbox(
                                  activeColor: appSecondaryColor,
                                  value: isRemember,
                                  onChanged: (value) async {
                                    isRemember = value.validate();
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                            8.width,
                            TextButton(
                              onPressed: () {
                                isRemember = !isRemember;
                                setState(() {});
                              },
                              child: Text( "RememberMe",
                                  style: secondaryTextStyle()),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            showDialog(context: context, builder:    (context) =>
                                forgotAlertDialog(context)
                              ,  );
                       //    return forgotPasswordDialog();

                           // ChangePasswordScreen().launch(context,pageRouteAnimation: PageRouteAnimation.Scale);
                          },
                          child: Text(
                            "ForgotPassword",
                            style: secondaryTextStyle(
                                color: appSecondaryColor,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ),
                    24.height,
                    AppButton(
                      width: context.width(),
                      hoverColor: Colors.white,
                      shapeBorder:
                      RoundedRectangleBorder(borderRadius: radius()),
                      onTap: () {
                        //saveForm();
                        signIn(emailCont.text, passwordCont.text);
                        if (isRemember) {
                          // setValue(USER_NAME, emailCont.text);
                          // setValue(USER_PASSWORD, passwordCont.text);
                          setValue(IS_REMEMBER_ME, true);
                        }
                      },
                      color: primaryColor,
                      padding: EdgeInsets.all(16),
                      child: Text( 'Sign In',
                          style: TextStyle(color: Colors.white,)),
                    ),
                    60.height,
                    loginRegisterWidget(
                      context,
                      title:  'Dont have account?',
                      subTitle: 'SignUp',
                      onTap: () {
                         SignUpScreen().launch(context);
                      },
                    ),
                  ],
                ),
              ),
              /*Observer(
                builder: (context) => setLoader()
                    .withSize(width: 40, height: 40)
                  //  .visible(appStore.isLoading)
                    .center(),
              )*/
            ],
          ),
        ),
      ),
    );
  }

  void signIn(String email, String password) async {
    var info = await ApiService.login(email, password);
    if (info!.error == "000") {
      setValue(USER_ID,  info.id);
      setValue(USER_CITY,info.city);
      setValue(USER_EMAIL,  info.email);
      setValue(USER_NAME, info.name);
      setValue(USER_MOBILE, info.mobile);

    //  setValue(USER_PASSWORD, passwordCont.text);
     // setValue(USER_STATE,info.state);
      setValue(IS_LOGGED_IN,  true);
      successToast("login successful");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PatientDashBoardScreen(),
        ),
      );
    }
  }
}
