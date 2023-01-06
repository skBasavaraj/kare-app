import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:nb_utils/nb_utils.dart';

import 'color_use.dart';

class AppSettingItemWidget extends StatelessWidget {
  final String? name;
  final String? subTitle;
  final Widget? wSubTitle;
  final Widget? icon;
  final String? image;
  final Function? onTap;
  final Widget? widget;
  final bool isNotTranslate;

  AppSettingItemWidget({this.name, this.subTitle, this.wSubTitle, this.icon, this.image, this.onTap, this.widget, this.isNotTranslate = false});

  @override
  Widget build(BuildContext context) {
    return

          GestureDetector(
        onTap: widget == null
            ? onTap as void Function()?
            : () {
          widget.launch(context);
        },
        child: Container(
          width: context.width() / 2 - 24,
          padding: EdgeInsets.all(16),
          decoration: boxDecorationWithShadow(
            borderRadius: BorderRadius.circular(defaultRadius),
            backgroundColor: Theme.of(context).cardColor,
            blurRadius: 0,
            spreadRadius: 0,
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "$image",
                    height: 35,
                    width: 30,
                    color:  appSecondaryColor,
                  ).visible(
                    image != null,
                    defaultWidget: icon,
                  ),
                  16.height,
                  Text( name!, style:GoogleFonts.jost(fontSize: 16)),
                  8.height,
                  Text(
                    isNotTranslate != false ? subTitle.validate() :  subTitle!,
                    style: secondaryTextStyle(size: 12, color: secondaryTxtColor),
                  ).visible(
                    subTitle != null,
                    defaultWidget: wSubTitle,
                  ),
                ],
              ).expand(),
            ],
          ),
        ),
      );

  }
}
