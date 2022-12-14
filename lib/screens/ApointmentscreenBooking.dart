import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:nb_utils/nb_utils.dart';
import 'dart:developer' as logDev;

import '../appConstants.dart';
import '../network/apiService.dart';
import '../utils/appCommon.dart';
import '../utils/appwigets.dart';
import '../utils/color_use.dart';

class ApointmentScreen extends StatefulWidget {
  final Doctors? doctors;

  ApointmentScreen(this.doctors);

  @override
  State<ApointmentScreen> createState() => _ApointmentScreenState(doctors);
}

class _ApointmentScreenState extends State<ApointmentScreen> {
  final Doctors? doctors;

  FilePickerResult? result;

  File? file;

  var Drname;
  var clinicName;
  var doctorNumber;
  var doctorEmail;
  var doctorLocation;
  var userEmail;

  _ApointmentScreenState(this.doctors);

  String? appointmentTime;
  int? doctorId;
  String? slots;
  List<List<AppointmentSlotModel>> mainList = [];
  List<AppointmentSlotModel> mainList1 = [];
  List<AppointmentSlotModel> mainLists = [];
  List<List<AppointmentSlotModel>> mainList2 = [];

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<String> bloodGroupList = [
    'A+',
    'B+',
    'AB+',
    'O+',
    'A-',
    'B-',
    'AB-',
    'O-'
  ];
  List<GenderModel> genderList = [];
  String? filePath;
  int selected = -1;
  int mainSelected = -1;
  int selected2 = -1;
  int mainSelected2 = -1;
  String? slot = "";
  var info;
  bool isFirst = true;
  bool isFirstTime = true;
  bool isLoading = false;
  TextEditingController fileCont = TextEditingController();
  TextEditingController appointmentSlotsCont = TextEditingController();
  TextEditingController appointmentDateCont = TextEditingController();
  TextEditingController firstNameCont = TextEditingController();
  TextEditingController lastNameCont = TextEditingController();
  TextEditingController contactNumberCont = TextEditingController();
  TextEditingController dOBCont = TextEditingController();
  TextEditingController bloodGroupCont = TextEditingController();
  TextEditingController descriptionCont = TextEditingController();
  TextEditingController servicesCont = TextEditingController();
  String? genderValue;
  String? bloodGroup;

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode firstNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode contactNumberFocus = FocusNode();
  FocusNode dOBFocus = FocusNode();
  FocusNode genderFocus = FocusNode();
  FocusNode bloodGroupFocus = FocusNode();

  Map<String, dynamic> request = {};

  List<ServiceData> selectedServicesList = [];

  UpcomingAppointment? upcomingAppointment;
  DateTime? selectedDate;

  bool isUpdate = false;

  List<String?> ids = [];

  late DateTime birthDate;

  int selectedGender = -1;

  @override
  void initState() {
    super.initState();
    init();
    var dName = doctors!.name;
    Drname = dName!;
    clinicName = doctors!.hospital;
    doctorNumber = doctors!.number;
    doctorEmail = doctors!.email;
    doctorLocation = doctors!.location;
    userEmail = getStringAsync(USER_NAME);

    logDev.log(Drname!, name: 'app');
  }

  init() async {
    genderList.add(GenderModel(name: "Male", value: "Male"));
    genderList.add(GenderModel(name: "Female", value: "Female"));
    genderList.add(GenderModel(name: "Other", value: "Other"));
    setStatusBarColor(appPrimaryColor,
        statusBarIconBrightness: Brightness.light);

    if (isFirst) {
      getData();
      selected = -1;
      mainSelected = -1;
      setState(() {});
      // getData();
    }
    // await getConfiguration().catchError(log);

    LiveStream().on(CHANGE_DATE, (isUpdate) {
      if (isUpdate as bool) {
        //  mainList.clear();

      }
    });

    log(upcomingAppointment != null);
  }

