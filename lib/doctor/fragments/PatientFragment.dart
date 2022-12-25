import 'package:flutter/cupertino.dart';

class PatientFragment extends StatefulWidget {
  const PatientFragment({Key? key}) : super(key: key);

  @override
  State<PatientFragment> createState() => _PatientFragmentState();
}

class _PatientFragmentState extends State<PatientFragment> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("PatientFragment"),
      ),
    );
  }
}
