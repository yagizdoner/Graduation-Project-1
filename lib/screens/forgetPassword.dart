import 'package:cse465ers/services/auth.dart';
import 'package:cse465ers/shared/loading.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {

  final Function toggleView;
  ForgetPassword({ this.toggleView });

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {

  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  final AuthService _auth = AuthService();


  // text field state
  String email = '';
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
            SizedBox(height: MediaQuery.of(context).size.height/20,),
            Center(
              child:Text(
                'ERS - Şifremi Unuttum',
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
                                                MediaQuery.of(context).size.height/28),
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
                                contentPadding: EdgeInsets.zero,
                                border: const OutlineInputBorder(           
                                  borderSide: const BorderSide(color: Colors.green, width: 2.0), 
                                ),
                                hintText: '   Kullanıcı Maili',
                                suffixIcon: Icon(
                                  Icons.mail_outline,
                                  color: Color(0xFF033140),
                                ),
                              ),
                              cursorColor: Color(0xFF033140),
                              validator: (val) => val.isEmpty ? 'Lütfen Kayıtlı bir Mail Giriniz' : null,
                              onChanged: (val) {
                                setState(() => email = val);
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
                              width: MediaQuery.of(context).size.width/3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.forward,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: MediaQuery.of(context).size.width/50,),
                                  Text(
                                    'Şifremi Yenile',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () async {
                              setState(() {
                                loading = true;
                              });
                              _auth.updatePass(email);
                              Navigator.pop(context);
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
                  Container(
                    child: Center(
                      child: Column(
                        children: <Widget> [
                          SizedBox(height:  MediaQuery.of(context).size.height/60),
                          Text(
                            "        Sisteme kayıtlı e-mail\n    adresinizi girdikten sonra,\nposta kutunuza şifre yenileme\n       mesajı gönderilecektir.",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF033140),
                            )
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height/20)
                        ]
                      )
                    )
                  )
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
          child: BackButton(
            color: Colors.white,
            onPressed: () async {
              Navigator.pop(context);
            }
          ),
        )
      ),
    );
  }
}