  getData() {
    isLoading = true;
    setState(() {});
    mainList.add(getTimeSlots());
    mainList2.add(getTimeSlots2());
  }

  List<AppointmentSlotModel> getTimeSlots() {
    mainList1.add(AppointmentSlotModel(time: '08:30:AM', available: true));
    mainList1.add(AppointmentSlotModel(time: '09:30:AM', available: true));
    mainList1.add(AppointmentSlotModel(time: '10:00:AM', available: true));
    mainList1.add(AppointmentSlotModel(time: '10:30:AM', available: true));
    mainList1.add(AppointmentSlotModel(time: '11:30:AM', available: true));
    mainList1.add(AppointmentSlotModel(time: '12:30:PM', available: true));
    isLoading = false;

    return mainList1;
  }

  List<AppointmentSlotModel> getTimeSlots2() {
    mainLists.add(AppointmentSlotModel(time: '02:30:PM', available: true));
    mainLists.add(AppointmentSlotModel(time: '03:30:PM', available: true));
    mainLists.add(AppointmentSlotModel(time: '04:30:PM', available: true));
    mainLists.add(AppointmentSlotModel(time: '05:30:PM', available: true));
    mainLists.add(AppointmentSlotModel(time: '07:30:PM', available: true));
    mainLists.add(AppointmentSlotModel(time: '08:30:PM', available: true));
    isLoading = false;

    return mainLists;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    setStatusBarColor(
      scaffoldBgColor,
      statusBarIconBrightness: Brightness.dark,
    );
    // if (!appStore.isBookedFromDashboard) {
    //   appointmentAppStore.setSelectedDoctor(null);
    // }
    // appointmentAppStore.setDescription(null);
    // appointmentAppStore.setSelectedPatient(null);
    // appointmentAppStore.setSelectedTime(null);
    // appointmentAppStore.setSelectedPatientId(null);

    firstNameCont.dispose();
    lastNameCont.dispose();
    contactNumberCont.dispose();
    dOBCont.dispose();
    contactNumberCont.dispose();
    bloodGroupCont.dispose();
    fileCont.dispose();
    super.dispose();
  }

