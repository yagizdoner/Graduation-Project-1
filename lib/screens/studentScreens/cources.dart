import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse465ers/screens/studentScreens/addCource.dart';
import 'package:cse465ers/screens/studentScreens/courseDetail.dart';
import 'package:cse465ers/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Cources extends StatefulWidget {

  final String studentName;
  const Cources(this.studentName);

  @override
  _CourcesState createState() => _CourcesState();
}

class _CourcesState extends State<Cources> {
  
  final databaseReference = Firestore.instance;
  Future fut;
  bool loading = false;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState(){
    super.initState();
    fut = getCourse();
  }

  getCourse() async{
    /*var names = new List(); 
    var codes = new List(); 
    final _fireStore = Firestore.instance;
    var val = await _fireStore.collection('Cources').getDocuments();
    for(int i=0 ; i<val.documents.length ; ++i){
      if((val.documents[i].data['Ders Prof']) == widget.studentName){
        names.add(val.documents[i].data['Ders Adı']);
        codes.add(val.documents[i].data['Ders Kodu']);
      }
    }
    return [names,codes];*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: fut,
          builder: (BuildContext context,AsyncSnapshot snapshot){
            if(snapshot.connectionState != ConnectionState.done){
              return Loading();
            }
            if(!snapshot.hasData){
              return SmartRefresher(
                enablePullDown: true,
                controller: _refreshController,
                onRefresh: _onRefresh,
                header: BezierCircleHeader(),
                child: Scaffold(
                backgroundColor: Color(0xFFD9E6EB),
                body: Text("\n\n     KAYITLI DERSİNİZ BULUNMAMAKTADIR..."),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddCource()),
                    );
                  },
                  child: Icon(Icons.add),
                  backgroundColor: Color(0xFF033140),
                ),
              ),
             );
            }
            final data = snapshot.data;
            return Scaffold(
              backgroundColor: Color(0xFFD9E6EB),
              body:SmartRefresher(
                enablePullDown: true,
                controller: _refreshController,
                onRefresh: _onRefresh,
                header: BezierCircleHeader(),
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children:
                        createCourse(data[0], data[1])
                    ),
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddCource()),
                  );
                },
                child: Icon(Icons.add),
                backgroundColor: Color(0xFF033140),
              ),
            );
          },
        ),
      ),
    );
  }

  _onRefresh() async{
    fut = getCourse();
    setState(() {});
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