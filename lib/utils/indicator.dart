import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:zatcare/utils/color_use.dart';

class Indictor extends StatelessWidget {
  final bool isActive;
  const  Indictor(  {  required this.isActive})  ;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: AnimatedContainer(
        duration: Duration( milliseconds: 300),
        width: isActive ? 8:5,
        height: 5,
        decoration: BoxDecoration(
          color:isActive ? Colors.white70 : Colors.grey,
          borderRadius: BorderRadius.circular(10),

        ),
      ),
    );

  }
}