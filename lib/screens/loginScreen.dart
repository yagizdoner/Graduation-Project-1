import 'package:cse465ers/screens/forgetPassword.dart';
import 'package:cse465ers/screens/profScreens/profSc.dart';
import 'package:cse465ers/screens/studentScreens/studentSc.dart';
import 'package:cse465ers/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:cse465ers/screens/profRegister.dart';
import 'package:cse465ers/screens/studentRegister.dart';
import 'package:cse465ers/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {

  final Function toggleView;
  LoginScreen({ this.toggleView });

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _fireStore = Firestore.instance;
  bool loading = false;
  var fut;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  void initState(){
    super.initState();
  }  

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Color(0xFF033140),
      body: Container(
        child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height/40),
            Image(
              image: AssetImage('assets/logIn.png'),
              height: MediaQuery.of(context).size.height/5,
            ),
            SizedBox(height: MediaQuery.of(context).size.height/20,),
            Center(
              child:Text(
                'Eğitim Rezervasyon Sistemi',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height/20,),
            Container(
              color: Color(0xFFD9E6EB),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.height/12, 
                                                MediaQuery.of(context).size.height/15, 
                                                MediaQuery.of(context).size.height/12, 
                                                MediaQuery.of(context).size.height/5),
                    decoration: new BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 5.0,  
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
                          SizedBox(height: MediaQuery.of(context).size.height/30),
                          Container(
                            height: MediaQuery.of(context).size.height/15,
                            child: TextFormField(
                              decoration: new InputDecoration(
                                hintText: '   Kullanıcı Maili',
                                suffixIcon: Icon(
                                  Icons.mail_outline,
                                  color: Color(0xFF033140),
                                ),
                              ),
                              cursorColor: Color(0xFF033140),
                              validator: (val) => val.isEmpty ? 'Lütfen Mail Giriniz' : null,
                              onChanged: (val) {
                                setState(() => email = val);
                              },
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height/30),
                          Container(
                            height: MediaQuery.of(context).size.height/15,
                            child: TextFormField(
                              obscureText: true,
                              decoration: new InputDecoration(
                                hintText: '   Şifre',
                                suffixIcon: Icon(
                                  Icons.remove_red_eye,
                                  color: Color(0xFF033140),
                                ),
                              ),
                              validator: (val) => val.length < 6 ? 'Şifre En Az 6 Karakter Olmalı' : null,
                              onChanged: (val) {
                                setState(() => password = val);
                              },
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height/30),
                          RaisedButton(
                            color: Color(0xFF033140),
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.black, width: 2.0)
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width/4,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.forward,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: MediaQuery.of(context).size.width/50,),
                                  Text(
                                    'Giriş',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () async {
                              if(_formKey.currentState.validate()){
                                setState(() {
                                  loading = true;
                                });
                                fut = await getUserType();  
                                if(fut == 0){
                                  dynamic result =  _auth.signInWithEmailAndPasswordProf(email, password);
                                  if(result == null) {
                                    setState(() {
                                      error = 'Şifre Hatalı';
                                      loading = false;
                                    });
                                  }
                                  else{
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ProfSc(email)),
                                    );
                                  }
                                }
                                else if(fut == 1){
                                  dynamic result =  _auth.signInWithEmailAndPassword(email, password);
                                  if(result == null) {
                                    setState(() {
                                      error = 'Şifre Hatalı';
                                      loading = false;
                                    });
                                  }
                                  else{
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => StudentSc(email)),
                                    );
                                  }
                                }
                                else{
                                  setState(() {
                                    error = "Kullanıcı Bulunamadı !";
                                  });
                                }
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
                ],
              ),
            ),
          ],
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
                  width: MediaQuery.of(context).size.width/3.6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.create,
                        color: Colors.white,
                      ),
                      SizedBox(width:MediaQuery.of(context).size.height/200),
                      Text(
                        'Akademisyen\nKayıt',
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
                    MaterialPageRoute(builder: (context) => ProfRegister()),
                  );
                }
              ),
              RaisedButton(
                color: Color(0xFF033140),
                child: Container(
                  width: MediaQuery.of(context).size.height/7,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.create,
                        color: Colors.white,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.height/200,),
                      Text(
                        'Öğrenci\nKayıt',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                onPressed: () async  {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StudentRegister()),
                  );
                }
              ),
              RaisedButton(
                color: Color(0xFF033140),
                child: Container(
                  width: MediaQuery.of(context).size.height/6.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.info_outline,
                        color: Colors.white,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.height/200,),
                      Text(
                        'Şifremi\nUnuttum',
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
                    MaterialPageRoute(builder: (context) => ForgetPassword()),
                  );
                }
              ),
            ],
          ),
        )
      ),
    );
  }

  getUserType() async {
    int ret = -1;
    var val1 = await _fireStore.collection('students').getDocuments();
    for(int i=0 ; i<val1.documents.length ; ++i){
      if(email == val1.documents[i].data['mail']){
        ret = 1; // found a student
        return ret;
      }
    }
    var val2 = await _fireStore.collection('profs').getDocuments();
    for(int i=0 ; i<val2.documents.length ; ++i){
      if(email == val2.documents[i].data['mail']){
        ret = 0; // found a professor
        return ret;
      }
    }
    return ret; // Not Found
  }
}
