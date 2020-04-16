import 'package:flutter/material.dart';
import 'package:cse465ers/shared/loading.dart';
import 'package:cse465ers/services/auth.dart';


class StudentRegister extends StatefulWidget {
  final Function toggleView;
  StudentRegister({ this.toggleView });

  @override
  _StudentRegisterState createState() => _StudentRegisterState();
}

class _StudentRegisterState extends State<StudentRegister> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String name = '';
  String surname = '';
  String studentNumber = '';
  String univercity = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Color(0xFF033140),
      body: Container(
        child: ListView(
          children: <Widget>[
            Image(
              image: AssetImage('assets/logIn.png'),
              height: MediaQuery.of(context).size.height/5,
            ),
            SizedBox(height: MediaQuery.of(context).size.height/40,),
            Center(
              child:Text(
                'ERS - Öğrenci Kayıt',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height/40,),
            Container(
              color: Color(0xFFD9E6EB),
              child: Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height/2,
                    margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.height/12, 
                                                MediaQuery.of(context).size.height/36, 
                                                MediaQuery.of(context).size.height/12, 
                                                MediaQuery.of(context).size.height/7),
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
                            height: MediaQuery.of(context).size.height/15,
                            child: TextFormField(
                              decoration: new InputDecoration(
                                hintText: '   İsim',
                                suffixIcon: Icon(
                                  Icons.person_outline,
                                  color: Color(0xFF033140),
                                ),
                              ),
                              cursorColor: Color(0xFF033140),
                              validator: (val) => val.isEmpty ? 'Lütfen İsim Giriniz' : null,
                              onChanged: (val) {
                                setState(() => name = val);
                              },
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height/70),
                          Container(
                            height: MediaQuery.of(context).size.height/18,
                            child: TextFormField(
                              decoration: new InputDecoration(
                                hintText: '   Soyisim',
                                suffixIcon: Icon(
                                  Icons.person_outline,
                                  color: Color(0xFF033140),
                                ),
                              ),
                              cursorColor: Color(0xFF033140),
                              validator: (val) => val.isEmpty ? 'Lütfen Soyisim Giriniz' : null,
                              onChanged: (val) {
                                setState(() => surname = val);
                              },
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height/70),
                          Container(
                            height: MediaQuery.of(context).size.height/18,
                            child: TextFormField(
                              decoration: new InputDecoration(
                                hintText: '   Üniversite',
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
                                hintText: '   Öğrenci Numarası',
                                suffixIcon: Icon(
                                  Icons.phone,
                                  color: Color(0xFF033140),
                                ),
                              ),
                              cursorColor: Color(0xFF033140),
                              validator: (val) => val.isEmpty ? 'Lütfen Öğrenci Numarası Giriniz' : null,
                              onChanged: (val) {
                                setState(() => studentNumber = val);
                              },
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height/70),
                          Container(
                            height: MediaQuery.of(context).size.height/18,
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
                          SizedBox(height: MediaQuery.of(context).size.height/70),
                          Container(
                            height: MediaQuery.of(context).size.height/18,
                            child: TextFormField(
                              decoration: new InputDecoration(
                                hintText: '   Şifre',
                                suffixIcon: Icon(
                                  Icons.info_outline,
                                  color: Color(0xFF033140),
                                ),
                              ),
                              obscureText: true,
                              cursorColor: Color(0xFF033140),
                              validator: (val) => val.length < 6 ? 'Şifre En Az 6 Karakter Olmalı' : null,
                              onChanged: (val) {
                                setState(() => password = val);
                              },
                            ),
                          ),
                          SizedBox(height:MediaQuery.of(context).size.height/45),
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
              Expanded(
                flex: 1,
                child: BackButton(
                  color: Colors.white,
                  onPressed: () async {
                    Navigator.pop(context);
                  }
                ),
              ),
              Expanded(
                flex: 3,
                child: RaisedButton(
                  color: Color(0xFF033140),
                  child: Container(
                    width: 100.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.create,
                          color: Colors.white,
                        ),
                        SizedBox(width:MediaQuery.of(context).size.width/100),
                        Text(
                          'Kayıt Ol',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () async {
                    if(_formKey.currentState.validate()){
                      setState(() => loading = true);
                      dynamic result = await _auth.registerStudent(email, name, surname, studentNumber, univercity, password);
                      if(result == null) {
                        setState(() {
                          error = 'Lütfen Geçerli Bir Mail Giriniz';
                          loading = false;
                        });
                      }
                      Navigator.pop(context);
                    }
                  }
                ),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(),
              )
            ],
          ),
        )
      ),
      
    );
  }
}