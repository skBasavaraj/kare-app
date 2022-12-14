import 'dart:io';

import 'package:async/async.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  File? file;

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
    genderList.add(GenderModel(name:  "Male", value: "Male"));
    genderList.add(GenderModel(name:  "Female", value: "Female"));
    genderList.add(GenderModel(name:  "Other", value: "Other"));
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
                          'MinimumAgeRequired' +  'CurrentAgeIs' + ' ${DateTime.now().year - birthDate.year}',
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

        backgroundColor:  scaffoldBgColor,
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
                        textStyle: primaryTextStyle(color:  textPrimaryBlackColor ),
                        controller: firstNameCont,
                        textFieldType: TextFieldType.NAME,
                        decoration: textInputStyle(
                          context: context,
                          label: 'FirstName',
                          isMandatory: true,
                          text:"FirstName",
                          suffixIcon: commonImage(

                            imageUrl: "images/icons/user.png",
                            size: 10,
                          ),
                        ),
                        focus: firstNameFocus,
                        errorThisFieldRequired:  'FirstNameIsRequired',
                        nextFocus: lastNameFocus,
                      ),
                      16.height,
                      AppTextField(
                        textStyle: primaryTextStyle(color:  textPrimaryBlackColor),
                        controller: lastNameCont,
                        textFieldType: TextFieldType.NAME,
                        decoration: textInputStyle(
                          context: context,
                          label: 'LastName',
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
                      ),
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
                          if (s!.trim().isEmpty) return  'ContactNumberIsRequired';
                          return null;
                        },
                        decoration: textInputStyle(
                          context: context,
                          label: 'ContactNumber',
                          text: 'ContactNumber',
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
                      16.height,
                      AppTextField(
                        controller: cityCont,
                        focus: cityFocus,
                        nextFocus: stateFocus,
                        textStyle: primaryTextStyle(color:   textPrimaryBlackColor  ),

                        textFieldType: TextFieldType.OTHER,
                        decoration: textInputStyle(context: context,
                            label: 'City'
                            ,text: 'City'
                        ),
                      ),
                      16.height,
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
                      60.height,
                      AppButton(
                        width: context.width(),
                        shapeBorder: RoundedRectangleBorder(borderRadius: radius()),
                        onTap: () async {
                          // signUp();
                          var info = await editRegister( firstNameCont.text.validate(),lastNameCont.text.validate(),emailCont.text.validate(),
                              contactNumberCont.text.toString(),birthDate.toString().validate(),
                              genderValue.validate(), filePath!,addressCont.text,cityCont.text,stateCont.text,countryCont.text,postalCodeCont.text
                          ) ;
                          if(info!.error =="000"){
                            successToast(info.message);
                            Navigator.pop(context);
                          }
                        },
                        color: primaryColor,
                        padding: EdgeInsets.all(16),
                        child: Text( 'Submit', style: boldTextStyle(color: textPrimaryWhiteColor)),
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
              Positioned(
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, size: 20),
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
    //  "${appointmentAppStore.reportList.length} ${languageTranslate('FilesSelected')}";
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
              (getStringAsync(USER_EMAIL) == receptionistEmail || getStringAsync(USER_EMAIL) == doctorEmail || getStringAsync(USER_EMAIL) == patientEmail)
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



