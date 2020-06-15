import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SendMessage extends StatefulWidget {

  final String name;
  final String code;
  const SendMessage(this.name,this.code);

  @override
  _SendMessageState createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF033140),
        title: Text(widget.name),
      ),
      backgroundColor: Color(0xFFD9E6EB),
      body: Container(
        color: Color(0xFFD9E6EB),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.height/12, 
                                          MediaQuery.of(context).size.height/15, 
                                          MediaQuery.of(context).size.height/12, 
                                          MediaQuery.of(context).size.height/100),
              decoration: new BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 5.0,  
                  style: BorderStyle.solid,
                ),
                color: Colors.white,
                borderRadius: new BorderRadius.all(Radius.circular(50.0)),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height:MediaQuery.of(context).size.height/25),
                    Text(widget.code + " - " + widget.name),
                    Text("Sınıfına Mesaj Yolla"),
                    SizedBox(height:MediaQuery.of(context).size.height/50),
                    TextField(
                      maxLines: 10,
                      minLines: 1,
                      decoration: new InputDecoration(
                        hintText: '  Mesajınızı Yazınız',
                        contentPadding: new EdgeInsets.symmetric(vertical: 125.0, horizontal: 10.0),
                        suffixIcon: Icon(
                          Icons.mail_outline,
                          color: Color(0xFF033140),
                        ),
                      ),
                      cursorColor: Color(0xFF033140),
                    ),
                    SizedBox(height:MediaQuery.of(context).size.height/10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          color: Color(0xFF033140),
          height: MediaQuery.of(context).size.height/15,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton(
                color: Color(0xFF033140),
                child: Container(
                  width: MediaQuery.of(context).size.width/2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      SizedBox(width:MediaQuery.of(context).size.height/40),
                      Text(
                        'Sınıfa Mesaj Gönder',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                onPressed: () async {
                  
                }
              ),
              
            ],
          ),
        )
      ),
    );
  }
}