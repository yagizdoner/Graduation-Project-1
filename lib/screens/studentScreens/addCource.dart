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
    var istek = new List();
    var kayitli = new List();
    var istekVar = new List();
    var val = await databaseReference.collection('Cources').getDocuments();

    for(int i=0 ; i<val.documents.length ; ++i){
      if(val.documents[i].data['Üniversite'] == widget.uni){
        int t=0;
        if(val.documents[i].data['Kayıtlılar'].length > 0){
          for (int j=0; j<val.documents[i].data['Kayıtlılar'].length; j++) {
            if(val.documents[i].data['Kayıtlılar'][j] == widget.stuNum){
              // Öğrenci dersde zaten, herhangi bir şey ekleme.
              t=1;
            }
          }
        }
        if(t==0){
          int f=0;
          colle.add(val.documents[i].documentID);
          names.add(val.documents[i].data['Ders Adı']);
          codes.add(val.documents[i].data['Ders Kodu']);
          profs.add(val.documents[i].data["Ders Prof"]);
          konts.add(val.documents[i].data["Kontenjan"]);
          istek.add(val.documents[i].data["İstekler"].length);
          kayitli.add(val.documents[i].data["Kayıtlılar"].length);
          if(val.documents[i].data['İstekler'].length > 0){
            for (int j=0; j<val.documents[i].data['İstekler'].length; j++) {
              if(val.documents[i].data['İstekler'][j] == widget.stuNum){
                // Öğrenci derse kayıt isteğinde bulunmuş zaten.
                f=1;
                istekVar.add("1");
              }
            }
            if(f==0){
              istekVar.add("0");
            }
          }
          else{
            istekVar.add("0");
          }
        }
      }
    }
    return [names,codes,profs,konts,colle,istek,kayitli,istekVar];
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
                          createCourse(data[0], data[1], data[2], data[3], data[4], data[5], data[6],data[7])
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

  List<Widget> createCourse(List name,List code,List prof,List kont,List col,List ist,List kay,List isVar){
    List<Widget> list = new List();
    list.add(TextFormField(
        decoration: new InputDecoration(
          hintText: '   Dersleri Filtrelemek İçin Ders Kodu Giriniz',
          suffixIcon: Icon(
            Icons.filter_list,
            color: Color(0xFF033140),
          ),
        ),
        obscureText: true,
        cursorColor: Color(0xFF033140),
        onChanged: (val) {

        },
      ),
    );
    list.add(SizedBox(height: MediaQuery.of(context).size.height / 50));
    for(int i=0; i<name.length ;++i){
      list.add(createCourseRow(name[i], code[i], prof[i], kont[i], col[i], ist[i], kay[i], isVar[i]));
      list.add(SizedBox(height:10,));
    }
    return list;
  }

  Slidable createCourseRow(String name, String id, String prof, String kont, String colNum, int ist, int kay, String isVar){
    int kalanKont = int.parse(kont) - (ist+kay);
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
            title: Text(name + "      (Kalan Kontenjan : " + kalanKont.toString() + " \\ "+ kont +")"),
            subtitle: Text(prof),
          ),
        ),
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Kayıt İsteği\n   Gönder',
            color: Colors.blue,
            icon: Icons.add,
            onTap: ((){
              showAlertDialogTF(context, id+" - "+name, colNum, kalanKont, isVar);
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

  showAlertDialogTF(BuildContext context, String message, colNum, kalanKont, isVar) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("Derse Kayıt Olmak İstediğinize Emin misiniz?"),
          content: Text(message),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("Kayıt Ol"),
              onPressed:  () {
                if(isVar == "1"){
                  // İstekte Bulunmuş
                  showAlertDialog(context,"Derse Kayıt İsteğiniz Bulunmakta.");
                }
                else if(kalanKont>0){
                  // İstekte Bulunmamış ve Kontenjan var.
                  // Kayıt olabilir
                  addWish(colNum);
                  Navigator.pop(context);
                }
                else{
                  // İstekte bulunmamış ama kontenjan yok.
                  // Kayıt Olamaz
                  showAlertDialog(context,"Dersin Kontenjanı Doludur.");
                }
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