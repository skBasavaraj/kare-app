import 'package:flutter/cupertino.dart';

class AppointmentFragment extends StatefulWidget {
  const AppointmentFragment({Key? key}) : super(key: key);

  @override
  State<AppointmentFragment> createState() => _AppointmentFragmentState();
}

class _AppointmentFragmentState extends State<AppointmentFragment> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Center(
      child: Text("hi second fragemt"),
    ),
    );
  }
}
