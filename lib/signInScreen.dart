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
import 'doctor/DashboardDoctor/DoctorDashBoard.dart';
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
  String Type="user";
  List<DemoLoginModel> demoLoginData =  [];


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
      emailCont.text = getStringAsync(USER_EMAIL);
     }
    demoLoginData.add(DemoLoginModel('images/icons/user.png'));
    demoLoginData.add(DemoLoginModel('images/icons/doctorIcon.png'));
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
                            showDialog(context: context, builder:  (context) {
                              return AlertDialog(content: StatefulBuilder(builder:
                                  (BuildContext context, void Function(void Function()) setState)
                              { return const forgotDialog(); },),);
                            },);
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
                    40.height,
                    hideSignUp(),
                    20.height,
                    HorizontalList(
                      itemCount: demoLoginData.length,
                      spacing: 16,
                      itemBuilder: (context, index) {
                        DemoLoginModel data = demoLoginData[index];
                        bool isSelected = selectedIndex == index;

                        return GestureDetector(
                          onTap: () {
                            selectedIndex = index;
                            setState(() {});

                            if (index == 0) {
                              successToast("User login");
                              Type ="user";
                              // emailCont.text = patientEmail;
                              // passwordCont.text = loginPassword;
                            } else if (index == 1) {
                              successToast("Doctor login");
                                Type ="doctor";
                              // emailCont.text = receptionistEmail;
                              // passwordCont.text = loginPassword;
                            }
                          },
                          child: Container(
                            child: Image.asset(
                              data.loginTypeImage.validate(),
                              height: 22,
                              width: 22,
                              fit: BoxFit.cover,
                              color: isSelected ? white : appSecondaryColor,
                            ),
                            decoration: boxDecorationWithRoundedCorners(
                              boxShape: BoxShape.circle,
                              backgroundColor: isSelected
                                  ? appSecondaryColor
                                  : false
                                  ? cardDarkColor
                                  : white,
                            ),
                            padding: EdgeInsets.all(12),
                          ),
                        );
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
    var info = await ApiService.login(email,  password, Type);

    if (info!.error == "000") {
     await setValue(USER_ID,  info.id);
     await setValue(USER_TOKEN, info.token);
     await setValue(USER_CITY,info.city);
     await  setValue(USER_EMAIL,  info.email);
     await  setValue(USER_NAME, info.name);
     await  setValue(USER_MOBILE, info.mobile);
     await  setValue(USER_TYPE, info.type);
      var imagePath = USER_IMAGE_URL+info.file!;
      setValue(PROFILE_IMAGE, imagePath);
      setValue(IS_LOGGED_IN,  true);
      successToast("login successful");
     if(info.type=="user") {
       PatientDashBoardScreen().launch(
           context, pageRouteAnimation: PageRouteAnimation.Scale);
     }else if(info.type=="doctor"){
       DoctorDashboardScreen().launch(
           context, pageRouteAnimation: PageRouteAnimation.Scale);
       ;
     }
      /*Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PatientDashBoardScreen(),
        ),
      );*/
    }else{
      print(info.message);
    }
  }

Widget  hideSignUp() {
     if(Type=="user") {
       return loginRegisterWidget(
         context,
         title: 'Dont have account?',
         subTitle: 'SignUp',
         onTap: () {
           SignUpScreen().launch(context);
         },
       );
     }
     return 5.width;
}
}

class DemoLoginModel {
  String? loginTypeImage;

  DemoLoginModel(this.loginTypeImage);
}
