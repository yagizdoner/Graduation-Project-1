import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse465ers/screens/profScreens/updateCourse.dart';
import 'package:cse465ers/screens/profScreens/wishes.dart';
import 'package:cse465ers/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CourseDetail extends StatefulWidget {
  
  final String name;
  final String code;
  final String uni;
  const CourseDetail(this.name, this.code, this.uni);

  @override
  _CourseDetailState createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  bool loading = false;
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  String courseDep = '';
  String profName = '';
  String kontenjan = '';
  Future fut;

  @override
  void initState() {
    super.initState();
    fut = getCourse();
  }

  getCourse() async{
    var names = new List();
    var surnames = new List();
    var codes = new List();
    final _fireStore = Firestore.instance;
    var val = await _fireStore.collection('Cources').getDocuments();
    for(int i=0 ; i<val.documents.length ; ++i){
      if((val.documents[i].data['Üniversite']) == widget.uni && val.documents[i].data["Ders Kodu"] == widget.code){
        var len = val.documents[i].data["Kayıtlılar"];
        for(int j=0; j<len.length ;++j){
          codes.add(len[j]);
        }
      }
    }
    val = await _fireStore.collection('students').getDocuments();
    for(int j=0; j<codes.length ;++j){
      for(int i=0; i<val.documents.length ;++i){
        if(val.documents[i].data['univercity'] == widget.uni && val.documents[i].data['studentNumber'] == codes[j]){
          names.add(val.documents[i].data["name"]);
          surnames.add(val.documents[i].data["surname"]);
        }
      }
    }
    return [names,surnames,codes];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Color(0xFF033140),
        title: Text(widget.name),
        actions: <Widget>[
          Row(
            children: <Widget>[
               RaisedButton(
                color: Color(0xFF033140),
                child: Container(
                  width: MediaQuery.of(context).size.width/4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        MdiIcons.update,
                        color: Colors.white,
                      ),
                      SizedBox(width:MediaQuery.of(context).size.height/40),
                      Text(
                        'Dersi\nGüncelle',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UpdateCourse(widget.code, widget.name)),
                  );
                }
              ),
            ],
          )
        ],
      ),
      backgroundColor: Color(0xFFD9E6EB),
      body: Container(
        color: Color(0xFFD9E6EB),
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
                        createRows(data[0],data[1],data[2]),
                    ),
                  ),
                ),
              ),
            );
          }
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Wishes(widget.name,widget.code, widget.uni)),
                  );
                }
              ),
            ],
          ),
        )
      ),
    );
  }

  List<Widget> createRows(name,surname,code){
    List<Widget> list = new List();

    // Bilgi Ekranı Burası...
    list.add(Container(
                color: Colors.blueGrey,
                height: MediaQuery.of(context).size.height/5,
              ));
    
    for(int i=0; i<code.length ;++i){
      list.add(createSlidable(name[i],surname[i],code[i]));
      list.add(SizedBox(height:10,));
    }
    return list;
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
          caption: 'Dersden Çıkart',
          color: Colors.red,
          icon: Icons.delete,
          // Dersden Çıkartma Ekle...
          onTap: () => print('Sil'),
        ),
      ],
    );
  }

  _onRefresh() async{
    fut = getCourse();
    setState(() {});
  }
}