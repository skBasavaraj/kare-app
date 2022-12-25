import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../appConstants.dart';
import '../../main.dart';
import '../../network/apiService.dart';
import '../../utils/about.dart';
import '../../utils/appCommon.dart';
import '../../utils/appSetings.dart';
import '../../utils/appwigets.dart';
import '../../utils/changePassword.dart';
import '../../utils/color_use.dart';

class SettingFragment extends StatefulWidget {
  @override
  _SettingFragmentState createState() => _SettingFragmentState();
}

class _SettingFragmentState extends State<SettingFragment> with SingleTickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setStatusBarColor(  scaffoldBgColor);
    tabController = new TabController(initialIndex: 0, length: 3, vsync: this);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
     return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Scaffold(
          body: Observer(
            builder: (_) => SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 30),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            32.height,
                            Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  height: 90,
                                  width: 90,
                                  padding: EdgeInsets.all(16),
                                  decoration: boxDecorationWithRoundedCorners(
                                    backgroundColor: profileBgColor,
                                    boxShape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.person_outline_rounded),
                                ),
                                Positioned(
                                  bottom: -8,
                                  left: 0,
                                  right: -60,
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: boxDecorationWithRoundedCorners(
                                      backgroundColor: appPrimaryColor,
                                      boxShape: BoxShape.circle,
                                      border: Border.all(color: white, width: 3),
                                    ),
                                    child: Image.asset("images/icons/edit.png", height: 20, width: 20, color: Colors.white),
                                  ).onTap(
                                        () {
                                       //   EditProfileScreen().launch(context);

                                        },
                                  ),
                                ),
                              ],
                            ),
                            24.height,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Dr.", style: boldTextStyle(size: 24)) ,
                                Text(
                                  'First Name',
                                  style: boldTextStyle(size: 20),
                                ),
                                Text(
                                  'Last Name',
                                  style: boldTextStyle(size: 20),
                                ),
                              ],
                            ),
                            28.height,
                          /*  if (isDoctor() || isReceptionist() && appStore.userEnableGoogleCal == ON && isProEnabled())
                              Container(
                                padding: EdgeInsets.all(16),
                                width: 260,
                                alignment: Alignment.center,
                                decoration: boxDecorationWithRoundedCorners(
                                  borderRadius: BorderRadius.all(Radius.circular(defaultRadius)),
                                  backgroundColor: context.cardColor,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset("images/icons/google_calendar.png", height: 32, width: 32, fit: BoxFit.cover),
                                    16.width,
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          appStore.userDoctorGoogleCal == ON ? '${languageTranslate('lblConnectedWith')} ${appStore.googleEmail}' : "${languageTranslate('lblConnectWithGoogle')}",
                                          style: secondaryTextStyle(color: secondaryTxtColor),
                                          textAlign: TextAlign.center,
                                        ),
                                        8.height,
                                        Text(
                                          "${languageTranslate("lblGoogleCalendarConfiguration")}",
                                          style: boldTextStyle(size: 16),
                                        ),
                                      ],
                                    ).expand(),
                                  ],
                                ),
                              ).onTap(() async
                              {
                                if (appStore.userDoctorGoogleCal != ON) {
                                  await authService.signInWithGoogle().then((user) async {
                                    if (user != null) {
                                      appStore.setLoading(true);

                                      Map<String, dynamic> request = {
                                        'code': await user.getIdToken().then((value) => value),
                                      };

                                      await connectGoogleCalendar(request: request).then((value) async {
                                        ResponseModel data = value;

                                        appStore.setUserDoctorGoogleCal(ON);

                                        appStore.setGoogleUsername(user.displayName.validate(), initiliaze: true);
                                        appStore.setGoogleEmail(user.email.validate(), initiliaze: true);
                                        appStore.setGooglePhotoURL(user.photoURL.validate(), initiliaze: true);

                                        toast(data.message);
                                        appStore.setLoading(false);
                                        setState(() {});
                                      }).catchError((e) {
                                        successToast(e.toString());
                                        appStore.setLoading(false);
                                      });
                                    }
                                  }).catchError((e) {
                                    appStore.setLoading(false);
                                    toast(e.toString());
                                  });
                                } else {
                                  appStore.setLoading(true);
                                  showConfirmDialogCustom(
                                    context,
                                    onAccept: (c) {
                                      disconnectGoogleCalendar().then((value) {
                                        appStore.setUserDoctorGoogleCal(OFF);

                                        appStore.setGoogleUsername("", initiliaze: true);
                                        appStore.setGoogleEmail("", initiliaze: true);
                                        appStore.setGooglePhotoURL("", initiliaze: true);
                                        appStore.setLoading(false);
                                        toast(value.message.validate());
                                      }).catchError((e) {
                                        appStore.setLoading(false);
                                        errorToast(e.toString());
                                      });
                                    },
                                    title:  'Are You Sure You Want To Disconnect',
                                    dialogType: DialogType.CONFIRMATION,
                                    positiveText:  'Yes',
                                  );
                                }
                              }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
                       */   ],
                        ),
                      ),
                      42.height,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TabBar(
                            controller: tabController,
                            indicatorSize: TabBarIndicatorSize.tab,
                            labelColor: Colors.white,
                            isScrollable: true,
                            unselectedLabelColor:  secondaryTxtColor,
                            indicator: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(4),
                                  topLeft: Radius.circular(4),
                                  bottomLeft: Radius.circular(4),
                                  bottomRight: Radius.circular(4),
                                ),
                              ),
                              color: tabBgColor,
                            ),
                            tabs: [
                              Tab(icon: Text( "General Setting", textAlign: TextAlign.center).paddingSymmetric(horizontal: 10)),
                              Tab(icon: Text( "App Settings", textAlign: TextAlign.center).paddingSymmetric(horizontal: 10)),
                              Tab(icon: Text( "Other", textAlign: TextAlign.center).paddingSymmetric(horizontal: 10)),
                            ],
                          ),
                          SingleChildScrollView(
                            physics: NeverScrollableScrollPhysics(),
                            child: Container(
                              height: 600,
                              margin: EdgeInsets.only(top: 32),
                              child: TabBarView(
                                controller: tabController,
                                children: [
                                 /* Wrap(
                                    alignment: WrapAlignment.start,
                                    spacing: 16,
                                    runSpacing: 16,
                                    children: [
                                      if (isDoctor() || isReceptionist())
                                        AppSettingItemWidget(
                                          name: 'lblServices',
                                          image: "images/icons/services.png",
                                          widget: ServiceListScreen(),
                                          subTitle: 'lblClinicServices',
                                        ),
                                      if (isDoctor() || isReceptionist())
                                        AppSettingItemWidget(
                                          name: 'lblHoliday',
                                          image: "images/icons/holiday.png",
                                          widget: HolidayScreen(),
                                          subTitle: 'lblClinicHoliday',
                                        ),
                                      if (isDoctor() || isReceptionist())
                                        AppSettingItemWidget(
                                          name: 'lblSessions',
                                          image: "images/icons/calendar.png",
                                          widget: DoctorSessionListScreen(),
                                          subTitle: 'lblClinicSessions',
                                        ),
                                      if (isDoctor() && (appStore.userTelemedOn.validate() || appStore.userMeetService.validate()))
                                        AppSettingItemWidget(
                                          name: 'lblTelemed',
                                          icon: Image.asset("images/icons/telemed.png", height: 30, width: 30, color: appStore.isDarkModeOn ? Colors.white : appSecondaryColor),
                                          widget: TelemedScreen(),
                                          subTitle: 'lblVideoConsulting',
                                        ),
                                      if (isPatient() || isReceptionist())
                                        AppSettingItemWidget(
                                          name: 'lblEncounters',
                                          image: "images/icons/services.png",
                                          widget: PatientEncounterScreen(),
                                          subTitle: 'lblYourEncounters',
                                        ),
                                    ],
                                  ),*/
                                  Wrap(
                                    spacing: 16,
                                    runSpacing: 16,
                                    children: [

                                      AppSettingItemWidget(
                                        name: 'lblChangePassword',
                                        image: "images/icons/unlock.png",
                                        widget: ChangePasswordScreen(),
                                      ),

                                    ],
                                  ),
                                  Wrap(
                                    spacing: 16,
                                    runSpacing: 16,
                                    children: [
                                      AppSettingItemWidget(
                                          name: 'lblTermsAndCondition',
                                          image: "images/icons/termsandconition.png",
                                          subTitle: 'lblClinicTAndC',
                                          onTap: () {
                                            launch(termsAndConditionURL);
                                          }),
                                      AppSettingItemWidget(
                                        name: 'lblAboutUs',
                                        image: "images/icons/aboutus.png",
                                        widget: AboutUsScreen(),
                                        subTitle: 'lblAboutKiviCare',
                                      ),
                                      AppSettingItemWidget(
                                        name: 'lblRateUs',
                                        image: "images/icons/rateUs.png",
                                        subTitle: 'lblYourReviewCounts',
                                        onTap: () {
                                          launch(playStoreBaseURL + "com.iqonic.kivicare");
                                        },
                                      ),
                                      AppSettingItemWidget(
                                        name: 'lblAppVersion',
                                        image: "images/icons/app_version.png",
                                        // subTitle: '${getStringAsync(VERSION)}',
                                        subTitle: '${packageInfo.versionName}',
                                        isNotTranslate: true,
                                      ),
                                      AppSettingItemWidget(
                                          name: 'lblHelpAndSupport',
                                          icon: Image.asset(
                                            "images/icons/helpandsupport.png",
                                            height: 30,
                                            width: 30,
                                            color:   appSecondaryColor,
                                          ),
                                          subTitle: 'lblSubmitYourQueriesHere',
                                          onTap: () {
                                          //  launch(supportURL);
                                          }),
                                      AppSettingItemWidget(
                                          name: 'lblShareKiviCare',
                                          icon: Image.asset(
                                            "images/icons/share.png",
                                            height: 30,
                                            width: 30,
                                            color: appSecondaryColor,
                                          ),
                                          onTap: () {
                                            Share.share('Share $appName app\n\n$playStoreBaseURL${packageInfo.packageName}');
                                          }),
                                      AppSettingItemWidget(
                                        name: 'lblLogout',
                                        subTitle: 'lblThanksForVisiting',
                                        image: "images/icons/logout.png",
                                        onTap: () async {
                                          showConfirmDialogCustom(
                                            context,
                                            primaryColor: primaryColor,
                                            negativeText:  "Cancel",
                                            positiveText:  "Yes",
                                            onAccept: (c) {
                                              logout(context);
                                            },
                                            title:  "Are You Sure To Logout" + '?',
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 16),
                    ],
                  ),
                  if (isDoctor())
                    Observer(
                      builder: (context) => setLoader().withSize(width: 40, height: 40) .center(),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
