import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         Expanded(
          flex: 10,
          child:
          FutureBuilder<List<getProfileList>>(
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
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Material(
        shadowColor: Colors.grey,
        elevation: 1,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            DoctorChatScreen(list).launch(context,pageRouteAnimation: PageRouteAnimation.Scale);
          },
          splashColor: Colors.blue.shade100,
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            5.width,
            CircleAvatar(
              minRadius: 25,
              backgroundImage: NetworkImage(
             //     'https://admin.verzat.com/assets/images/uploads/users/${list.file}'),
                  'https://admin.verzat.com/assets/images/user.png'),
            ).paddingAll(2),
            10.width,
            MarqueeWidget(
              child: Text(
                list.name!,
                style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w400),
                softWrap: false,
              ),
            ).paddingTop(10)
          ]),
        ),
      ),
    );
  }
}
