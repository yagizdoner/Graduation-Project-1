import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse465ers/screens/loginScreen.dart';
import 'package:cse465ers/screens/profScreens/cources.dart';
import 'package:cse465ers/screens/profScreens/message.dart';
import 'package:cse465ers/services/auth.dart';
import 'package:cse465ers/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cse465ers/screens/profScreens/profile.dart';

class ProfSc extends StatefulWidget {
  final String user;
  const ProfSc(this.user);

  @override
  _ProfScState createState() => _ProfScState();

}

class _ProfScState extends State<ProfSc> {
   
  // text field state
  String password = '';
  String univercity = '';
  String phoneNumber = '';
  String error = '';
  String userMail = '';
  String userName = '';
  String userSurname = '';

  int bodyNum = 0; // Default -> Derslerim Ekranı
  final AuthService _auth = AuthService();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
      userMail = widget.user;
    });
    getUserInfo();
    setState(() {
      loading = false;
    });
  }

  getUserInfo() async{
    setState((){
      final _fireStore = Firestore.instance;
      Future getProf() async {
        return await _fireStore.collection('profs').getDocuments();
      }
      getProf().then((val){
        setState(() {
          for(int i=0 ; i<val.documents.length ; ++i){
            if(widget.user == val.documents[i].data['mail']){
              userName = val.documents[i].data['name'];
              userSurname = val.documents[i].data['surname'];
              break;
            }
          }
        });
      });
    });   
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF033140),
        title: Text(userName + ' ' + userSurname),
        actions: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                icon : Icon(
                  MdiIcons.logout,
                  color: Colors.white,
                ),
                onPressed: () async {
                  await _auth.signOut().whenComplete((){
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                  });
                }
              ),
            ],
          )
        ],
      ),

      body: bodyScreen(bodyNum, userName+' '+userSurname),

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
                        Icons.library_books,
                        color: Colors.white,
                      ),
                      SizedBox(width:MediaQuery.of(context).size.height/200),
                      Text(
                        'Derslerim',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                onPressed: () async {
                  setState(() => bodyNum = 0);
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
                        Icons.message,
                        color: Colors.white,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.height/200,),
                      Text(
                        'Mesajlar',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                onPressed: () async  {
                  setState(() => bodyNum = 1);
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
                        Icons.person,
                        color: Colors.white,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.height/200,),
                      Text(
                        'Profil',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                onPressed: () async {
                  setState(() => bodyNum = 2);
                }
              ),
            ],
          ),
        )
      ),
    );
  }

  Widget bodyScreen (bodyNum, name){
    switch (bodyNum) {
      case 0:
        return Cources(name);
      case 1:
        return Message();
      case 2:
        return Profile(widget.user);
      default:
        return Cources(name);
    }
  }
}