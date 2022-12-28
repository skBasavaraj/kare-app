
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../appConstants.dart';
import '../../network/apiService.dart';
import '../../network/doctorApiService.dart';
import '../../utils/appCommon.dart';
import '../../utils/color_use.dart';

class DoctorChatScreen extends StatefulWidget {
  getProfileList? profileList;
  DoctorChatScreen(this.profileList);


  @override
  State<DoctorChatScreen> createState() => DoctorChatScreenState();
}

class DoctorChatScreenState extends State<DoctorChatScreen> {
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
    var name = widget.profileList?.name;
    var concat = name!;
    doctorName = concat;
    receiverId = widget.profileList?.id;
    print("UID"+receiverId! );

    userToken = getStringAsync(USER_TOKEN);
    // getTimes();
    time = Timer.periodic(Duration(seconds: 1), (Timer t) =>   setState(() {

    }));
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
            child: Column(
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.80,
                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade400,
                    borderRadius:   BorderRadius.only(topRight: Radius.elliptical(0, 100), bottomRight: Radius.circular(5),
                      bottomLeft:
                      Radius.circular(5),
                      topLeft: Radius.circular(5),),

                  ),
                  child:Text(
                    message.message!,
                    style: GoogleFonts.jost(
                      color: Colors.white,


                    ),
                  ),

                ),

              ],
            ),
          ),
          Container(
            alignment: Alignment.topRight,

            child:  Text(message.messageTime!,style: GoogleFonts.jost(fontSize: 10,color:Colors.grey),),
          ),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Container(

            alignment: Alignment.topLeft,
            child: Column(
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.80,
                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:   BorderRadius.only(topRight: Radius.elliptical(0, 100), bottomRight: Radius.circular(5),
                      bottomLeft:
                      Radius.circular(5),
                      topLeft: Radius.circular(5),),

                  ),
                  child:Text(
                    message.message!,
                    style: GoogleFonts.jost(
                      color: Colors.black54,


                    ),
                  ),

                ),

              ],
            ),
          ),
          Container(
            alignment: Alignment.topLeft,

            child:  Text(message.messageTime!,style: GoogleFonts.jost(fontSize: 10,color:Colors.grey),),
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
        height: 60,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            /*    IconButton(
                 icon: Icon(Icons.photo),
                 iconSize: 25,
                 color: Theme.of(context).primaryColor,
                 onPressed: () {},
               ),*/
            Expanded(
              child: AppTextField(
                controller: msgText,
                decoration:  textInputStyle(context:context,text:"send a message..",isMandatory:true ,),
                textCapitalization: TextCapitalization.sentences, textFieldType:TextFieldType.MULTILINE,
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
                sendMessage(msgText.text ,receiverId,currentUserId);
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

  void sendMessage(String msg,  String? receiverId,String? currentUserId) async{
    setState(() {
      msgText.clear();
    });
    var info = await sendMsg(msg,currentUserId!,receiverId!);
    if(info?.msg == "000"){
      successToast("send");
    }else{
      errorToast("error to send message");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar:
      AppBar(

        brightness: Brightness.light,

        title:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("$doctorName",style:  GoogleFonts.jost(color: Colors.white,fontSize: 20)),
           /* Visibility(
                visible: chabox,
                child: Text("${_timerText}",style:  GoogleFonts.jost(color: Colors.white,fontSize: 20))),*/
          ],
        ),
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

    var minutes1 =   formattedMinutesLeft.toString();
    var  secnd = formattedSecondsLeft.toString();
    final fastestMarathon = Duration(minutes:   minutes1.toInt(), seconds: secnd.toInt());
    print(';;${fastestMarathon.inSeconds}${"%%"}${minutes1}');
    updateTime(currentUserId!, receiverId!, fastestMarathon.inSeconds.toString()   );
    print(';;${total.toString()}');
    if(minutes1=="00"){
      timer?.cancel();
      print("decline");
      updateTime(currentUserId!, receiverId!,  "done"   );
    }
    timer!.cancel();
    super.dispose();
  }
  Future<void> main() async {
    // Check internet connection with singleton (no custom values allowed)
    await execute(InternetConnectionChecker());

    // Create customized instance which can be registered via dependency injection
    final InternetConnectionChecker customInstance =
    InternetConnectionChecker.createInstance(
      checkTimeout: const Duration(seconds: 1),
      checkInterval: const Duration(seconds: 1),
    );

    // Check internet connection with created instance
    await execute(customInstance);
  }

  Future<void> execute(
      InternetConnectionChecker internetConnectionChecker,
      ) async {
    // Simple check to see if we have Internet
    // ignore: avoid_print
    print('''The statement 'this machine is connected to the Internet' is: ''');
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    // ignore: avoid_print
    print(
      isConnected.toString(),
    );
    // returns a bool

    // We can also get an enum instead of a bool
    // ignore: avoid_print
    print(
      'Current status: ${await InternetConnectionChecker().connectionStatus}',
    );
    // Prints either InternetConnectionStatus.connected
    // or InternetConnectionStatus.disconnected

    // actively listen for status updates
    final StreamSubscription<InternetConnectionStatus> listener =
    InternetConnectionChecker().onStatusChange.listen(
          (InternetConnectionStatus status) {
        switch (status) {
          case InternetConnectionStatus.connected:
          // ignore: avoid_print
            print('Data connection is available.');
            break;
          case InternetConnectionStatus.disconnected:
          // ignore: avoid_print
            print('You are disconnected from the internet.');
            break;
        }
      },
    );

    // close listener after 30 seconds, so the program doesn't run forever
    await Future<void>.delayed(const Duration(seconds: 30));
    await listener.cancel();
  }
}
