import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SendMessage extends StatefulWidget {

  final String name;
  final String code;
  final String uni;
  final List stuNames;
  final List stuSurnames;
  final List stuCodes;
  final String akaEmail;
  const SendMessage(this.name,this.code, this.uni,this.stuNames,this.stuSurnames,this.stuCodes,this.akaEmail);

  @override
  _SendMessageState createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {

  final _formKey = GlobalKey<FormState>();
  final databaseReference = Firestore.instance;
  String message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF033140),
        title: Text('Mesaj Gönder'),
      ),
      backgroundColor: Color(0xFFD9E6EB),
      body: SingleChildScrollView(
        child: Container(
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
                      Text(
                        widget.code + " - " + widget.name+"\n\nSınıfına Mesaj Yolla",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Color(0xFF033140),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height:MediaQuery.of(context).size.height/25),
                      TextFormField(
                        maxLines: 100,
                        minLines: 1,
                        decoration: new InputDecoration(
                          hintText: '  Mesajınızı Yazınız',
                          suffixIcon: Icon(
                            Icons.mail_outline,
                            color: Color(0xFF033140),
                          ),
                        ),
                        cursorColor: Color(0xFF033140),
                        onChanged: (val) {
                          setState(() => message = val);
                        },
                      ),
                      SizedBox(height:MediaQuery.of(context).size.height/10),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
                  if(message.length > 0){
                    sendMess(message);
                    showAlertDialog(context, "Mesaj İletildi.");
                  }
                  else{
                    showAlertDialog(context, "Lütfen Mesaj Giriniz !");
                  }
                }
              ),
              
            ],
          ),
        )
      ),
    );
  }

  void sendMess(String mes) async {
    var dateUtc = DateTime.now().toUtc();
    var currDt = dateUtc.toLocal();
    var year = currDt.year;
    var mon = currDt.month;
    var day = currDt.day;
    var hour =currDt.hour; 
    var min = currDt.minute;
    var sec = currDt.second;
    String date = day.toString()+"-"+mon.toString()+"-"+year.toString()
            +"-"+hour.toString()+"-"+min.toString()+"-"+sec.toString();

    // Akademisyene Yaz
    QuerySnapshot _myDoc = await Firestore.instance.collection('profs').getDocuments();
    List<DocumentSnapshot> _myDocCount = _myDoc.documents;
    for(int i=0; i<_myDocCount.length ;++i){
      if(_myDocCount[i].data["mail"] == widget.akaEmail){
        try {
          List m = new List();
          m.add(date+"@"+widget.code+"@"+widget.name+"@"+mes);
          databaseReference
              .collection('profs')
              .document(_myDocCount[i].documentID)
              .updateData({'Mesajlar': FieldValue.arrayUnion(m)});
          m = new List();
        } catch (e) {
          print(e.toString());
        }
      }
    }
    // Öğrencilere Yaz.
    _myDoc = await Firestore.instance.collection('students').getDocuments();
    _myDocCount = _myDoc.documents;
    for(int i=0; i<_myDocCount.length ;++i){
      var number = _myDocCount[i].data["studentNumber"];
      var name = _myDocCount[i].data["name"];
      var surname = _myDocCount[i].data["surname"]; 
      if(widget.stuNames.contains(name) && widget.stuSurnames.contains(surname)
        && widget.stuCodes.contains(number) && _myDocCount[i].data["univercity"]==widget.uni){
        try {
          List m = new List();
          m.add(date+"@"+widget.code+"@"+widget.name+"@"+mes);
          databaseReference
              .collection('students')
              .document(_myDocCount[i].documentID)
              .updateData({'Mesajlar': FieldValue.arrayUnion(m)});
          m = new List();
        } catch (e) {
          print(e.toString());
        }
      }
    }

  }

  showAlertDialog(BuildContext context, String mes) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(mes),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("Tamam"),
              onPressed:  () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}