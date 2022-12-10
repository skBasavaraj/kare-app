import 'dart:async';

import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';

import '../appConstants.dart';
import '../network/apiService.dart';
import '../utils/appCommon.dart';
 import 'dart:developer' as logDev;

class ChatScreen extends StatefulWidget {
   Doctors? doctors;
   ChatScreen(this.doctors);


  @override
  State<ChatScreen> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
    int maxSeconds =0;
  int _currentSecond = 0;
  var minute=0;
  num total =0;
  var sixty =60;
  bool chabox =true;

   var formattedSecondsLeft;
    var formattedMinutesLeft;
  Timer? timer;
  Timer? time;
  int? prevUserId;
  bool? isMe;
  String? currentUserId;
  String? userToken;
  String? doctorName;
  String? receiverId;
  List<Msg>? messages;
  String? sMsg;
  String? rMsg;
  var getSec = false;

  TextEditingController msgText = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  @override
  void initState() {
    super.initState();
    //
   // print("eee"+getStringAsync(USER_TIME));



    currentUserId = getStringAsync(USER_ID);
    print("UID"+currentUserId!);
    var name = widget.doctors?.name;
    var lName = widget.doctors?.lastName;
    var concat = name!+" "+lName!;
    doctorName = "Dr."+concat;
    receiverId = widget.doctors?.id;
    userToken = getStringAsync(USER_TOKEN);
    getTimes();
    _startTimer();

    time = Timer.periodic(Duration(seconds: 5), (Timer t) =>   setState(() {

    }));
    // getMsg =   getMessages(currentUserId,receiverId);

  }
  String get _timerText {
    final secondsPerMinute = 60;
    final secondsLeft = maxSeconds! - _currentSecond;

    final formattedMinutesLeft =
    (secondsLeft ~/ secondsPerMinute).toString().padLeft(2, '0');
    formattedSecondsLeft =
        (secondsLeft % secondsPerMinute).toString().padLeft(2, '0');


    print('$formattedMinutesLeft : $formattedSecondsLeft');
    return '$formattedMinutesLeft : $formattedSecondsLeft';
  }

  void _startTimer() {
    var times ;
    final duration = Duration(seconds: 1);
    timer = Timer.periodic(duration, (Timer timer) {
      setState(() {
        _currentSecond = timer.tick;
        times = formattedSecondsLeft;
        if (timer.tick >= maxSeconds!) timer.cancel();
        if(_timerText =="00 : 00"){
          chabox = false;
        }
      });
    });
  }
 getTimes() async{
     var get = await getTime( currentUserId!, receiverId!);
 if(get!.error =="000") {

   maxSeconds = get.doneTime.toInt();
   print("getTime");
 }else{
   print("getTime fail");

 }
 }




   _chatBubble(Msg message) {
    if(message.senderId == currentUserId){
       isMe = true;

    }else{
      isMe = false;
     }



    if (isMe!) {
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topRight,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80,
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius:   BorderRadius.all(Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(
                message.message!,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            child: null,
          ),
        ],
      );
    } else { 
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80,
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(
                message.message!,
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
          ),

        ],
      );
    }
  }

  _sendMessageArea( ) {

       return Visibility(
         visible: chabox,
         child: Container(
           padding: EdgeInsets.symmetric(horizontal: 8),
           height: 70,
           color: Colors.white,
           child: Row(
             children: <Widget>[
               IconButton(
                 icon: Icon(Icons.photo),
                 iconSize: 25,
                 color: Theme.of(context).primaryColor,
                 onPressed: () {},
               ),
               Expanded(
                 child: TextField(
                   controller: msgText,
                   decoration: InputDecoration.collapsed(
                     hintText: 'Send a message..',
                   ),
                   textCapitalization: TextCapitalization.sentences,
                 ),
               ),
               IconButton(
                 icon: Icon(Icons.send),
                 iconSize: 25,
                 color: Theme.of(context).primaryColor,
                 onPressed: () {
                   FocusScopeNode currentFocus = FocusScope.of(context);
                   if (!currentFocus.hasPrimaryFocus) {
                     currentFocus.unfocus();
                   }
                   sendMessage(msgText.text ,userToken,receiverId,currentUserId);
                   _scrollController.animateTo(
                     _scrollController.position.maxScrollExtent,
                     curve: Curves.easeOut,
                     duration: const Duration(milliseconds: 300),
                   );
                 },
               ),
             ],
           ),
         ),
       );


  }

  void sendMessage(String msg, String? userToken, String? receiverId,String? currentUserId) async{
    setState(() {
      msgText.clear();
    });
    var info = await sendMsg(msg, userToken!,currentUserId!,receiverId!);
     if(info?.msg == "000"){
        successToast("send");
     }else{
       errorToast("error to send message");
     }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,

        title:  Text("$doctorName  ${_timerText}",style: TextStyle(color: Colors.white,fontSize: 20)),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () {

              Navigator.pop(context);
            }),
      ),
      body: Column(
        children: <Widget>[
          Expanded(

            child:FutureBuilder<List<Msg>> (
            future:  getMessages(currentUserId,receiverId),

              builder: (context, snapshot) {
                if (snapshot.data == null) {
                 // logDev.log(snapshot.data,name:"123");
                  print(snapshot.data);
                  return Lottie.network('https://assets7.lottiefiles.com/private_files/lf30_96yLMX.json');
                }
                else
                {
                  messages = snapshot.data;
               return   ListView.builder(
                     shrinkWrap: true,
                     controller: _scrollController,
                     padding: EdgeInsets.all(20),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                       return _chatBubble(messages![index]);
                    },
                  );

                 }
              },
            ),
          ),

          _sendMessageArea( ),

        ],
      ),
    );
  }



  @override
  void dispose() {
    /**
     *  here you can set time
     */
    //setValue(USER_TIME,  );
     //getSec =true;

           print("666"+minute.toString());
           var minutes1 = formattedMinutesLeft.toInt();
           var sec = formattedSecondsLeft.toInt();
           var fastestMarathon = Duration(hours: 0, minutes:   minutes1, seconds: sec);

           // total = minute+formattedSecondsLeft;

      updateTime(currentUserId!, receiverId!,  fastestMarathon.inSeconds.toString());
      print(';;');
     timer!.cancel();
         print(';;2');

         super.dispose();
  }

}
