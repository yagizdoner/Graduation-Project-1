import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse465ers/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {

  final String mail;
  const Profile(this.mail);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  
  String password = '';
  String univercity = '';
  String uni = '';
  String tel = '';
  String phoneNumber = '';
  String error = '';
  bool loading = false;

  final _formKey = GlobalKey<FormState>();
  final databaseReference = Firestore.instance;

  @override
  void initState() {
    super.initState();
    getUserDetailFromDB();
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
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
                  borderRadius: new BorderRadius.all(Radius.circular(40.0)),
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
                            hintText: uni,
                            suffixIcon: Icon(
                              Icons.done_all,
                              color: Color(0xFF033140),
                            ),
                          ),
                          cursorColor: Color(0xFF033140),
                          validator: (val) => val.isEmpty ? 'Lütfen Üniversite Giriniz' : null,
                          onChanged: (val) {
                            setState(() => univercity = val);
                          },
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height/70),
                      Container(
                        height: MediaQuery.of(context).size.height/18,
                        child: TextFormField(
                          decoration: new InputDecoration(
                            hintText: tel,
                            suffixIcon: Icon(
                              Icons.phone,
                              color: Color(0xFF033140),
                            ),
                          ),
                          cursorColor: Color(0xFF033140),
                          validator: (val) => val.isEmpty ? 'Lütfen Telefon Giriniz' : null,
                          onChanged: (val) {
                            setState(() => phoneNumber = val);
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
                        Icons.add,
                        color: Colors.white,
                      ),
                      SizedBox(width:MediaQuery.of(context).size.width/100),
                      Text(
                        'Kaydet',
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
                    updateCourseToDB(univercity, phoneNumber, password);
                    setState(() {
                      loading = false;
                      error = 'Profiliniz Güncellenmiştir.';
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
              SizedBox(height:MediaQuery.of(context).size.height/10),
              RaisedButton(
                color: Color(0xFF033140),
                child: Container(
                  width: MediaQuery.of(context).size.width/3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                      ),
                      SizedBox(width:MediaQuery.of(context).size.width/100),
                      Text(
                        'Üyeliğimi Sil',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                onPressed: ()  {
                  print("SİL E BASILDI");
                }
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateCourseToDB(String uni, String phone, String pass) async{
    Future<String> getUserDoc() async {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      FirebaseUser user = await _auth.currentUser();
      return user.uid;
    }
    getUserDoc().then((val){
      if(val!=null){
        databaseReference.collection('profs')
                .document(val).updateData({'univercity': uni,
                                        'phoneNumber': phone,});
                                        // ŞİFRE UNUTMA !!!
      }
    });
  }

  void getUserDetailFromDB() async{
    Future<String> getUserDoc() async {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      FirebaseUser user = await _auth.currentUser();
      return user.uid;
    }
    getUserDoc().then((val) async{
      if(val!=null){
        DocumentReference document = databaseReference.collection('profs').document(val);
        await document.get().then<dynamic>(( DocumentSnapshot snapshot) async{
          setState(() {
            uni=snapshot.data["univercity"];
            tel=snapshot.data["phoneNumber"];
          });
        });
      }
    });
  }
}