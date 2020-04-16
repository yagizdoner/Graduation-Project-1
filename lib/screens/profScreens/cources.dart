import 'package:flutter/cupertino.dart';
import 'package:cse465ers/screens/profScreens/addCourse.dart';
import 'package:cse465ers/screens/profScreens/couseDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class Cources extends StatefulWidget {
  @override
  _CourcesState createState() => _CourcesState();
}

class _CourcesState extends State<Cources> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            createSlidable("Bitirme 1", "Habil Kalkan", "465"),
            SizedBox(height: 10,),
            createSlidable("Bitirme 2", "Habil Kalkan", "466"),
            SizedBox(height: 10,),
            createSlidable("Ders Adı", "Eğitmen Adı", "Kodu"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddCouce()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF033140),
      ),
    );
  }

  Slidable createSlidable(String name, String prof, String id){
    return Slidable(
      actionPane: SlidableStrechActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        color: Colors.white,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.indigoAccent,
            child: Text(id),
            foregroundColor: Colors.white,
          ),
          title: Text(name),
          //subtitle: Text(prof),
        ),
      ),
      actions: <Widget>[
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
    ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Detay',
          color: Colors.black45,
          icon: Icons.more_horiz,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CourseDetail()),
          ),
        ),
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

