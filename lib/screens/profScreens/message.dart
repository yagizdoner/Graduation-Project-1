import 'package:cse465ers/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Message extends StatefulWidget {
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  
  bool loading = false;



  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      body: Text("\n\n\nMESAJ\n\n\n EKRANI")
    );
  }
}