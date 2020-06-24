import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse465ers/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:cse465ers/screens/profScreens/addCourse.dart';
import 'package:cse465ers/screens/profScreens/courseDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class Cources extends StatefulWidget {
  
  final String profName;
  final String uni;
  final String user;
  const Cources(this.profName, this.uni, this.user);
  
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
    setState(() {});
  }

  getCourse() async{
    var names = new List(); 
    var codes = new List();
    var unis = new List();
    var kont = new List();
    var ist = new List();
    var kay = new List();
    final _fireStore = Firestore.instance;
    var val = await _fireStore.collection('Cources').getDocuments();
    for(int i=0 ; i<val.documents.length ; ++i){
      if(val.documents[i].data['Ders Prof'] == widget.profName &&
          val.documents[i].data['Üniversite'] == widget.uni){
        names.add(val.documents[i].data['Ders Adı']);
        codes.add(val.documents[i].data['Ders Kodu']);
        unis.add(val.documents[i].data['Üniversite']);
        kont.add(val.documents[i].data['Kontenjan']);
        ist.add(val.documents[i].data['İstekler'].length);
        kay.add(val.documents[i].data['Kayıtlılar'].length);
      }
    }
    return [names,codes,unis,kont,ist,kay];
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
                body: Text("\n\nVeritabanında Bir Hata Var"),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddCource(widget.profName, widget.uni)),
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
              body: SmartRefresher(
                enablePullDown: true,
                controller: _refreshController,
                onRefresh: _onRefresh,
                header: BezierCircleHeader(),
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children:
                        createCourse(data[0], data[1], data[2], data[3], data[4], data[5])
                    ),
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddCource(widget.profName, widget.uni)),
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

  List<Widget> createCourse(name,code,uni,kont,ist,kay){
    List<Widget> list = new List();
    for(int i=0; i<name.length ;++i){
      list.add(createCourseRow(name[i], code[i], uni[i], kont[i], ist[i], kay[i]));
      list.add(SizedBox(height:10,));
    }
    return list;
  }

  RaisedButton createCourseRow(String name, String id, String uni, String kont, int ist, int kay){
    int kalanKont = int.parse(kont) - (ist + kay);
    return RaisedButton(
      onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CourseDetail(name, id, uni, widget.user)),
          ),
      padding: const EdgeInsets.all(0.0),
      child: Column(
        children: <Widget>[
          Slidable(
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
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    Text(name),
                    Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children:[
                        Text("Kontenjan : " + "(" +kalanKont.toString() + "/" + kont + ")"),
                        SizedBox(height: MediaQuery.of(context).size.height/80),
                        Text("Mevcut : "+ kay.toString()),
                        SizedBox(height: MediaQuery.of(context).size.height/80),
                        Text("İstek : "+ ist.toString()),
                      ]
                    )
                  ],
                ),
              ),
            ),
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Sil',
                color: Colors.red,
                icon: Icons.delete,
                onTap: ((){
                  showAlertDialogTF(context, id+" - "+name, name, id);
                }) ,
              ),
            ],
          ),
          
        ],
      ),
    );
  }

  Future<String> getDocId(String name, String code) async {
    return await Firestore.instance.collection('Cources').getDocuments().then((var asd){
        for(int i=0; i<asd.documents.length ;++i){
          if(asd.documents[i].data["Ders Kodu"] == code && asd.documents[i].data["Ders Adı"] == name){
            return asd.documents[i].documentID;
          }
        }
      }
    );
  }

  showAlertDialogTF(BuildContext context, String message, name, id) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("Dersi Silmek İstediğinize Emin misiniz?"),
          content: Text(message),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("Dersi Sil"),
              onPressed:  () {
                getDocId(name,id).then((String result){
                  try {
                    databaseReference
                        .collection('Cources')
                        .document(result.toString())
                        .delete();
                  } catch (e) {
                    print(e.toString());
                  }
                });
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              child: Text("İptal"),
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