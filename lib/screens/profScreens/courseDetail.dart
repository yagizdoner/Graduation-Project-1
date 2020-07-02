import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse465ers/screens/profScreens/sendMessage.dart';
import 'package:cse465ers/screens/profScreens/updateCourse.dart';
import 'package:cse465ers/screens/profScreens/wishes.dart';
import 'package:cse465ers/shared/loading.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CourseDetail extends StatefulWidget {
  
  final String name;
  final String code;
  final String uni;
  final String user;
  const CourseDetail(this.name, this.code, this.uni, this.user);

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
  final _fireStore = Firestore.instance;
  
  var names = new List();
  var surnames = new List();
  var codes = new List();
  var pics = new List();

  @override
  void initState() {
    super.initState();
    fut = getCourse();
  }

  getCourse() async{
    String ist = "";
    String kont = "";
    var val = await _fireStore.collection('Cources').getDocuments();
    for(int i=0 ; i<val.documents.length ; ++i){
      if((val.documents[i].data['Üniversite']) == widget.uni && val.documents[i].data["Ders Kodu"] == widget.code
                                                             && val.documents[i].data["Ders Adı"] == widget.name){
        kont = val.documents[i].data['Kontenjan'];
        ist = val.documents[i].data['İstekler'].length.toString();
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
          String n = val.documents[i].data["profilePicture"];
          if(n!= "no"){
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
    return [names,surnames,codes,ist,kont,pics];
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
                    MaterialPageRoute(builder: (context) => UpdateCourse(widget.code, widget.name, widget.user, widget.uni)),
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
                        createRows(data[0],data[1],data[2],data[3],data[4],data[5]),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SendMessage(widget.name, widget.code, widget.uni,names,surnames,codes,widget.user)),
                  );
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
                      SizedBox(width:MediaQuery.of(context).size.width/30),
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

  List<Widget> createRows(name,surname,code,ist,kont, pics){
    List<Widget> list = new List();
    // Bilgi Ekranı Burası...
    list.add(Container(
      color: Colors.blue[200],
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          chart(int.parse(ist),int.parse(kont), code.length),
          SizedBox(height: MediaQuery.of(context).size.height/50),
        ],
      ),
      height: MediaQuery.of(context).size.height/4,
    ));
    
    for(int i=0; i<code.length ;++i){
      list.add(createSlidable(name[i],surname[i],code[i],pics[i]));
      list.add(SizedBox(height:10,));
    }
    return list;
  }

  RaisedButton createSlidable(String studentName, String studentSurname, String id, pic){
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
          height: MediaQuery.of(context).size.height/9,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height/70,),
              ListTile(
                leading: CircleAvatar(
                  radius: MediaQuery.of(context).size.width/10,
                  backgroundColor: Colors.indigoAccent,
                  child: ClipOval(
                    child: new SizedBox(
                      width: MediaQuery.of(context).size.width/7,
                      height: MediaQuery.of(context).size.height/5,
                      child: pic,
                    ),
                  ),
                  foregroundColor: Colors.white,
                ),
                title: Text(studentName + ' ' + studentSurname + '  ( '+id+' ) '),
                //subtitle: Text(id),
              ),
            ],
          ),
        ),
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Dersden Çıkart',
            color: Colors.red,
            icon: Icons.delete,
            // Dersden Çıkartma Ekle...
            onTap: () =>showAlertDialogTF(context,id,studentName,studentSurname),
          ),
        ],
      ),
    );
  }

  PieChart chart(int istek, int kont, int mevcut){
    int kalanKont = kont - (istek + mevcut);
    Map<String, double> dataMap = Map();
    List<Color> colorList = [
      Colors.red,
      Colors.green,
      Colors.yellow[300],
    ];
    dataMap.putIfAbsent("Mevcut ($mevcut)", () => mevcut.toDouble());
    dataMap.putIfAbsent("İstek ($istek)", () => istek.toDouble());
    dataMap.putIfAbsent("Boş Kontenjan ($kalanKont)", () => kalanKont.toDouble());
    
    return PieChart(
      dataMap: dataMap,
      animationDuration: Duration(milliseconds: 800),
      chartLegendSpacing: 32.0,
      chartRadius: MediaQuery.of(context).size.width / 3,
      showChartValuesInPercentage: true,
      showChartValues: true,
      showChartValuesOutside: false,
      chartValueBackgroundColor: Colors.grey[200],
      colorList: colorList,
      showLegends: true,
      legendPosition: LegendPosition.right,
      decimalPlaces: 1,
      showChartValueLabel: false,
      initialAngle: 0,
      chartValueStyle: defaultChartValueStyle.copyWith(
        color: Colors.blueGrey[900].withOpacity(0.9),
      ),
      chartType: ChartType.disc,
    );
  }
  

  _onRefresh() async{
    names = new List();
    surnames = new List();
    codes = new List();
    fut = getCourse();
    setState(() {});
  }

  showAlertDialogTF(BuildContext context, id, studentName, studentSurname) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("Dersden Çıkarmak İstediğinize Emin misiniz?"),
          content: Text(id+" - "+studentName + ' ' + studentSurname),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("Dersden Çıkar"),
              onPressed:  () {
                dropFromCource(id);
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

  dropFromCource(String id)async{
    List rem = new List();
    rem.add(id);
    var val = await _fireStore.collection('Cources').getDocuments();
    for(int i=0 ; i<val.documents.length ; ++i){
      if((val.documents[i].data['Üniversite']) == widget.uni && val.documents[i].data["Ders Kodu"] == widget.code
                                                            && val.documents[i].data["Ders Adı"] == widget.name){      
        await _fireStore.collection("Cources")
            .document(val.documents[i].documentID)
            .updateData({
              'Kayıtlılar':  FieldValue.arrayRemove(rem),
        });
      }
    }
  }

}