import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse465ers/services/auth.dart';
import 'package:cse465ers/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class UpdateCourse extends StatefulWidget {

  final String code;
  final String name;
  const UpdateCourse(this.code, this.name);

  @override
  _UpdateCourseState createState() => _UpdateCourseState();
}

class _UpdateCourseState extends State<UpdateCourse> {

  @override
  void initState() {
    super.initState();
    setState(() {
      header = widget.name;
    });
    getCourceDetailFromDB();
    setState(() {
      courseDep = dep;
      courseName = ad;
      courseCode = kod;
      kontenjan = kont;
    });
  }

  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final databaseReference = Firestore.instance;


  String courseName = '';
  String courseDep = '';
  String profName = ''; // veriden çek
  String courseCode ='';
  String kontenjan = '';
  String error = '';
  String header = '';
  String ad = '';
  String kod = '';
  String dep = '';
  String kont = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
       appBar: AppBar(
        backgroundColor: Color(0xFF033140),
        title: Text(header),
      ),
      backgroundColor: Color(0xFFD9E6EB),
      body: Container(
        color: Color(0xFFD9E6EB),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height/10),
              Container(
                margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.height/12, 
                                            MediaQuery.of(context).size.height/36, 
                                            MediaQuery.of(context).size.height/12, 
                                            MediaQuery.of(context).size.height/15),
                decoration: new BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: MediaQuery.of(context).size.width/80,  
                    style: BorderStyle.solid,
                  ),
                  color: Colors.white,
                  borderRadius: new BorderRadius.all(Radius.circular(50.0)),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: MediaQuery.of(context).size.height/45),
                      
                      Container(
                        height: MediaQuery.of(context).size.height/18,
                        child: TextFormField(
                          decoration: new InputDecoration(
                            hintText: ad,
                            suffixIcon: Icon(
                              Icons.done_all,
                              color: Color(0xFF033140),
                            ),
                          ),
                          cursorColor: Color(0xFF033140),
                          validator: (val) => val.isEmpty ? 'Lütfen Ders Adı Giriniz' : null,
                          onChanged: (val) {
                            setState(() => courseName = val);
                          },
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height/70),
                      Container(
                        height: MediaQuery.of(context).size.height/18,
                        child: TextFormField(
                          decoration: new InputDecoration(
                            hintText: kod,
                            suffixIcon: Icon(
                              Icons.code,
                              color: Color(0xFF033140),
                            ),
                          ),
                          cursorColor: Color(0xFF033140),
                          validator: (val) => val.isEmpty ? 'Lütfen Ders Kodu Giriniz' : null,
                          onChanged: (val) {
                            setState(() => courseCode = val);
                          },
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height/70),
                      Container(
                        height: MediaQuery.of(context).size.height/18,
                        child: TextFormField(
                          decoration: new InputDecoration(
                            hintText: dep,
                            suffixIcon: Icon(
                              Icons.info_outline,
                              color: Color(0xFF033140),
                            ),
                          ),
                          cursorColor: Color(0xFF033140),
                          validator: (val) => val.isEmpty ? 'Lütfen Bölüm Giriniz' : null,
                          onChanged: (val) {
                            setState(() => courseDep = val);
                          },
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height/70),
                      Container(
                        height: MediaQuery.of(context).size.height/18,
                        child: TextFormField(
                          decoration: new InputDecoration(
                            hintText: kont,
                            suffixIcon: Icon(
                              Icons.info_outline,
                              color: Color(0xFF033140),
                            ),
                          ),
                          cursorColor: Color(0xFF033140),
                          validator: (val) => val.isEmpty ? 'Lütfen Kontenjan Giriniz' : null,
                          onChanged: (val) {
                            setState(() => kontenjan = val);
                          },
                        ),
                      ),
                      SizedBox(height:MediaQuery.of(context).size.height/45),
                    ],
                  ),
                ),
              ),
              RaisedButton(
                color: Color(0xFF033140),
                child: Container(
                  width: MediaQuery.of(context).size.width/3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.update,
                        color: Colors.white,
                      ),
                      SizedBox(width:MediaQuery.of(context).size.width/100),
                      Text(
                        'Güncelle',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                onPressed: ()  {
                  if(_formKey.currentState.validate()){
                    setState(() => loading = true);
                    updateCourseToDB(courseName, courseCode, courseDep, kontenjan);
                    setState(() => loading = false);                                  
                    setState(() {
                      error = 'Güncellendi';
                    });
                  }
                  else{
                    setState(() {
                      error = 'Lütfen Gerekli Yerleri Doldurunuz';
                      loading = false;
                    });
                  }
                }
              ),
              SizedBox(height: MediaQuery.of(context).size.height/60),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateCourseToDB(String name, String code, String dep, String kont) async {
    QuerySnapshot _myDoc = await Firestore.instance.collection('Cources').getDocuments();
    List<DocumentSnapshot> _myDocCount = _myDoc.documents;
    for(int i=0; i<_myDocCount.length ;++i){
      if(_myDocCount[i].data["Ders Kodu"] == widget.code && _myDocCount[i].data["Ders Adı"] == widget.name){
        try {
          databaseReference
              .collection('Cources')
              .document(_myDocCount[i].documentID)
              .updateData({'Ders Adı': name,
                           'Ders Kodu': code,
                           'Bölüm': dep,
                           'Kontenjan': kont});
        } catch (e) {
          print(e.toString());
        }
      }
    }
  }

  void getCourceDetailFromDB() async {
    QuerySnapshot _myDoc = await Firestore.instance.collection('Cources').getDocuments();
    List<DocumentSnapshot> _myDocCount = _myDoc.documents;
    for(int i=0; i<_myDocCount.length ;++i){
      if(_myDocCount[i].data["Ders Kodu"] == widget.code && _myDocCount[i].data["Ders Adı"] == widget.name){
        DocumentReference document = databaseReference.collection('Cources').document(_myDocCount[i].documentID);
        await document.get().then<dynamic>(( DocumentSnapshot snapshot) async{
          setState(() {
            ad=snapshot.data["Ders Adı"];
            kod=snapshot.data["Ders Kodu"];
            dep=snapshot.data["Bölüm"];
            kont=snapshot.data["Kontenjan"];
          });
        });
      }
    }
  }
}