  Future<void> dateBottomSheet(context, {DateTime? bDate}) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext e) {
        return Container(
          height: 245,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Cancel', style: boldTextStyle()).onTap(() {
                      finish(context);
                      setState(() {});
                    }),
                    Text('Done', style: boldTextStyle()).onTap(() {
                      if (DateTime.now().year - birthDate.year < 18) {
                        toast(
                          'MinimumAgeRequired' +
                              'CurrentAgeIs' +
                              ' ${DateTime.now().year - birthDate.year}',
                          bgColor: errorBackGroundColor,
                          textColor: errorTextColor,
                        );
                      } else {
                        finish(context);
                        dOBCont.text = birthDate
                            .getFormattedDate(BIRTH_DATE_FORMAT)
                            .toString();
                      }
                    })
                  ],
                ).paddingOnly(top: 8, left: 8, right: 8, bottom: 8),
              ),
              Container(
                height: 200,
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                        dateTimePickerTextStyle: primaryTextStyle(size: 20)),
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: scaffoldBgColor,
        appBar: appAppBar(context, name: 'ConfirmAppointment'),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AbsorbPointer(
                        absorbing: isUpdate,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    isProEnabled()
                                        ? Text('Step3Of3',
                                            style: primaryTextStyle(
                                                size: 14,
                                                color: patientTxtColor))
                                        : Text(
                                            'Step2Of2',
                                            style: primaryTextStyle(
                                                size: 14, color: primaryColor),
                                          ),
                                    8.height,
                                  ],
                                ),
                                stepProgressIndicator(
                                    stepTxt: "2/2", percentage: 1.0),
                              ],
                            ),
                          ],
                        ).paddingAll(16),
                      ),
                      /* RichTextWidget(
                        list: [
                          TextSpan(
                            text: appFirstName,
                            style: boldTextStyle(
                              size: 32,
                              letterSpacing: 1,
                              color:  textPrimaryWhiteColor,
                            ),
                          ),
                          TextSpan(
                            text: appSecondName,
                            style: primaryTextStyle(
                              size: 32,
                              letterSpacing: 1,
                              color: textPrimaryWhiteColor,
                            ),
                          ),
                        ],
                      ).center(),
                      24.height,*/
                      Text('Patient Details',
                          style: boldTextStyle(size: titleTextSize)),
                      8.height,
                      Text('Dr.' + Drname,
                          style: TextStyle(
                              color: Colors.green,
                              fontFamily: fontFamilyPrimaryGlobal,
                              fontSize: 24,
                              fontWeight: FontWeight.w600)),
                      8.height,
                      AppTextField(
                        textStyle:
                            primaryTextStyle(color: textPrimaryWhiteColor),
                        controller: firstNameCont,
                        textFieldType: TextFieldType.NAME,
                        decoration: textInputStyle(
                          context: context,
                          label: 'Patient Name',
                          text: 'Patient Name',
                          isMandatory: true,
                          suffixIcon: commonImage(
                            imageUrl: "images/icons/user.png",
                            size: 10,
                          ),
                        ),
                        focus: firstNameFocus,
                        errorThisFieldRequired: 'Patient Name Is Required',
                        nextFocus: lastNameFocus,
                      ),
                      16.height,
                      AppTextField(
                        textStyle:
                            primaryTextStyle(color: textPrimaryWhiteColor),
                        controller: contactNumberCont,
                        focus: contactNumberFocus,
                        nextFocus: dOBFocus,
                        textFieldType: TextFieldType.PHONE,
                        validator: (s) {
                          if (s!.trim().isEmpty)
                            return 'Contact Number Is Required';
                          return null;
                        },
                        decoration: textInputStyle(
                          context: context,
                          label: 'Contact Number',
                          text: "Contact Number",
                          isMandatory: true,
                          suffixIcon: commonImage(
                            imageUrl: "images/icons/phone.png",
                            size: 10,
                          ),
                        ),
                      ),
                      16.height,


                      AppTextField(
                        textStyle:
                        primaryTextStyle(color: textPrimaryWhiteColor),
                        controller: dOBCont,
                        textFieldType: TextFieldType.NUMBER,
                        nextFocus: bloodGroupFocus,
                        focus: dOBFocus,
                         errorThisFieldRequired: 'Age Is Required',
                        decoration: textInputStyle(
                          context: context,
                          label: 'Age',
                          text: 'Age',
                        ),
                        ),
                      16.height,
                      DropdownButtonFormField(
                        decoration: textInputStyle(
                          context: context,
                          label: 'Blood Group',
                          text: 'Blood Group',
                          isMandatory: true,
                          suffixIcon: commonImage(
                            imageUrl: "images/icons/arrowDown.png",
                            size: 10,
                          ),
                        ),
                        icon: SizedBox.shrink(),
                        isExpanded: true,
                        focusColor: primaryColor,
                        dropdownColor: Theme.of(context).cardColor,
                        focusNode: bloodGroupFocus,
                        validator: (dynamic s) {
                          if (s == null) return 'Blood Group Is Required';
                          return null;
                        },
                        onChanged: (dynamic value) {
                          bloodGroup = value;
                        },
                        items: bloodGroupList
                            .map(
                              (bloodGroup) => DropdownMenuItem(
                                value: bloodGroup,
                                child: Text("$bloodGroup",
                                    style: primaryTextStyle()),
                              ),
                            )
                            .toList(),
                      ),
                      16.height,
                      Align(
                        alignment: Alignment.topLeft,
                        child:
                            Text('Gender', style: primaryTextStyle(size: 12)),
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
                                    padding: selectedGender == index
                                        ? EdgeInsets.all(2)
                                        : EdgeInsets.all(1),
                                    decoration: boxDecorationWithRoundedCorners(
                                      boxShape: BoxShape.circle,
                                      border: Border.all(
                                        color: selectedGender == index
                                            ? primaryColor
                                            : secondaryTxtColor
                                                .withOpacity(0.5),
                                      ),
                                      backgroundColor: Colors.transparent,
                                    ),
                                    child: Container(
                                      height: selectedGender == index ? 10 : 10,
                                      width: selectedGender == index ? 10 : 10,
                                      decoration:
                                          boxDecorationWithRoundedCorners(
                                        boxShape: BoxShape.circle,
                                        backgroundColor: selectedGender == index
                                            ? primaryColor
                                            : white,
                                      ),
                                    ),
                                  ),
                                  8.width,
                                  Text(genderList[index].name!,
                                          style: primaryTextStyle(
                                              size: 12,
                                              color: secondaryTxtColor))
                                      .flexible()
                                ],
                              ).center(),
                            ).onTap(() {
                              genderValue = genderList[index].value;
                              selectedGender = index;

                              setState(() {});
                            },
                                borderRadius: BorderRadius.circular(
                                    defaultRadius)).paddingRight(16);
                          },
                        ),
                      ),
                      60.height,
                      Row(
                        children: [
                          AppTextField(
                            controller: appointmentDateCont,
                            textFieldType: TextFieldType.OTHER,
                            decoration: textInputStyle(
                              context: context,
                              label: 'Appointment Date',
                              text: 'Appointment Date',
                              isMandatory: true,
                              suffixIcon: commonImage(
                                  imageUrl: "images/icons/calendar.png",
                                  size: 10),
                            ),
                            readOnly: true,
                            onTap: () async {
                              selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2021),
                                lastDate: DateTime(2099),
                                helpText: "Select Appointment Date",
                                builder: (context, child) {
                                  return child!;
                                },
                              );

                              appointmentDateCont.text =
                                  DateFormat(CONVERT_DATE)
                                      .format(selectedDate!);

                              LiveStream().emit(CHANGE_DATE, true);
                              setState(() {});
                            },
                            validator: (s) {
                              if (s!.trim().isEmpty) return 'Date Is Required';
                              return null;
                            },
                          ).expand(),
                        ],
                      ),
                      16.height,
                      Row(
                        children: [
                          AppTextField(
                            controller: appointmentSlotsCont,
                            textFieldType: TextFieldType.OTHER,
                            decoration: textInputStyle(
                              context: context,
                              label: 'Select Slots',
                              text: 'Select Slots',
                              isMandatory: true,
                              suffixIcon: commonImage(
                                imageUrl: "images/icons/calendar.png",
                                size: 10,
                              ),
                            ),
                            readOnly: true,
                            validator: (s) {
                              if (s!.trim().isEmpty)
                                return 'Time Slot Is Required';
                              return null;
                            },
                          ).expand(),
                        ],
                      ),
                      16.height,
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: mainList2.length,
                        padding: EdgeInsets.only(bottom: 16),
                        itemBuilder: (context, index) {
                          var data = mainList[index];
                          var data2 = mainList2[index];
                          return Container(
                            padding: EdgeInsets.all(16),
                            margin: EdgeInsets.only(bottom: 24),
                            decoration: boxDecorationWithRoundedCorners(
                                backgroundColor: context.cardColor),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
//16.height.visible(index != 0),
                                Row(
                                  children: [
                                    Image.asset('images/icons/morning.png',
                                        height: 20,
                                        color: (index + 1) == 2
                                            ? Color(0xFFFF6433)
                                            : null),
                                    5.width,
                                    Text('Session ' + '  ${index + 1}',
                                        style: boldTextStyle(size: 16)),
                                  ],
                                ),
                                16.height,
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 16,
                                  children: List.generate(
                                    data.length,
                                    (i) {
                                      var sessionData = data[i];
                                      if (isFirstTime) {}
                                      return Container(
                                        width: 65,
                                        padding:
                                            EdgeInsets.fromLTRB(8, 8, 8, 8),
                                        decoration:
                                            boxDecorationWithRoundedCorners(
                                          backgroundColor: (selected == i &&
                                                  mainSelected == index)
                                              ? primaryColor
                                              : sessionData.available == false
                                                  ? errorBackGroundColor
                                                      .withOpacity(0.4)
                                                  // : appStore.isDarkModeOn
                                                  // ? cardDarkColor
                                                  : scaffoldBgColor,
                                          borderRadius: BorderRadius.circular(
                                              defaultRadius),
                                        ),
                                        child: FittedBox(
                                          child: Text(
                                            '${sessionData.time}',
                                            style: boldTextStyle(
                                              color: (selected == i &&
                                                      mainSelected == index)
                                                  ? Colors.white
                                                  : sessionData.available ==
                                                          false
                                                      ? Colors.red
                                                          .withOpacity(0.6)
                                                      : primaryColor,
                                              size: 12,
                                              decoration: (sessionData
                                                          .available ==
                                                      false)
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none,
                                            ),
                                          ).center(),
                                        ),
                                      ).onTap(
                                        () {
                                          if (sessionData.available!) {
                                            selected = i;
                                            mainSelected = index;
                                            slot = sessionData.time;
                                            appointmentSlotsCont.text =
                                                sessionData.time!;
                                          } else
                                            errorToast('Time Slot Is Booked');
                                          setState(() {});
                                        },
                                      );
                                    },
                                  ),
                                ),
                                16.height,
                                Row(
                                  children: [
                                    Image.asset('images/icons/morning.png',
                                        height: 20,
                                        color: (index + 1) == 2
                                            ? Colors.red
                                            : null),
                                    5.width,
                                    Text('Session' + ' 2',
                                        style: boldTextStyle(size: 16)),
                                  ],
                                ),
                                16.height,
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 16,
                                  children: List.generate(
                                    data.length,
                                    (i) {
                                      var sessionData = data2[i];
                                      if (isFirstTime) {}
                                      return Container(
                                        width: 65,
                                        padding:
                                            EdgeInsets.fromLTRB(8, 8, 8, 8),
                                        decoration:
                                            boxDecorationWithRoundedCorners(
                                          backgroundColor: (selected2 == i &&
                                                  mainSelected2 == index)
                                              ? primaryColor
                                              : sessionData.available == false
                                                  ? errorBackGroundColor
                                                      .withOpacity(0.4)
                                                  // : appStore.isDarkModeOn
                                                  // ? cardDarkColor
                                                  : scaffoldBgColor,
                                          borderRadius: BorderRadius.circular(
                                              defaultRadius),
                                        ),
                                        child: FittedBox(
                                          child: Text(
                                            '${sessionData.time}',
                                            style: boldTextStyle(
                                              color: (selected2 == i &&
                                                      mainSelected2 == index)
                                                  ? Colors.white
                                                  : sessionData.available ==
                                                          false
                                                      ? Colors.red
                                                          .withOpacity(0.6)
                                                      : primaryColor,
                                              size: 12,
                                              decoration: (sessionData
                                                          .available ==
                                                      false)
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none,
                                            ),
                                          ).center(),
                                        ),
                                      ).onTap(
                                        () {
                                          if (sessionData.available!) {
                                            selected2 = i;
                                            mainSelected2 = index;
                                            slot = sessionData.time;
                                            appointmentSlotsCont.text =
                                                sessionData.time!;
                                            // appointmentAppStore.setSelectedTime(
                                            //     sessionData.time);
                                          } else
                                            errorToast('TimeSlotIsBooked');
                                          setState(() {});
                                        },
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ).visible(!isLoading, defaultWidget: setLoader()),
                      NoDataFoundWidget(iconSize: 110)
                          .visible(mainList.isEmpty && !isLoading)
                          .center(),
                      16.height,
                      AppTextField(
                        textStyle:
                            primaryTextStyle(color: textPrimaryWhiteColor),
                        controller: lastNameCont,
                        textFieldType: TextFieldType.NAME,
                        decoration: textInputStyle(
                          context: context,
                          label: 'Subject',
                          text: 'Subject',
                        ),
                        focus: lastNameFocus,
                        nextFocus: contactNumberFocus,
                      ),
                      16.height,
                      AbsorbPointer(
                          absorbing: isUpdate,
                          child: AppTextField(
                            maxLines: 15,
                            minLines: 5,
                            controller: descriptionCont,
                            textFieldType: TextFieldType.ADDRESS,
                            decoration: textInputStyle(
                                    context: context,
                                    label: 'Description',
                                    text: 'Description')
                                .copyWith(
                              alignLabelWithHint: true,
                            ),
                          )),
                     /* 16.height,
                      AppTextField(
                        controller: fileCont,
                        textFieldType: TextFieldType.ADDRESS,
                        readOnly: true,
                        decoration: textInputStyle(
                                context: context, text: 'Add Medical Report')
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
                      ),*/
                      86.height,
                    ],
                  ),
                ).center(),
                Observer(
                  builder: (context) => setLoader()
                      .withSize(width: 40, height: 40)
                      .visible(false)
                      .center(),
                ),
              ],
            ),
          ).visible(!isLoading, defaultWidget: setLoader()),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: appSecondaryColor,
          label: Text('Book', style: boldTextStyle(color: white))
              .paddingSymmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(defaultRadius)),
          onPressed: () async {
            // saveData();
            logDev.log("1", name: "upload");
            info = await ApiService.bookAppointments(
              getStringAsync(USER_ID),
              doctors!.id!,
              firstNameCont.text.validate(),
               dOBCont.text,
              contactNumberCont.text.toString(),
              userEmail,
              genderValue.validate(),
              appointmentDateCont.text,
              appointmentSlotsCont.text,
              bloodGroup.validate(),
              lastNameCont.text,
              descriptionCont.text,
            );
            if (info?.status == "002") {
              successToast(info?.message);
            } else if (info?.status == "000") {
              successToast(" Book slot successful");
              Navigator.pop(context);
            } else {
              errorToast(info?.message);
              print(";;" + info.message);
              logDev.log(info?.status, name: "upload");
            }
          },
        ),
      ),
    );
  }

  void pickSingleFile() async {
    if (isProEnabled()) {
      result = await FilePicker.platform
          .pickFiles(allowMultiple: false, type: FileType.any);
      logDev.log(result.toString(), name: "file");
    } else {
      result = await FilePicker.platform.pickFiles();
    }

    if (result != null) {
      //appointmentAppStore.addReportData(data: result!.files);
      filePath = result!.files.first.path;

      fileCont.text = filePath!;
      //"${appointmentAppStore.reportList.length} ${languageTranslate('FilesSelected')}";
    } else {
      toast('NoReportWasSelected');
    }
    setState(() {});
  }

  void textClear() {
    fileCont.clear();
    appointmentSlotsCont.clear();
    appointmentDateCont.clear();
    firstNameCont.clear();
    lastNameCont.clear();
    dOBCont.clear();
    bloodGroupCont.clear();
    descriptionCont.clear();
    servicesCont.clear();
    contactNumberCont.clear();
  }
}

class NoDataFoundWidget extends StatelessWidget {
  final String? text;
  final double? iconSize;

  NoDataFoundWidget({this.text, this.iconSize});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          //appStore.isDarkModeOn ? "images/darkModeNoImage.png" :
          "images/noDataFound.png",
          height: iconSize ?? 180,
          fit: BoxFit.fitHeight,
        ),
        Text(text ?? ' lblNoMatch', style: boldTextStyle(size: 18)),
        8.height.visible(false),
        Text(
          'lblNoDataSubTitle',
          textAlign: TextAlign.center,
          style: secondaryTextStyle(color: secondaryTxtColor),
        ).visible(false),
      ],
    ).paddingAll(16);
  }
}
