import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse465ers/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Wishes extends StatefulWidget {
  final String name;
  final String code;
  final String uni;
  Wishes(this.name,this.code, this.uni);

  @override
  _WishesState createState() => _WishesState();
}

class _WishesState extends State<Wishes> {

  final databaseReference = Firestore.instance;
  Future fut;
  bool loading = false;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState(){
    super.initState();
    fut = getStudent();
  }

  getStudent() async{
    var nums = new List(); 
    var val = await databaseReference.collection('Cources').getDocuments();
    for(int i=0 ; i<val.documents.length ; ++i){
      if(val.documents[i].data['Ders Adı'] == widget.name && 
         val.documents[i].data['Üniversite'] == widget.uni &&
         val.documents[i].data['İstekler'].length > 0){
        for(int j=0; j<val.documents[i].data['İstekler'].length ; ++j){
          nums.add(val.documents[i].data['İstekler'][j]);
        }
      }
    }
    // nums da öğrenci numarası var ve widget.uni dede üniversite var.
    // DB den öğrenci adlarını çek ve ekrana öyle yazdırı ver gari :D
    return nums;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF033140),
        title: Text("Kayıt İstekleri"),
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
                body: Text("\n\nKayıt İsteği Yok."),
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
                        studentRow(data)
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
    fut = getStudent();
    setState(() {});
  }

  List<Widget> studentRow(code){
    List<Widget> list = new List();
    for(int i=0; i<code.length ;++i){
      list.add(createStudentRow(code[i]));
      list.add(SizedBox(height:10,));
    }
    return list;
  }

  Slidable createStudentRow(String id){
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
            title: Text(id),
            //subtitle: Text(prof),
          ),
        ),
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'İptal',
            color: Colors.red,
            icon: Icons.delete_forever,
            onTap: ((){
              dersRet();
            }) ,
          ),
          IconSlideAction(
            caption: 'Kabul',
            color: Colors.green,
            icon: Icons.done_outline,
            onTap: ((){
              dersKabul();
            }) ,
          ),
        ],
    );
  }

  void dersRet() async{
    
  }

  void dersKabul() async{
    
  }
}