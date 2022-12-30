import 'dart:io';

import 'package:async/async.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
 
import 'package:nb_utils/nb_utils.dart';
import 'package:zatcare/utils/appCommon.dart';

import '../appConstants.dart';
import '../network/apiService.dart';
import '../utils/color_use.dart';

 

class EditPatientProfileScreen extends StatefulWidget {
  @override
  _EditPatientProfileScreenState createState() => _EditPatientProfileScreenState();
}

class _EditPatientProfileScreenState extends State<EditPatientProfileScreen> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FilePickerResult? result;
  String? dropdownvalue ;
  String? cityName;
  var items = [
    'Ahmedabad',
    'Agra',
    'Bengaluru',
    'Bhopal',
    'Chennai',
    'Delhi',
    'Ernakulam',
    'Hyderabad',
    'Indore',
    'Jaipur',
    'Kochi',
    'Kolkata',
    'Lucknow',
    'Mumbai',
    'Pune',

  ];

   List<GenderModel> genderList = [];
  TextEditingController fileCont = TextEditingController();
   TextEditingController emailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController firstNameCont = TextEditingController();
  TextEditingController lastNameCont = TextEditingController();
  TextEditingController contactNumberCont = TextEditingController();
  TextEditingController dOBCont = TextEditingController();
  String? genderValue;
  String? bloodGroup;

  TextEditingController bloodGroupCont = TextEditingController();
  TextEditingController addressCont = TextEditingController();
  TextEditingController cityCont = TextEditingController();
  TextEditingController stateCont = TextEditingController();
  TextEditingController countryCont = TextEditingController();


  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode firstNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode contactNumberFocus = FocusNode();
  FocusNode dOBFocus = FocusNode();
  FocusNode genderFocus = FocusNode();
  FocusNode bloodGroupFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  FocusNode cityFocus = FocusNode();
  FocusNode stateFocus = FocusNode();
  FocusNode countryFocus = FocusNode();

  late DateTime birthDate;

  bool isLoading = false;

  int selectedGender = -1;

  signUp() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
     // appStore.setLoading(true);
      setState(() {});


    }
  }


  @override
  void initState() {
    super.initState();
    init();

  }


  init() async {

  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }


  @override
  void dispose() {
    emailCont.dispose();
    passwordCont.dispose();
    firstNameCont.dispose();
    lastNameCont.dispose();
    contactNumberCont.dispose();
    dOBCont.dispose();
    bloodGroupCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child: Scaffold(

        backgroundColor:  scaffoldBgColor,
         body: Form(

          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
             Material(
               elevation: 3,
               child:  Row(
                 children: [
                   IconButton(
                     icon: Icon(Icons.arrow_back, size: 30,color:Colors.white),
                     onPressed: () {
                       finish(context);
                     },
                   ).paddingLeft(10),
                   Text("Edit your profile",style: GoogleFonts.jost(fontSize: 25,color: Colors.white),)
                 ],
               ),
               color:Colors.blue



             ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /*Image.asset('images/appIcon.png', height: 150, width: 200),
                         Text("Edit your Details",style:GoogleFonts.jost(color:Colors.blue, fontSize: 30,fontWeight: FontWeight.w500),
                        ),*/
                      16.height,
                      AppTextField(
                        textStyle:  GoogleFonts.jost(color: textPrimaryBlackColor),
                        controller: firstNameCont,
                        textFieldType: TextFieldType.NAME,
                        decoration: textInputStyle(
                          context: context,
                          label: 'Name',
                          isMandatory: true,
                          text:"Name",
                          suffixIcon: commonImage(

                            imageUrl: "images/icons/user.png",
                            size: 10,
                          ),
                        ),
                        focus: firstNameFocus,
                        errorThisFieldRequired:  'Name Is Required',
                        nextFocus: lastNameFocus,
                      ),
                   /*   16.height,
                      AppTextField(
                        textStyle:  GoogleFonts.jost(color: textPrimaryBlackColor),
                        controller: lastNameCont,
                        textFieldType: TextFieldType.NAME,
                        decoration: textInputStyle(
                          context: context,
                          label: ' ',
                          text: 'LastName',
                          isMandatory: true,
                          suffixIcon: commonImage(
                            imageUrl: "images/icons/user.png",
                            size: 10,
                          ),
                        ),
                        focus: lastNameFocus,
                        nextFocus: emailFocus,
                        errorThisFieldRequired:  'LastNameIsRequired',
                      ),*/
                      16.height,
                      AppTextField(
                        textStyle: primaryTextStyle(color:   textPrimaryBlackColor  ),
                        controller: emailCont,
                        textFieldType: TextFieldType.EMAIL,
                        decoration: textInputStyle(
                          context: context,
                          label: 'Email',
                          text: 'Email',
                          isMandatory: true,
                          suffixIcon: commonImage(
                            imageUrl: "images/icons/message.png",
                            size: 10,
                          ),
                        ),
                        focus: emailFocus,
                        nextFocus: passwordFocus,
                      ),
                      16.height,
                      AppTextField(
                        textStyle: primaryTextStyle(color:  textPrimaryBlackColor  ),
                        controller: contactNumberCont,
                        focus: contactNumberFocus,
                        nextFocus: dOBFocus,
                        textFieldType: TextFieldType.PHONE,
                        validator: (s) {
                          if (s!.trim().isEmpty) return  'Contact Number Is Required';
                          return null;
                        },
                        decoration: textInputStyle(
                          context: context,
                          label: 'Contact Number',
                          text: 'Contact Number',
                          isMandatory: true,
                          suffixIcon: commonImage(
                            imageUrl: "images/icons/phone.png",
                            size: 10,
                          ),
                        ),
                      ),

                      16.height,
                     /* AppTextField(
                        textStyle: primaryTextStyle(color:   textPrimaryBlackColor  ),
                        controller: dOBCont,
                        nextFocus: bloodGroupFocus,
                        focus: dOBFocus,
                        textFieldType: TextFieldType.NAME,
                        errorThisFieldRequired:  'BirthDateIsRequired',
                        decoration: textInputStyle(
                          context: context,
                          label: 'DOB',
                          text: 'DOB',
                          isMandatory: true,
                          suffixIcon: commonImage(
                            imageUrl: "images/icons/calendar.png",
                            size: 10,
                          ),
                        ),
                        readOnly: true,
                        onTap: () {
                          dateBottomSheet(context);
                        },
                      ),
                      16.height,
                      AppTextField(
                        controller: addressCont,
                        focus: addressFocus,
                        nextFocus: cityFocus,
                        textStyle: primaryTextStyle(color:   textPrimaryBlackColor  ),

                        keyboardType: TextInputType.multiline,
                        // maxLines: null,
                        textFieldType: TextFieldType.OTHER,

                        decoration: textInputStyle(context: context,
                            label: 'Address'
                           , text: 'Address'
                        ).copyWith(alignLabelWithHint: true),
                        minLines: 4,
                        maxLines: 4,
                        textInputAction: TextInputAction.newline,
                      ),
                      16.height,*/
                     /* AppTextField(
                        controller: cityCont,
                        focus: cityFocus,
                        nextFocus: stateFocus,
                        textStyle: primaryTextStyle(color:   textPrimaryBlackColor  ),

                        textFieldType: TextFieldType.OTHER,
                        decoration: textInputStyle(context: context,
                            label: 'City'
                            ,text: 'City'
                        ),
                      ),*/
                      Container(
                        decoration:  BoxDecoration(color: Color(0xFFEDF4FF) ,borderRadius:  BorderRadius.circular(10),border:Border.all(color: Colors.blue,width: 1)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10,right: 10),
                          child:
                          DropdownButton(
                            hint:Text("Select City",style:GoogleFonts.jost(color: Colors.grey) ,),
                            iconSize: 30,
                            onTap: () {

                            },
                            dropdownColor: Colors.white,

                            borderRadius: BorderRadius.circular(10),
                            isExpanded: true,
                            // Initial Value
                            value: dropdownvalue ,

                            // Down Arrow Icon
                            icon: const Icon(Icons.keyboard_arrow_down,color: Colors.grey,),

                            // Array list of items
                            items: items.map((String items) {

                              return DropdownMenuItem(

                                value: items,
                                child: Text(items),

                              );
                            }).toList(),
                            // After selecting the desired option,it will
                            // change button value to selected value
                            onChanged: (String? newValue) {
                              cityName =newValue;
                              setState(() {
                                dropdownvalue = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                      16.height,
                    /*  16.height,
                      AppTextField(
                        controller: stateCont,
                        focus: stateFocus,
                        nextFocus: countryFocus,
                        textFieldType: TextFieldType.OTHER,
                        textStyle: primaryTextStyle(color:   textPrimaryBlackColor  ),

                        decoration: textInputStyle(context: context,
                            label: 'State',
                            text: 'State'),
                      ),
                      16.height,
                      AppTextField(
                        controller: countryCont,
                        focus: countryFocus,
                        nextFocus: postalCodeFocus,
                        textStyle: primaryTextStyle(color:   textPrimaryBlackColor  ),

                        textFieldType: TextFieldType.OTHER,
                        decoration: textInputStyle(context: context,
                            label: 'Country'
                            ,text: 'Country'
                        ,),
                      ),
                      16.height,
                      AppTextField(
                        controller: postalCodeCont,
                        focus: postalCodeFocus,
                        textStyle: primaryTextStyle(color:   textPrimaryBlackColor  ),

                        textFieldType: TextFieldType.OTHER,
                        decoration: textInputStyle(context: context,
                            label: 'PostalCode'
                            ,text: 'PostalCode'),
                      ),

                      16.height,
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text("Gender", style: primaryTextStyle(size: 12)),
                      ),
                      8.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                          genderList.length,
                              (index) {
                            return Container(
                              width: 90,
                              padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
                              decoration: boxDecorationWithRoundedCorners(
                                borderRadius: radius(defaultRadius),
                                backgroundColor: context.cardColor,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: selectedGender == index ? EdgeInsets.all(2) : EdgeInsets.all(1),
                                    decoration: boxDecorationWithRoundedCorners(
                                      boxShape: BoxShape.circle,
                                      border: Border.all(
                                        color: selectedGender == index ? primaryColor : secondaryTxtColor.withOpacity(0.5),
                                      ),
                                      backgroundColor: Colors.transparent,
                                    ),
                                    child: Container(
                                      height: selectedGender == index ? 10 : 10,
                                      width: selectedGender == index ? 10 : 10,
                                      decoration: boxDecorationWithRoundedCorners(
                                        boxShape: BoxShape.circle,
                                        backgroundColor: selectedGender == index ? primaryColor : white,
                                      ),
                                    ),
                                  ),
                                  8.width,
                                  Text(genderList[index].name!, style: primaryTextStyle(size: 12, color: secondaryTxtColor)).flexible()

                                ],
                              ).center(),
                            ).onTap(() {
                              genderValue = genderList[index].value;
                              selectedGender = index;

                              setState(() {});
                            }, borderRadius: BorderRadius.circular(defaultRadius)).paddingRight(16);
                          },
                        ),
                      ),
                      16.height,
                      AppTextField(
                        controller: fileCont,
                        textFieldType: TextFieldType.ADDRESS,
                        readOnly: true,
                        decoration: textInputStyle(
                            context: context,
                            text:  "Chose picture")
                            .copyWith(
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.upload_file),
                                iconSize: 18,
                                onPressed: () {
                                  pickSingleFile();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      60.height,*/
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
                      16.height,
                      AppButton(
                        width: context.width(),
                        shapeBorder: RoundedRectangleBorder(borderRadius: radius()),
                        onTap: () async {
                          // signUp();
                          if(firstNameCont.text.isNotEmpty&&emailCont.text.isNotEmpty&&passwordCont.text.isNotEmpty&&contactNumberCont.text.isNotEmpty) {
                            var info = await editRegister(
                                getStringAsync(USER_ID),
                                firstNameCont.text.validate(),
                                emailCont.text.validate(),
                                contactNumberCont.text.toString(),
                                cityName.toString(),
                                passwordCont.text.validate()

                            );
                            if (info!.error == "000") {
                              successToast(info.message);
                              snackBar(context,title: info.message!,backgroundColor: Colors.green.shade200);

                              Navigator.pop(context);
                            }
                          }else {
                            snackBar(context,title: "Please enter all the information",backgroundColor: Colors.red.shade200);
                          }
                        },
                        color: primaryColor,
                        padding: EdgeInsets.all(10),
                        child: Text( 'Submit', style: GoogleFonts.jost(color:  Colors.white,fontSize:20)),
                      ),
                      /*24.height,
                      loginRegisterWidget(context, title: languageTranslate('AlreadyAMember'), subTitle: languageTranslate('Login'), onTap: () {
                        finish(context);*/
                      /*}),
                      24.height,*/
                    ],
                  ),
                ),
              ).center(),
              // Observer(
              //   builder: (context) => setLoader().withSize(width: 40, height: 40).visible(appStore.isLoading).center(),
              // ),
             ],
          ),
        ),
      ),
    );


  }

  addEditedData() async {
    isLoading = true;
    setState(() {});
/*    Map<String, dynamic> qualificationRequest = {
      "ID": "${}",
      "user_email": "${}",
      "first_name": "${firstNameCont.text}",
      "last_name": "${lastNameCont.text}",
      "gender": "$genderValue",
      "dob": "${}",
      "address": "${}",
      "city": "${}",
      "country": "${}",
      "state": "${}",
      "postal_code": "${}",
      "mobile_number": "${}",
      "profile_image": "",
    };*/
//qualificationRequest, file: selectedImage != null ? File() : null

  }
}






