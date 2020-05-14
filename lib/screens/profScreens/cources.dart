import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse465ers/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:cse465ers/screens/profScreens/addCourse.dart';
import 'package:cse465ers/screens/profScreens/courseDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class Cources extends StatefulWidget {
  
  final String profName;
  const Cources(this.profName);
  
  @override
  _CourcesState createState() => _CourcesState();
}

class _CourcesState extends State<Cources> {

  var courseNames = [];
  var courseCodes = [];
  final databaseReference = Firestore.instance;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    getCourse();
    setState(() {
      loading = false;
    });
  }

  Future getCourse() async{
    final _fireStore = Firestore.instance;
    Future getCourses() async {
      return await _fireStore.collection('Cources').getDocuments();
    }
    getCourses().then((val){
      for(int i=0 ; i<val.documents.length ; ++i){
        if((val.documents[i].data['Ders Prof']) == widget.profName){
          courseNames.add(val.documents[i].data['Ders Adı']);
          courseCodes.add(val.documents[i].data['Ders Kodu']);
        }
      }
    }); 
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Color(0xFFD9E6EB),
      body: SingleChildScrollView(
        child: Column(
          children:
            createCourse(courseNames, courseCodes)
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

  List<Widget> createCourse(name,code){
    List<Widget> list = new List();
    for(int i=0; i<name.length ;++i){
      list.add(createCourseRow(name[i], code[i]));
      list.add(SizedBox(height:10,));
    }
    return list;
  }

  RaisedButton createCourseRow(String name, String id){
    return RaisedButton(
      onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CourseDetail(name, id)),
          ),
      padding: const EdgeInsets.all(0.0),
      child: Slidable(
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
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Sil',
            color: Colors.red,
            icon: Icons.delete,
            onTap: ((){
              try {
                databaseReference
                    .collection('Cources')
                    .document(id)
                    .delete();
              } catch (e) {
                print(e.toString());
              }
            }) ,
          ),
        ],
      ),
    );
  }
}

