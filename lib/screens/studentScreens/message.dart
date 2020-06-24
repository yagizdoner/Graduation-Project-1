import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse465ers/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Message extends StatefulWidget {
  final String user;
  const Message(this.user);
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  final databaseReference = Firestore.instance;
  Future fut;
  bool loading = false;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState(){
    super.initState();
    fut = getMessages();
    setState(() {});
  }

  getMessages() async{
    var names = new List(); 
    var codes = new List();
    var message = new List();
    var dates = new List();
    final _fireStore = Firestore.instance;
    var val = await _fireStore.collection('students').getDocuments();
    for(int i=0 ; i<val.documents.length ; ++i){
      if(val.documents[i].data['mail'] == widget.user){
        var mes = val.documents[i].data['Mesajlar'];
        if(mes!=null){ 
          for(int j=0; j<mes.length ;++j){
            var sp = mes[j].split('@');
            dates.add(sp[0]);
            codes.add(sp[1]);
            names.add(sp[2]);
            message.add(sp[3]);
          }
          break;
        }
      }
    }
    return [names,codes,message,dates];
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
                        createCourse(data[0], data[1], data[2],data[3])
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
    fut = getMessages();
    setState(() {});
  }

  List<Widget> createCourse(name,code,mess,date){
    List<Widget> list = new List();
    if(name.length == 0){
      list.add(SizedBox(height: 40,));
      list.add(Text(
        "MESAJINIZ YOKTUR.",
        style: TextStyle(
          fontSize: 16,
        ),
      ));
    }
    for(int i=0; i<name.length ;++i){
      list.add(createCourseRow(name[i], code[i], mess[i],date[i]));
      list.add(SizedBox(height:10,));
    }
    return list;
  }

  RaisedButton createCourseRow(String name, String id, String message, String date){
    var d = date.split("-");
    String da =  ((d[0].length < 2)?("0"+ d[0]):(d[0])) 
    + ":" + ((d[1].length < 2)?("0"+ d[1]):(d[1])) + ":" + d[2];
    String sa =  ((d[3].length < 2)?("0"+ d[3]):(d[3]))  + ":"
              +  ((d[4].length < 2)?("0"+ d[4]):(d[4]))  + ":"
              +  ((d[5].length < 2)?("0"+ d[5]):(d[5])) ;
    var ms = message.split("\n");
    var ln = ms.length;
    return RaisedButton(
      onPressed: () => showAlertDialog(context, message),
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children:[
                        SizedBox(height: MediaQuery.of(context).size.height/80),
                        Text(da),
                        SizedBox(height: MediaQuery.of(context).size.height/80),
                        Text(sa),
                      ]
                    )
                  ],
                ),
                subtitle:(ln > 1)?Text(ms[0] + "..."):Text(ms[0]),
              ),
            ),
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Sil',
                color: Colors.red,
                icon: Icons.delete,
                onTap: ((){
                  showAlertDialogTF(context, id+" - "+name, name, id, message);
                }) ,
              ),
            ],
          ),
          
        ],
      ),
    );
  }

  Future<String> getDocId() async {
    return await Firestore.instance.collection('students').getDocuments().then((var asd){
        for(int i=0; i<asd.documents.length ;++i){
          if(asd.documents[i].data['mail'] == widget.user){
            return asd.documents[i].documentID;
          }
        }
      }
    );
  }

  showAlertDialogTF(BuildContext context, String message, name, id, mess) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("Mesajı Silmek İstediğinize Emin misiniz?"),
          content: Text(message),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("Sil"),
              onPressed:  () {
                String ms = id+"@"+name+"@"+mess;
                List m = new List();
                m.add(ms);
                getDocId().then((String result){
                  try {
                    databaseReference
                        .collection('students')
                        .document(result.toString())
                        .updateData({"Mesajlar" : FieldValue.arrayRemove(m)});
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

  showAlertDialog(BuildContext context, String mes) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(mes),
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