/* @override
  Widget build(BuildContext context) {
    Widget body() {
      return SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 90),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.all(12),
                    decoration: boxDecorationWithRoundedCorners(backgroundColor: appStore.isDarkModeOn ? cardDarkColor : profileBgColor, boxShape: BoxShape.circle),
                    child: selectedImage != null
                        ? Image.file(File(selectedImage!.path), height: 90, width: 90, fit: BoxFit.cover, alignment: Alignment.center).cornerRadiusWithClipRRect(180)
                        : appStore.profileImage.validate().isNotEmpty
                            ? cachedImage(appStore.profileImage, height: 90, width: 90, fit: BoxFit.cover, alignment: Alignment.center).cornerRadiusWithClipRRect(180)
                            : Icon(Icons.person_outline_rounded).paddingAll(16),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: appPrimaryColor,
                        boxShape: BoxShape.circle,
                        border: Border.all(color: white, width: 3),
                      ),
                      child: Image.asset("images/icons/camera.png", height: 14, width: 14, color: Colors.white),
                    ).onTap(() {
                      getImage();
                    }),
                  )
                ],
              ).paddingOnly(top: 16, bottom: 16),
              16.height,
              Row(
                children: [
                  AppTextField(
                    controller: firstNameCont,
                    focus: firstNameFocus,
                    nextFocus: lastNameFocus,
                    textFieldType: TextFieldType.NAME,
                    decoration: textInputStyle(context: context, label: 'FirstName'),
                    scrollPadding: EdgeInsets.all(0),
                  ).expand(),
                  10.width,
                  AppTextField(
                    controller: lastNameCont,
                    focus: lastNameFocus,
                    nextFocus: emailFocus,
                    textFieldType: TextFieldType.NAME,
                    decoration: textInputStyle(context: context, label: 'LastName'),
                  ).expand(),
                ],
              ),
              16.height,
              (getStringAsync(USER_EMAIL) == receptionistEmail && getStringAsync(USER_EMAIL) == doctorEmail && getStringAsync(USER_EMAIL) == patientEmail)
                  ? AppTextField(
                      controller: emailCont,
                      focus: emailFocus,
                      nextFocus: contactNumberFocus,
                      textFieldType: TextFieldType.EMAIL,
                      readOnly: true,
                      onTap: () {
                        errorToast(languageTranslate('DemoEmailCannotBeChanged'));
                      },
                      decoration: textInputStyle(context: context, label: 'Email'),
                    )
                  : AppTextField(
                      controller: emailCont,
                      focus: emailFocus,
                      nextFocus: contactNumberFocus,
                      textFieldType: TextFieldType.EMAIL,
                      decoration: textInputStyle(context: context, label: 'Email'),
                    ),
              16.height,
              AppTextField(
                controller: contactNumberCont,
                focus: contactNumberFocus,
                nextFocus: dOBFocus,
                textFieldType: TextFieldType.PHONE,
                decoration: textInputStyle(context: context, label: 'ContactNumber'),
              ),
              16.height,
              AppTextField(
                controller: dOBCont,
                focus: dOBFocus,
                nextFocus: addressFocus,
                readOnly: true,
                validator: (s) {
                  if (s!.trim().isEmpty) return languageTranslate('ContactNumberIsRequired');
                  return null;
                },
                decoration: textInputStyle(context: context, label: 'DOB', isMandatory: true),
                onTap: () {
                  dateBottomSheet(context);
                  if (dOBCont.text.isNotEmpty) {
                    FocusScope.of(context).requestFocus(addressFocus);
                  }
                },
                textFieldType: TextFieldType.OTHER,
              ),
              16.height,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(languageTranslate('Gender1'), style: primaryTextStyle(size: 12, color: secondaryTxtColor)),
                  6.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      genderList.length,
                      (index) {
                        return Container(
                          width: 90,
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
                          decoration: boxDecorationWithRoundedCorners(
                            borderRadius: radius(defaultRadius),
                            backgroundColor: context.cardColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: selectedGender == index ? EdgeInsets.all(2) : EdgeInsets.all(1),
                                decoration: boxDecorationWithRoundedCorners(
                                  boxShape: BoxShape.circle,
                                  border: Border.all(color: selectedGender == index ? primaryColor : secondaryTxtColor.withOpacity(0.5)),
                                  backgroundColor: Colors.transparent,
                                ),
                                child: Container(
                                  height: selectedGender == index ? 10 : 10,
                                  width: selectedGender == index ? 10 : 10,
                                  decoration: boxDecorationWithRoundedCorners(
                                    boxShape: BoxShape.circle,
                                    backgroundColor: selectedGender == index ? primaryColor : white,
                                  ),
                                ),
                              ),
                              8.width,
                              Text(genderList[index].name!, style: primaryTextStyle(size: 12, color: secondaryTxtColor)).flexible()
                            ],
                          ).center(),
                        ).onTap(() {
                          if (selectedGender == index) {
                            selectedGender = -1;
                          } else {
                            genderValue = genderList[index].value;
                            selectedGender = index;
                          }
                          setState(() {});
                        }, borderRadius: BorderRadius.circular(defaultRadius)).paddingRight(16);
                      },
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      );
    }
*/



