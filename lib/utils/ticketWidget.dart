import 'package:flutter/material.dart';
import 'package:ticket_widget/ticket_widget.dart';
class Ticket_Widget extends StatefulWidget {
  const Ticket_Widget({Key? key}) : super(key: key);

  @override
  State<Ticket_Widget> createState() => _Ticket_WidgetState();
}

class _Ticket_WidgetState extends State<Ticket_Widget> {
  var size,height,width;
  @override
  Widget build(BuildContext context) {
      size = MediaQuery.of(context).size;
      height = size.height;
      width = size.width;
      return Container(
      //child: TicketWidget(width: width/2 , height: height/3, child: ,

      //),
    );
  }
}
