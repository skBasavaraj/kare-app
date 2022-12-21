import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:nb_utils/nb_utils.dart';

import '../appConstants.dart';
import '../screens/notificsion.dart';
import '../utils/appwigets.dart';
import '../utils/color_use.dart';

class TopNameWidget extends StatelessWidget {
  const TopNameWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Container(
         decoration: boxDecorationWithShadow(
          borderRadius: radius(0),
          backgroundColor:   scaffoldBgColor,
        ),
        child: Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  2.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Wrap(
          direction: Axis.vertical,
                        children: [
                          // Image.asset("images/icons/hi.png", width: 22, height: 22, fit: BoxFit.cover),
                            Text(
                            'Good Morning',
                            style:  GoogleFonts.jost(color:    Colors.blue, fontSize: 24,fontWeight: FontWeight.bold),

                          ),
                          Text(' ${getStringAsync(USER_NAME)}  ', style: GoogleFonts.jost(fontSize: 16)),

                        ],
                      ).paddingOnly(left: 10),
                    /*  appStore.profileImage.validate().isNotEmpty
                          ? */
                      Stack(
                        children: [
                          InkWell(
                              child: Image.asset('images/notify.png',height: 30),onTap: () {
                            UserNotification().launch(context,pageRouteAnimation: PageRouteAnimation.Scale);
                              },) ,
                          Positioned(child:Text("",))
                        ],
                       ).paddingOnly(right: 5)
                      /*Container(
                        decoration: boxDecorationWithShadow(
                          border: Border.all(color: white, width: 4),
                          spreadRadius: 0,
                          blurRadius: 0,
                          boxShape: BoxShape.circle,
                        ),
                        child: cachedImage(
                          getStringAsync(PROFILE_IMAGE),
                       //  'images/patientAvatars/patient3.png',
                          fit: BoxFit.cover,
                          height: 47,
                          width: 47,
                          alignment: Alignment.center,
                        ).cornerRadiusWithClipRRect(100).onTap(() {
                          //EditPatientProfileScreen().launch(context);


                        }),
                      ),*/
                         // :
                   /*   Container(
                        padding: EdgeInsets.all(14),
                        decoration: boxDecorationWithShadow(
                          border: Border.all(color: white, width: 4),
                          backgroundColor: primaryColor,
                          spreadRadius: 0,
                          blurRadius: 0,
                          boxShape: BoxShape.circle,
                        ),
                        child: (getStringAsync(FIRST_NAME).validate().isNotEmpty || getStringAsync(LAST_NAME).validate().isNotEmpty)
                            ? Text(
                          '${getStringAsync(FIRST_NAME).validate()[0]}${getStringAsync(LAST_NAME).validate()[0]}'.toUpperCase(),
                          style: primaryTextStyle(color: textPrimaryWhiteColor, size: 16),
                        ).center()
                            : Text(
                           getStringAsync(USER_NAME),
                          style: primaryTextStyle(color: textPrimaryWhiteColor, size: 16),
                        ).center(),
                      ).cornerRadiusWithClipRRect(defaultRadius).onTap(
                            () {
                            *//*  EditPatientProfileScreen().launch(context);

                              if (isDoctor()) {
                            EditProfileScreen().launch(context);
                          } else {
                            EditPatientProfileScreen().launch(context);
                          }*//*
                        },
                      ),*/
                    ],
                  ),
                ],
              ).expand(),
            ],
          ).paddingSymmetric(horizontal: 12, vertical: 5),
        ),
      ),
    );
  }
}
