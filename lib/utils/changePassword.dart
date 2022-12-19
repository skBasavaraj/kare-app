import 'package:flutter/material.dart';

import 'package:nb_utils/nb_utils.dart';

import '../appConstants.dart';
import '../network/apiService.dart';
import 'appCommon.dart';
import 'appwigets.dart';
import 'color_use.dart';


class ChangePasswordScreen extends StatefulWidget {
  static String tag = '/ChangePasswordScreen';

  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  var formKey = GlobalKey<FormState>();

  TextEditingController oldPassCont = TextEditingController();
  TextEditingController newPassCont = TextEditingController();
  TextEditingController confNewPassCont = TextEditingController();

  FocusNode newPassFocus = FocusNode();
  FocusNode confPassFocus = FocusNode();

  bool oldPasswordVisible = false;
  bool newPasswordVisible = false;
  bool confPasswordVisible = false;

  bool mIsLoading = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    oldPassCont.text= getStringAsync(USER_EMAIL);
    setStatusBarColor( appPrimaryColor, statusBarIconBrightness: Brightness.light);
  }

  void submit() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();



      mIsLoading = true;
      setState(() {});

   /*   await forgotPasswrd( oldPassCont.text, newPassCont.text).then((value) async {
        setStringAsync(PASSWORD, newPassCont.text.trim());
        finish(context);
        successToast(value!.message);

      }).catchError((e) {
        errorToast(e.toString());
      }).whenComplete(() {
        mIsLoading = false;
        setState(() {});
      });*/

      var info = await editRegister(getStringAsync(USER_ID) ,getStringAsync(USER_NAME), getStringAsync(USER_EMAIL),
           getStringAsync(USER_MOBILE),  getStringAsync(USER_CITY),newPassCont.text.validate()

      ) ;
      if(info!.error =="000"){
        successToast("password reset");
        print("ppp"+newPassCont.text.validate());
        mIsLoading = false;
        setState(() {});
        Navigator.pop(context);
        print(info.message);

      }else{
        print(info.message);
      }
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    oldPassCont.dispose();
    newPassCont.dispose();
    confNewPassCont.dispose();

    newPassFocus.dispose();
    confPassFocus.dispose();
   // setDynamicStatusBarColor(color: scaffoldBgColor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: scaffoldBgColor,
        appBar: appAppBar(context, name: 'ChangePassword'),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    AppTextField(
                      controller: oldPassCont,
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
                    16.height,
                    AppTextField(
                      controller: newPassCont,
                      textFieldType: TextFieldType.PASSWORD,
                      decoration: textInputStyle(context: context, label: 'NewPassword',text: 'New password'),
                      focus: newPassFocus,
                      suffixPasswordVisibleWidget: commonImage(
                        imageUrl: "images/icons/showPassword.png",
                        size: 10,
                      ),
                      suffixPasswordInvisibleWidget: commonImage(
                        imageUrl: "images/icons/hidePassword.png",
                        size: 10,
                      ),
                      nextFocus: confPassFocus,
                      textStyle: primaryTextStyle(),
                    ),
                    16.height,
                    AppTextField(
                      controller: confNewPassCont,
                      textFieldType: TextFieldType.PASSWORD,
                      decoration: textInputStyle(context: context, label: 'lblConfirmPassword',text:"Confirm password"),
                      focus: confPassFocus,
                      suffixPasswordVisibleWidget: commonImage(
                        imageUrl: "images/icons/showPassword.png",
                        size: 10,
                      ),
                      suffixPasswordInvisibleWidget: commonImage(
                        imageUrl: "images/icons/hidePassword.png",
                        size: 10,
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) return errorThisFieldRequired;
                        if (value.length < passwordLengthGlobal) return  'PasswordLengthMessage' + ' $passwordLengthGlobal';
                        if (value.trim() != newPassCont.text.trim()) return  "BothPasswordMatched";
                        return null;
                      },
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (s) {

                        //submit();
                      },
                      textStyle: primaryTextStyle(),
                    ),
                    30.height,
                    AppButton(
                      color: primaryColor,
                      onTap: () {
                        hideKeyboard(context);

                        submit();
                      },
                      text:  'submit',
                      textStyle: boldTextStyle(color:  Colors.white),
                      width: context.width(),
                    ),
                  ],
                ),
              ),
            ),
            setLoader().withSize(height: 40, width: 40).center().visible(mIsLoading),
          ],
        ),
      ),
    );
  }
}
