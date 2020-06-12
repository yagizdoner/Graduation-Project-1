import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse465ers/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddCource extends StatefulWidget {
  final String profName;
  final String uni;
  const AddCource(this.profName, this.uni);

  @override
  _AddCourceState createState() => _AddCourceState();
}

class _AddCourceState extends State<AddCource> {

  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final databaseReference = Firestore.instance;

  String courseName = '';
  String courseDep = '';
  String courseCode ='';
  String kontenjan = '';
  String error = '';

  List emp = new List();

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
       appBar: AppBar(
        backgroundColor: Color(0xFF033140),
      ),

      backgroundColor: Color(0xFFD9E6EB),
      body: Container(
        color: Color(0xFFD9E6EB),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height/10),
              Container(
                margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.height/12, 
                                            MediaQuery.of(context).size.height/36, 
                                            MediaQuery.of(context).size.height/12, 
                                            MediaQuery.of(context).size.height/15),
                decoration: new BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: MediaQuery.of(context).size.width/80,  
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
                      SizedBox(height: MediaQuery.of(context).size.height/45),
                      
                      Container(
                        height: MediaQuery.of(context).size.height/18,
                        child: TextFormField(
                          decoration: new InputDecoration(
                            hintText: '   Ders Adı',
                            suffixIcon: Icon(
                              Icons.done_all,
                              color: Color(0xFF033140),
                            ),
                          ),
                          cursorColor: Color(0xFF033140),
                          validator: (val) => val.isEmpty ? 'Lütfen Ders Adı Giriniz' : null,
                          onChanged: (val) {
                            setState(() => courseName = val);
                          },
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height/70),
                      Container(
                        height: MediaQuery.of(context).size.height/18,
                        child: TextFormField(
                          decoration: new InputDecoration(
                            hintText: '   Dersin Kodu',
                            suffixIcon: Icon(
                              Icons.code,
                              color: Color(0xFF033140),
                            ),
                          ),
                          cursorColor: Color(0xFF033140),
                          validator: (val) => val.isEmpty ? 'Lütfen Ders Kodu Giriniz' : null,
                          onChanged: (val) {
                            setState(() => courseCode = val);
                          },
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height/70),
                      Container(
                        height: MediaQuery.of(context).size.height/18,
                        child: TextFormField(
                          decoration: new InputDecoration(
                            hintText: '   Bölüm',
                            suffixIcon: Icon(
                              Icons.info_outline,
                              color: Color(0xFF033140),
                            ),
                          ),
                          cursorColor: Color(0xFF033140),
                          validator: (val) => val.isEmpty ? 'Lütfen Bölüm Giriniz' : null,
                          onChanged: (val) {
                            setState(() => courseDep = val);
                          },
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height/70),
                      Container(
                        height: MediaQuery.of(context).size.height/18,
                        child: TextFormField(
                          decoration: new InputDecoration(
                            hintText: '   Kontenjan',
                            suffixIcon: Icon(
                              Icons.info_outline,
                              color: Color(0xFF033140),
                            ),
                          ),
                          cursorColor: Color(0xFF033140),
                          validator: (val) => val.isEmpty ? 'Lütfen Kontenjan Giriniz' : null,
                          onChanged: (val) {
                            setState(() => kontenjan = val);
                          },
                        ),
                      ),
                      SizedBox(height:MediaQuery.of(context).size.height/45),
                    ],
                  ),
                ),
              ),
              RaisedButton(
                color: Color(0xFF033140),
                child: Container(
                  width: MediaQuery.of(context).size.width/3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.save_alt,
                        color: Colors.white,
                      ),
                      SizedBox(width:MediaQuery.of(context).size.width/100),
                      Text(
                        'Ekle',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                onPressed: ()  {
                  if(_formKey.currentState.validate()){
                    addCourseToDB(courseName, courseCode, courseDep, kontenjan, widget.profName, widget.uni, emp);
                    showAlertDialog(context, courseCode+" - "+courseName ,"Ders Başarıyla Eklenmiştir.");
                  }
                  else{
                    setState(() {
                      error = 'Lütfen Gerekli Yerleri Doldurunuz';
                    });
                  }
                }
              ),
              SizedBox(height: MediaQuery.of(context).size.height/60),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
 
  void addCourseToDB(String name, String code, String dep, String kont, String prof, String uni, emp ) async {
    await databaseReference.collection("Cources")
        .document()
        .setData({
          'Ders Adı': name,
          'Ders Kodu': code,
          'Ders Prof': prof,
          'Bölüm': dep,
          'Kontenjan': kont,
          'Üniversite': uni,
          'İstekler': emp,
          'Kayıtlılar': emp,
    });
  }

  showAlertDialog(BuildContext context, String head, String mes) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(head),
          content: Text(mes),
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