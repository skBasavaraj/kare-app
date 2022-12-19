import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../network/apiService.dart';
import '../utils/appCommon.dart';
 class NoNetwork {
   static checkNet(   ) async {
     if (await connectivityChecker ()){

     }else{
     errorToast("Network issues");
    // exit(0);

     // NoNetwork().launch(context,pageRouteAnimation: PageRouteAnimation.Scale);
     }
   }
 }
