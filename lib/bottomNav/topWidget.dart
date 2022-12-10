import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:nb_utils/nb_utils.dart';

import '../appConstants.dart';
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Image.asset("images/icons/hi.png", width: 22, height: 22, fit: BoxFit.cover),
                              8.width,
                              Text(
                                'Hi',
                                style: primaryTextStyle(color:   secondaryTxtColor),
                              ),
                            ],
                          ),
                          8.height,
                          Text(' ${getStringAsync(U_NAME)}  ', style: boldTextStyle(size: 20)),
                         // Text(' ${getStringAsync(USER_NAME)} ${appStore.lastName.validate()}', style: boldTextStyle(size: 20)),
                        ],
                      ),
                    /*  appStore.profileImage.validate().isNotEmpty
                          ? */
                      Container(
                        decoration: boxDecorationWithShadow(
                          border: Border.all(color: white, width: 4),
                          spreadRadius: 0,
                          blurRadius: 0,
                          boxShape: BoxShape.circle,
                        ),
                        child: cachedImage(
                          'images/patientAvatars/patient3.png',
                          fit: BoxFit.cover,
                          height: 47,
                          width: 47,
                          alignment: Alignment.center,
                        ).cornerRadiusWithClipRRect(100).onTap(() {
                          //EditPatientProfileScreen().launch(context);


                        }),
                      ),
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
          ).paddingSymmetric(horizontal: 12, vertical: 8),
        ),
      ),
    );
  }
}
