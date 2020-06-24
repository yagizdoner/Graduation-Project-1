import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse465ers/shared/loading.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
    var nm = new List();
    var surNm = new List();
    var pics = new List();
    var val = await databaseReference.collection('Cources').getDocuments();
    for(int i=0 ; i<val.documents.length ; ++i){
      if(val.documents[i].data['Ders Adı'] == widget.name && 
         val.documents[i].data['Üniversite'] == widget.uni &&
         val.documents[i].data['Ders Kodu'] == widget.code &&
         val.documents[i].data['İstekler'].length > 0){
        for(int j=0; j<val.documents[i].data['İstekler'].length ; ++j){
          nums.add(val.documents[i].data['İstekler'][j]);
        }
      }
    }
    val = await databaseReference.collection('students').getDocuments();
    for(int i=0; i<nums.length; ++i){
      for(int j=0; j<val.documents.length; ++j){
        if(val.documents[j].data["univercity"]==widget.uni && val.documents[j].data["studentNumber"]==nums[i]){
          nm.add(val.documents[j].data["name"]);
          surNm.add(val.documents[j].data["surname"]);
          String n = val.documents[j].data["profilePicture"];
          if(n != "no"){
            var ref = FirebaseStorage.instance.ref().child(n);
            await ref.getDownloadURL().then((val) => setState(() {
              String url = val;
              var image = Image.network(
                url,
                fit: BoxFit.cover,
              );
              pics.add(image);
            }));
          }
          else{
            var image = Image(
              image: AssetImage('assets/profile.png'),
              fit: BoxFit.cover,
            );
            pics.add(image);
          }
        }
      }
    }
    return [nums,nm,surNm,pics];
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
                        studentRow(data[0], data[1], data[2],data[3])
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

  List<Widget> studentRow(code, name, surname, pics){
    List<Widget> list = new List();
    for(int i=0; i<code.length ;++i){
      list.add(createStudentRow(code[i], name[i], surname[i], pics[i]));
      list.add(SizedBox(height:10,));
    }
    return list;
  }

  RaisedButton createStudentRow(String id, String na, String su, pic){
    return RaisedButton(
      onPressed: () => showGeneralDialog(
        barrierLabel: "Barrier",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: Duration(milliseconds: 700),
        context: context,
        pageBuilder: (_, __, ___) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 300,
              child: SizedBox.expand(
                child: pic,
              ),
              margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          );
        },
        transitionBuilder: (_, anim, __, child) {
          return SlideTransition(
            position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
            child: child,
          );
        },
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
                child: ClipOval(
                  child: new SizedBox(
                    width: MediaQuery.of(context).size.width/4,
                    height: MediaQuery.of(context).size.height/10,
                    child: pic,
                  ),
                ),
                foregroundColor: Colors.white,
              ),
              title: Text(na + " " + su),
              subtitle: Text(id),
            ),
          ),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'İptal',
              color: Colors.red,
              icon: Icons.delete_forever,
              onTap: ((){
                showAlertDialogRetTF(context, id+" - "+na+" "+su, id);
              }) ,
            ),
            IconSlideAction(
              caption: 'Kabul',
              color: Colors.green,
              icon: Icons.done_outline,
              onTap: ((){
                showAlertDialogKabulTF(context, id+" - "+na+" "+su, id);
              }) ,
            ),
          ],
      ),
    );
  }

  void dersRet(String id) async{
    var idL = new List();
    idL.add(id);
    var val = await databaseReference.collection('Cources').getDocuments();
    for(int i=0 ; i<val.documents.length ; ++i){
      if(val.documents[i].data['Ders Adı'] == widget.name && 
              val.documents[i].data['Üniversite'] == widget.uni &&
              val.documents[i].data['Ders Kodu'] == widget.code){
        await databaseReference.collection("Cources")
            .document(val.documents[i].documentID)
            .updateData({
              'İstekler': FieldValue.arrayRemove(idL),
        });
      }
    }
  }

  void dersKabul(String id) async{
    var idL = new List();
    idL.add(id);
    var val = await databaseReference.collection('Cources').getDocuments();
    for(int i=0 ; i<val.documents.length ; ++i){
      if(val.documents[i].data['Ders Adı'] == widget.name && 
              val.documents[i].data['Üniversite'] == widget.uni &&
              val.documents[i].data['Ders Kodu'] == widget.code){
        await databaseReference.collection("Cources")
            .document(val.documents[i].documentID)
            .updateData({
              'İstekler': FieldValue.arrayRemove(idL),
        });
        await databaseReference.collection("Cources")
          .document(val.documents[i].documentID)
          .updateData({
            'Kayıtlılar': FieldValue.arrayUnion(idL),
        });
      }
    }
  }

  showAlertDialogKabulTF(BuildContext context, String message, id) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("Öğrenciyi Derse Eklemek İstediğinize Emin misiniz?"),
          content: Text(message),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("Derse Ekle"),
              onPressed:  () {
                dersKabul(id);
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
  showAlertDialogRetTF(BuildContext context, String message, id) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("Öğrenciyi Reddetmek İstediğinize Emin misiniz?"),
          content: Text(message),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("Evet"),
              onPressed:  () {
                dersRet(id);
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              child: Text("Hayır"),
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