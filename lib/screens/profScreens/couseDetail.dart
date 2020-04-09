import 'package:cse465ers/services/auth.dart';
import 'package:cse465ers/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CourseDetail extends StatefulWidget {
  @override
  _CourseDetailState createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  bool loading = false;
  final AuthService _auth = AuthService();

  String courseName = '';
  String courseDep = '';
  String profName = '';
  String kontenjan = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
       appBar: AppBar(
        backgroundColor: Color(0xFF033140),
        title: Text(" Ders İsmi "),
        actions: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                icon : Icon(
                  MdiIcons.logout,
                  color: Colors.white,
                ),
                onPressed: () async {
                  await _auth.signOut();
                }
              ),
            ],
          )
        ],
      ),

      backgroundColor: Color(0xFFD9E6EB),
      body: Container(
        color: Color(0xFFD9E6EB),
        child: SingleChildScrollView(
          child: Column(
          children: <Widget>[
            createSlidable("Yağız", "Döner", "141044062"),
            createSlidable("Atakan", "Döner", "180109019"),
            createSlidable("Öğrenci Adı", "Soyadı", "Numarası"),
          ],
        ),
        ),
      ),
    );
  }

  Slidable createSlidable(String studentName, String studentSurname, String id){
    return Slidable(
      actionPane: SlidableStrechActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        color: Colors.white,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.indigoAccent,
            child: Text(studentName[0] + studentSurname[0]),
            foregroundColor: Colors.white,
          ),
          title: Text(studentName + ' ' + studentSurname),
          subtitle: Text(id),
        ),
      ),
      /*actions: <Widget>[
        IconSlideAction(
          caption: 'İstekler',
          color: Colors.blue,
          icon: Icons.add,
          onTap: () => print('İstekler'),
        ),
        IconSlideAction(
          caption: 'Mesaj Gönder',
          color: Colors.indigo,
          icon: Icons.message,
          onTap: () => print('Mesaj Gönder'),
        ),
      ],*/
      secondaryActions: <Widget>[
        /*IconSlideAction(
          caption: 'Detay',
          color: Colors.black45,
          icon: Icons.more_horiz,
          onTap: () => print('Detay'),
        ),*/
        IconSlideAction(
          caption: 'Sil',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => print('Sil'),
        ),
      ],
    );
  }
}