import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cse465ers/shared/loading.dart';
import 'package:cse465ers/services/auth.dart';
import 'package:dropdownfield/dropdownfield.dart';


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
  Future fut;
  final _fireStore = Firestore.instance;

  // text field state
  String email = '';
  String name = '';
  String surname = '';
  String studentNumber = '';
  String univercity = '';
  String password = '';
  String error = '';

  List<String> unis = new List<String>();
  List<String> mails = new List<String>();

  @override
  void initState(){
    super.initState();
    fut = getUnivercities();
  }

  getUnivercities() async{
    List<String> un = new List<String>();
    List<String> ma = new List<String>();
    var val = await _fireStore.collection('Univercities').getDocuments();
    for(int i=0 ; i<val.documents.length ; ++i){
      un.add(val.documents[i].documentID);
      ma.add(val.documents[i].data['mail']);
    }
    unis = un;
    mails = ma;
    return [un,ma];
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Color(0xFF033140),
      body: Container(
        child: FutureBuilder(
            future: fut,
            builder: (BuildContext context,AsyncSnapshot snapshot){
            if(snapshot.connectionState != ConnectionState.done){
              return Loading();
            }
            final data = snapshot.data;
            return ListView(
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
                      margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.height/12, 
                                                  MediaQuery.of(context).size.height/36, 
                                                  MediaQuery.of(context).size.height/12, 
                                                  MediaQuery.of(context).size.height/20),
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
                                validator: (val) => val.isEmpty ? null : null,
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
                                validator: (val) => val.isEmpty ? null : null,
                                onChanged: (val) {
                                  setState(() => surname = val);
                                },
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height/70),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  DropDownField(
                                    onValueChanged: (dynamic value){
                                      univercity = value;
                                    },
                                    setter: (dynamic newValue) {
                                        univercity = newValue;
                                    },
                                    value: univercity,
                                    required: true,
                                    strict: true,
                                    hintText: 'Üniversi Seç',
                                    labelText: 'Üniversite',
                                    items: data[0],
                                  )
                                ],
                              )
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
                                validator: (val) => val.isEmpty ? null : null,
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
                                validator: (val) => val.isEmpty ? null : null,
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
                                validator: (val) => val.length < 6 ? null : null,
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
                      var mail = email.split('@'); // girilen mailin uzantısı 1. index de.
                      int uniIndex = unis.indexOf(univercity);
                      if(mails[uniIndex].contains(mail[1]) || mail[1].contains(mails[uniIndex])){
                        setState(() => loading = true);
                        dynamic result = await _auth.registerStudent(email, name, surname, studentNumber, univercity, password);
                        if(result == null) {
                          setState(() => loading = false);
                          showAlertDialog(context, "Kayıt Olunamadı! Kaydınız Olabilir.");                          
                        }
                        else{ // Kayıt Olunduysa
                          Navigator.pop(context);
                        }
                      }
                      else{
                        showAlertDialog(context, "Universiteniz ve Mail Uzantınız Eşleşmemektedir !");
                      }
                    }
                    else{ // Formda eksik yerler varsa
                        showAlertDialog(context, "Tüm Alanların Doldurulması Zorunludur. Şifre en az 6 karakter olmalıdır.");
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