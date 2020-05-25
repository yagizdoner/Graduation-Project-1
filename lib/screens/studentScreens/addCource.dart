import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse465ers/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AddCource extends StatefulWidget {
  final String uni;
  final String stuNum;
  const AddCource(this.uni, this.stuNum);
  @override
  _AddCourceState createState() => _AddCourceState();
}

class _AddCourceState extends State<AddCource> {

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
    var names = new List(); 
    var codes = new List(); 
    var profs = new List();
    var konts = new List();
    var colle = new List();
    final _fireStore = Firestore.instance;
    var val = await _fireStore.collection('Cources').getDocuments();
    for(int i=0 ; i<val.documents.length ; ++i){
      if(val.documents[i].data['Üniversite'] == widget.uni){
        colle.add(val.documents[i].documentID);
        names.add(val.documents[i].data['Ders Adı']);
        codes.add(val.documents[i].data['Ders Kodu']);
        profs.add(val.documents[i].data["Ders Prof"]);
        konts.add(val.documents[i].data["Kontenjan"]);
      }
    }
    return [names,codes,profs,konts,colle];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFF033140),
        title: Text("Açık Dersler"),
        actions: <Widget>[
          Row(
            children: <Widget>[
               RaisedButton(
                color: Color(0xFF033140),
                child: Container(
                  width: MediaQuery.of(context).size.width/6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        MdiIcons.filter,
                        color: Colors.white,
                      ),
                      SizedBox(width:MediaQuery.of(context).size.height/90),
                      Text(
                        'Filtre',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                onPressed: () async {
                  print("FİLTRELEME UYGULANACAK");
                }
              ),
            ],
          )
        ],
      ),
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
                body: Text("\n\n  Açılmış Bir Ders Yok."),
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
                    color: Color(0xFFD9E6EB),
                    child: SingleChildScrollView(
                      child: Column(
                        children:
                          createCourse(data[0], data[1], data[2], data[3], data[4])
                     ),
                    ),
                  ),
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

  List<Widget> createCourse(name,code,prof, kont, col){
    List<Widget> list = new List();
    for(int i=0; i<name.length ;++i){
      list.add(createCourseRow(name[i], code[i], prof[i], kont[i], col[i]));
      list.add(SizedBox(height:10,));
    }
    return list;
  }

  Slidable createCourseRow(String name, String id, String prof, String kont, String colNum){
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
            title: Text(name + "      (Kalan Kontenjan : " + kont + ")"),
            subtitle: Text(prof),
          ),
        ),
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Kayıt İsteği\n   Gönder',
            color: Colors.blue,
            icon: Icons.add,
            onTap: ((){
              addWish(colNum);
            }) ,
          ),
        ],
    );
  }

  void addWish(String collectionNumber) async {
    List<String> arr = new List<String>();
    arr.add(widget.stuNum);
    await databaseReference.collection("Cources")
        .document(collectionNumber)
        .updateData({
          'İstekler': FieldValue.arrayUnion(arr),
    });
  }
}