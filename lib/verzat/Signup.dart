import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
 
import 'package:nb_utils/nb_utils.dart';
import 'dart:async';
import 'dart:developer' as logDev;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zatcare/utils/appCommon.dart';

import '../appConstants.dart';
import '../network/apiService.dart';
import '../utils/color_use.dart';

 


class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FilePickerResult? result;

  File? file;
  String? dropdownvalue ;
    String? cityName;
  // List of items in our dropdown menu
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
  List<String> bloodGroupList = ['A+', 'B+', 'AB+', 'O+', 'A-', 'B-', 'AB-', 'O-'];
  List<GenderModel> genderList = [];
  TextEditingController fileCont = TextEditingController();
  String? filePath;
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
  TextEditingController postalCodeCont = TextEditingController();

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
  FocusNode postalCodeFocus = FocusNode();

  late DateTime birthDate;

  bool isLoading = false;

  int selectedGender = -1;

  signUp() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
    //  appStore.setLoading(true);
      setState(() {});


    }
  }


  @override
  void initState() {
    super.initState();
    init();


  }


  init() async {

    genderList.add(GenderModel(name:  "Male", value: "Male"));
    genderList.add(GenderModel(name:  "Female", value: "Female"));
    genderList.add(GenderModel(name:  "Other", value: "Other"));
    Position pos = await determinePosition();
    //

    List<Placemark> placemarks = await placemarkFromCoordinates(
      pos.latitude, pos.longitude, localeIdentifier: 'en',);
    var first = placemarks.first;
    cityCont.text = first.locality!;
     addressCont.text = first.subLocality!;
    postalCodeCont.text = first.postalCode!;
    countryCont.text = first.country!;
    stateCont.text = first.administrativeArea!;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> dateBottomSheet(context, {DateTime? bDate}) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext e) {
        return Container(
          height: 245,
          color:   Colors.white,
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text( 'Cancel', style: boldTextStyle()).onTap(() {
                      finish(context);
                      setState(() {});
                    }),
                    Text( 'Done', style: boldTextStyle()).onTap(() {
                      if (DateTime.now().year - birthDate.year < 18) {
                        toast(
                           'MinimumAgeRequired' + ('CurrentAgeIs') + ' ${DateTime.now().year - birthDate.year}',
                          bgColor: errorBackGroundColor,
                          textColor: errorTextColor,
                        );
                      } else {
                        finish(context);
                        dOBCont.text = birthDate.getFormattedDate(BIRTH_DATE_FORMAT).toString();
                      }
                    })
                  ],
                ).paddingOnly(top: 8, left: 8, right: 8, bottom: 8),
              ),
              Container(
                height: 200,
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(dateTimePickerTextStyle: primaryTextStyle(size: 20)),
                  ),
                  child: CupertinoDatePicker(
                    minimumDate: DateTime(1900, 1, 1),
                    minuteInterval: 1,
                    initialDateTime: bDate == null ? DateTime.now() : bDate,
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (DateTime dateTime) {
                      birthDate = dateTime;
                      setState(() {});
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
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

        backgroundColor:   scaffoldBgColor,
        body: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('images/appIcon.png', height: 100, width: 100),
                      16.height,

                      AppTextField(
                        textStyle: primaryTextStyle(color:  textPrimaryBlackColor),
                        controller: firstNameCont,
                        textFieldType: TextFieldType.NAME,
                        decoration: textInputStyle(
                          context: context,
                          label: 'Name',
                          text: 'Name',
                          isMandatory: true,
                          suffixIcon: commonImage(
                            imageUrl: "images/icons/user.png",
                            size: 10,
                          ),
                        ),
                        focus: firstNameFocus,
                        errorThisFieldRequired:  'Name Is Required',
                        nextFocus: lastNameFocus,
                      ),
                      16.height,
                      AppTextField(
                        textStyle: primaryTextStyle(color:   textPrimaryBlackColor),
                        controller: lastNameCont,
                        textFieldType: TextFieldType.NAME,
                        decoration: textInputStyle(
                          context: context,
                          label: 'User Name',
                          text: 'User Name',
                          isMandatory: true,
                          suffixIcon: commonImage(
                            imageUrl: "images/icons/user.png",
                            size: 10,
                          ),
                        ),
                        focus: lastNameFocus,
                        nextFocus: emailFocus,
                        errorThisFieldRequired:  'User Name Is Required',
                      ),

                      16.height,
                      AppTextField(
                        textStyle: primaryTextStyle(color:  textPrimaryBlackColor ),
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
                        controller: passwordCont,
                        focus: passwordFocus,
                         textStyle: primaryTextStyle(color:  textPrimaryBlackColor ),

                        textFieldType: TextFieldType.PASSWORD,
                        suffixPasswordVisibleWidget: commonImage(
                            imageUrl: "images/icons/showPassword.png", size: 18),
                        suffixPasswordInvisibleWidget: commonImage(
                            imageUrl: "images/icons/hidePassword.png", size: 18),
                        decoration: textInputStyle(
                            context: context,
                            label: 'Password'
                            ,text: 'Password'
                        ),
                      )
                      ,16.height,
                      AppTextField(
                        textStyle: primaryTextStyle(color:   textPrimaryBlackColor  ),
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
                      AppTextField(
                        textStyle: primaryTextStyle(color:   textPrimaryBlackColor  ),
                        controller: dOBCont,
                        nextFocus: bloodGroupFocus,
                        focus: dOBFocus,
                        textFieldType: TextFieldType.NAME,
                        errorThisFieldRequired:  'Birth Date Is Required',
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
                    /*  16.height,
                      AppTextField(
                        controller: addressCont,
                        focus: addressFocus,
                        nextFocus: cityFocus,
                        textStyle: primaryTextStyle(color:  textPrimaryBlackColor ),

                        keyboardType: TextInputType.multiline,
                        // maxLines: null,
                        textFieldType: TextFieldType.OTHER,

                        decoration: textInputStyle(context: context,
                            label: 'Address'
                            ,text: 'Address'
                        ).copyWith(alignLabelWithHint: true),
                        minLines: 4,
                        maxLines: 4,
                        textInputAction: TextInputAction.newline,
                      ),*/
                      16.height,
                    /*  AppTextField(
                        controller: cityCont,
                        focus: cityFocus,
                        nextFocus: stateFocus,
                        textStyle: primaryTextStyle(color:  textPrimaryBlackColor ),

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
                          child: DropdownButton(
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
                      60.height,
                      AppButton(
                        width: context.width(),
                        shapeBorder: RoundedRectangleBorder(borderRadius: radius()),
                        onTap: () async {
                          // signUp();
                          var info = await  ApiService.register(filePath!,firstNameCont.text.validate(),lastNameCont.text.validate()
                          ,emailCont.text.validate(),contactNumberCont.text,cityName!,passwordCont.text.validate(),dOBCont.text
                             ,  genderValue.validate());

                          if(info!.error =="001"){
                            successToast(info.message);
                            Navigator.pop(context);
                          }else{
                            errorToast(info.message!);
                          }
                        },
                        color: primaryColor,
                        padding: EdgeInsets.all(16),
                        child: Text( 'Submit', style: boldTextStyle(color: textPrimaryBlackColor)),
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
          /*    // Observer(
              //   builder: (context) => setLoader().withSize(width: 40, height: 40).visible(appStore.isLoading).center(),
              // ),*/
              Positioned(
                child: IconButton(
                  icon: Icon(Icons.arrow_back, size: 20),
                  onPressed: () {
                    finish(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );


  }
  void pickSingleFile() async {
    if (isProEnabled()) {
      result = await FilePicker.platform
          .pickFiles(allowMultiple: false, type: FileType.any);
      // logDev.log(result.toString(), name: "file");
    } else {
      result = await FilePicker.platform.pickFiles();
    }

    if (result != null) {
     // appointmentAppStore.addReportData(data: result!.files);
      filePath = result!.files.first.path;

      fileCont.text =filePath!;
      //"${appointmentAppStore.reportList.length} ${languageTranslate('FilesSelected')}";
    } else {
      toast( 'NoReportWasSelected');
    }
    setState(() {});
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