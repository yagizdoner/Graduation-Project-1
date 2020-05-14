import 'package:cse465ers/screens/profScreens/updateCourse.dart';
import 'package:cse465ers/services/auth.dart';
import 'package:cse465ers/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CourseDetail extends StatefulWidget {
  
  final String name;
  final String code;
  const CourseDetail(this.name, this.code);

  @override
  _CourseDetailState createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  bool loading = false;
  final AuthService _auth = AuthService();

  String courseName = '';
  String courseCode = '';
  String courseDep = '';
  String profName = '';
  String kontenjan = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      courseName = widget.name;
      courseCode = widget.code;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
       appBar: AppBar(
        backgroundColor: Color(0xFF033140),
        title: Text(courseName),
        actions: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                icon : Icon(
                  MdiIcons.update,
                  color: Colors.white,
                ),
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UpdateCourse(courseCode)),
                  );
                }
              ),
              SizedBox(width: MediaQuery.of(context).size.width/30,),
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
              Container(
                color: Colors.blueGrey,
                height: MediaQuery.of(context).size.height/5,
              ),
              SizedBox(height:10,),
              createSlidable("Yağız", "Döner", "141044062"),
              SizedBox(height: 10,),
              createSlidable("Atakan", "Döner", "180109019"),
              SizedBox(height: 10,),
              createSlidable("Öğrenci Adı", "Soyadı", "Numarası"),
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
                  width: MediaQuery.of(context).size.width/3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.message,
                        color: Colors.white,
                      ),
                      SizedBox(width:MediaQuery.of(context).size.height/40),
                      Text(
                        'Sınıfa\nMesaj Gönder',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                onPressed: () async {
                  print("Mesaj Göndere Basıldı.");
                }
              ),
              RaisedButton(
                color: Color(0xFF033140),
                child: Container(
                  width: MediaQuery.of(context).size.width/4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.assignment_turned_in,
                        color: Colors.white,
                      ),
                      SizedBox(width:MediaQuery.of(context).size.height/40),
                      Text(
                        'İstekler',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                onPressed: () async {
                  print("İsteklere Basıldı.");
                }
              ),
            ],
          ),
        )
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
          title: Text(studentName + ' ' + studentSurname + '  ( '+id+' ) '),
          //subtitle: Text(id),
        ),
      ),
      secondaryActions: <Widget>[
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