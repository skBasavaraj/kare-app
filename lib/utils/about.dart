import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:nb_utils/nb_utils.dart';

import '../appConstants.dart';
import 'appwigets.dart';
import 'color_use.dart';

class AboutUsScreen extends StatefulWidget {
  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    // setDynamicStatusBarColor(color: appPrimaryColor);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
   // setDynamicStatusBarColor(color: scaffoldBgColor);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appAppBar(context, name:  'AboutUs'),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(appName, style: primaryTextStyle(size: 30)),
            16.height,
            Container(
              decoration: BoxDecoration(color: primaryColor, borderRadius: radius(4)),
              height: 4,
              width: 100,
            ),
            16.height,
            Text( 'Version', style: secondaryTextStyle()),
            Text('1.0', style: primaryTextStyle()),
            16.height,
            Text(
              "We want to construct success stories of brands that glow most shining in the digital space. our mission is to put an end to the boring and repetitive content that plagues online media and bring in innovative ideas, strategies, and creativity from our IT Services.",
              style:  GoogleFonts.jost(fontSize: 14),
              textAlign: TextAlign.justify,
            ),
            16.height,
            AppButton(
              color: Colors.blue,
              splashColor: Colors.grey,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('images/icons/contect.png', height: 24, color: Colors.white),
                  8.width,
                  Text( 'ContactUs', style: primaryTextStyle(color: Colors.white)),
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              onTap: () {
                //  launchUrl('mailto:$mailto');
              },
            ),
           ],
        ).paddingAll(16),
      ),
    );
  }
}
