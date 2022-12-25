import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:nb_utils/nb_utils.dart';

import '../../utils/color_use.dart';

class DashBoardCountWidget extends StatefulWidget {
  final String? title;
  final String? subTitle;
    String? count ;
  final Color? color1;

  //final Color? color2;
  final IconData? icon;

  DashBoardCountWidget({this.title, this.subTitle, this.count, this.color1, /*this.color2,*/ this.icon});

  @override
  State<DashBoardCountWidget> createState() => _DashBoardCountWidgetState();
}

class _DashBoardCountWidgetState extends State<DashBoardCountWidget> {
  @override
  Widget build(BuildContext context) {
    return
      Container(
        width: context.width() / 2 - 30,
        height: 120,
        alignment: Alignment.center,
        decoration: boxDecorationWithShadow(
          blurRadius: 1,
          spreadRadius: 2,
          borderRadius: radius(),
          backgroundColor: context.cardColor,
        ),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    24.height,
                    Text(widget.count.toString() , style: GoogleFonts.jost(fontSize: 20,color: Colors.black54,fontWeight: FontWeight.bold)).expand(),
                    5.height,
                    Marquee(
                      child: Text(
                        widget.title!  ,
                        style: GoogleFonts.jost(fontSize: 14, color: secondaryTxtColor),
                      ),
                    ),
                  ],
                ).expand()
              ],
            ).paddingOnly(top: 16, left: 8, right: 8, bottom: 16),
            Positioned(
              top: -28,
              child:
              Container(
                padding: EdgeInsets.all(16),
                decoration: boxDecorationWithShadow(
                  boxShape: BoxShape.circle,
                  boxShadow: null,
                  backgroundColor: widget.color1!,
                ),
                child: FaIcon(widget.icon ?? FontAwesomeIcons.userInjured, color: Colors.white,).center(),
              ),
            ),
          ],
        ),
      ) ;
  }
}
