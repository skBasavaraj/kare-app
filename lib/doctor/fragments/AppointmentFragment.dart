import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zatcare/appConstants.dart';
import 'package:zatcare/network/apiService.dart';
import 'package:zatcare/utils/color_use.dart';

import '../../network/doctorApiService.dart';
import '../../screens/ChatDetails.dart';
import '../../utils/appwigets.dart';
import '../../utils/marqeeWidget.dart';
import '../screens/doctorChatScreen.dart';

class AppointmentFragment extends StatefulWidget {
  const AppointmentFragment({Key? key}) : super(key: key);

  @override
  State<AppointmentFragment> createState() => _AppointmentFragmentState();
}

class _AppointmentFragmentState extends State<AppointmentFragment> {
  List<Msg>? messages;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 10,
          child: FutureBuilder<List<getProfileList>>(
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<getProfileList> list = snapshot!.data!;

                return ListView.builder(
                  itemBuilder: (context, index) {
                    return profiles(list[index]);
                  },
                  itemCount: snapshot.data!.length,
                );
              }
              return snapWidgetHelper(snapshot,
                  errorWidget: noAppointmentDataWidget(
                      text: "No Data Found", isInternet: true));
            },
            future: getPatientProfileList(),
          ).paddingTop(10),
        ),
      ],
    );
  }

  Widget profiles(getProfileList list) {
    return Padding(
      padding: EdgeInsets.symmetric(),
      child: Material(
        color: Colors.white,
        shadowColor: Colors.grey,
        child: InkWell(
          onTap: () {
            DoctorChatScreen(list)
                .launch(context, pageRouteAnimation: PageRouteAnimation.Scale);
          },
          splashColor: Colors.blue.shade100,
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            5.width,
            Expanded(
              flex: 1,
              child: CircleAvatar(
                minRadius: 25,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(

                    //     'https://admin.verzat.com/assets/images/uploads/users/${list.file}'),
                    'https://admin.verzat.com/assets/images/user.png'),
              ).paddingAll(2),
            ),
            10.width,
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MarqueeWidget(
                    child: Text(
                      list.name!,
                      style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                      softWrap: false,
                    ),
                  ).paddingTop(5),
                  5.height,
                  FutureBuilder<List<Msg>>(
                    future: getMessages(getStringAsync(USER_ID), list.id),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return snapWidgetHelper(snapshot,
                            errorWidget: noAppointmentDataWidget(
                                text: "No Data Found", isInternet: true));
                      } else {
                        messages = snapshot.data;
                        return Text(
                          messages!.last.message!,
                          style: GoogleFonts.jost(
                              fontSize: 14, color: Colors.black54),
                        ).paddingBottom(0);
                      }
                    },
                  )

                ],
              ),
            ),
            FutureBuilder<List<Msg>>(
              future: getMessages(getStringAsync(USER_ID), list.id),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return snapWidgetHelper(snapshot,
                      errorWidget: noAppointmentDataWidget(
                          text: "No Data Found", isInternet: true));
                } else {
                  messages = snapshot.data;
                  return Text(
                    messages!.last.messageTime!,
                    style: GoogleFonts.jost(
                        fontSize: 12, color: Colors.black54),
                  ).paddingBottom(0);
                }
              },
            ).paddingOnly(top:5,right: 10)

          ]).paddingOnly(left: 20, top: 5, bottom: 5),
        ),
      ),
    );
  }
}
