import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:nb_utils/nb_utils.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../appConstants.dart';
import '../main.dart';
import '../network/apiService.dart';
import '../screens/editScreen.dart';
import '../utils/about.dart';
import '../utils/appSetings.dart';
import '../utils/appwigets.dart';
import '../utils/changePassword.dart';
import '../utils/color_use.dart';

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
          backgroundColor: scaffoldBgColor,
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
                                profileImage(),
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
                                      EditPatientProfileScreen().launch(context);
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
                                Text(
                                  '${getStringAsync(USER_NAME)}',
                                  style: boldTextStyle(size: 20),
                                ),

                              ],
                            ),
                   ],
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
                              color: primaryColor,
                            ),
                            tabs: [
                              Tab(icon: Text('General Setting', textAlign: TextAlign.center).paddingSymmetric(horizontal: 10)),
                              Tab(icon: Text( 'App Settings', textAlign: TextAlign.center).paddingSymmetric(horizontal: 10)),
                              Tab(icon: Text( 'Other', textAlign: TextAlign.center).paddingSymmetric(horizontal: 10)),
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
                                  Wrap(
                                    alignment: WrapAlignment.start,
                                    spacing: 16,
                                    runSpacing: 16,
                                    children: [
                                      AppSettingItemWidget(
                                        name: 'Logout',
                                        subTitle: 'Thanks For Visiting',
                                        image: "images/icons/logout.png",
                                        onTap: () async {
                                          showConfirmDialogCustom(
                                            context,
                                            primaryColor: primaryColor,
                                            negativeText:  'Cancel',
                                            positiveText:  'Yes',
                                            onAccept: (c) {
                                              logout(context);
                                            },
                                            title:'AreYouSureToLogout' + '?',
                                          );
                                        },
                                      )

                                    ],
                                  ),
                                  Wrap(
                                    spacing: 16,
                                    runSpacing: 16,
                                    children: [

                                      AppSettingItemWidget(
                                        name: 'Change Password',
                                        subTitle: '',
                                        image: "images/icons/unlock.png",
                                      widget: ChangePasswordScreen()

                                      ),

                                    ],
                                  ),
                                  Wrap(
                                    spacing: 16,
                                    runSpacing: 16,
                                    children: [
                                      AppSettingItemWidget(
                                          name: 'Terms And Condition',
                                          image: "images/icons/termsandconition.png",
                                          subTitle:  "",
                                          onTap: () {
                                            launch(termsAndConditionURL);
                                          }),
                                      AppSettingItemWidget(
                                        name: 'About Us',
                                        image: "images/icons/aboutus.png",
                                        widget: AboutUsScreen(),
                                        subTitle: 'About Zat Care',
                                      ),
                                      AppSettingItemWidget(
                                        name: 'Rate Us',
                                        image: "images/icons/rateUs.png",
                                        subTitle: 'Your Review Counts',
                                        onTap: () {
                                          launch(termsAndConditionURL);
                                        },
                                      ),
                                      AppSettingItemWidget(
                                        name: 'App Version',
                                        image: "images/icons/app_version.png",
                                        // subTitle: '${getStringAsync(VERSION)}',
                                        subTitle: '0.5 Beta',
                                        isNotTranslate: true,
                                      ),
                                      AppSettingItemWidget(
                                          name: 'Help And Support',
                                          icon: Image.asset(
                                            "images/icons/helpandsupport.png",
                                            height: 30,
                                            width: 30,
                                            color:   appSecondaryColor,
                                          ),
                                          subTitle: 'Submit Your Queries Here',
                                          onTap: () {
                                            launch(termsAndConditionURL);
                                          }),
                                      /*AppSettingItemWidget(
                                          name: ' Share Zatcare',
                                          icon: Image.asset(
                                            "images/icons/share.png",
                                            height: 30,
                                            width: 30,
                                            color:   appSecondaryColor,
                                          ),
                                          onTap: () {
                                            //Share.share('Share $appName app\n\n$playStoreBaseURL${packageInfo.packageName}');
                                          }),
*/
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
                 /* if (isDoctor())*/
                   /* Observer(
                      builder: (context) => setLoader().withSize(width: 40, height: 40).visible(false).center(),
                    )*/
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

 Widget profileImage() {

    return cachedImage(
       "https://admin.verzat.com/assets/images/uploads/"+getStringAsync(USER_TYPE)+"s/"+getStringAsync(PROFILE_IMAGE),
      height: 90,
      width: 90,
      fit: BoxFit.cover,
      alignment: Alignment.center,
    ).cornerRadiusWithClipRRect(180);

  }
  /* Container(
    height: 90,
    width: 90,
    padding: EdgeInsets.all(16),
    decoration: boxDecorationWithRoundedCorners(
    backgroundColor:   profileBgColor,
    boxShape: BoxShape.circle,
    ),
    child: Icon(Icons.person_outline_rounded),
    )*/
}
