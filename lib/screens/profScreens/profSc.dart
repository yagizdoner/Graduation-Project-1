import 'package:cse465ers/screens/profScreens/addCourse.dart';
import 'package:cse465ers/screens/profScreens/couseDetail.dart';
import 'package:cse465ers/services/auth.dart';
import 'package:cse465ers/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class ProfSc extends StatefulWidget {
  @override
  _ProfScState createState() => _ProfScState();
}

class _ProfScState extends State<ProfSc> {

  // text field state
  String password = '';
  String univercity = '';
  String phoneNumber = '';
  String error = '';
  final _formKey = GlobalKey<FormState>();

  int bodyNum = 0; // Default -> Derslerim Ekranı
  final AuthService _auth = AuthService();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF033140),
        title: Text(" Kullanıcı İsmi "),
        actions: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                icon : Icon(
                  MdiIcons.logout,
                  color: Colors.white,
                ),
                onPressed: () async {
                  await _auth.signOut();
                }
              ),
            ],
          )
        ],
      ),

      body: bodyScreen(bodyNum),

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

  Widget bodyScreen (bodyNum){
    switch (bodyNum) {
      case 0:
        return derslerim();
      case 1:
        return mesajlar();
      case 2:
        return profil();
      default:
        return derslerim();
    }
  }

  Widget derslerim (){
    final items = List<String>.generate(20, (i) => "Item ${i + 1}");

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            createSlidable("Bitirme 1", "Habil Kalkan", "465"),
            createSlidable("Bitirme 2", "Habil Kalkan", "466"),
            createSlidable("Ders Adı", "Eğitmen Adı", "Kodu"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddCouce()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF033140),
      ),
    );
  }

  Widget mesajlar (){
    return Scaffold(
      body: Text("\n\n\nMESAJ\n\n\n EKRANI")
    );
  }

  Widget profil (){
    return Scaffold(
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
                            hintText: '   Telefon',
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
              RaisedButton(
                color: Color(0xFF033140),
                child: Container(
                  width: MediaQuery.of(context).size.width/3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.save_alt,
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
                    //setState(() => loading = true);
                    // DB ye kaydet ve loading false yap
                    setState(() {
                      error = 'Profiliniz Güncellenmiştir.';
                      loading = false;
                    });
                    print("KAYDET E BASILDI");
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

  Slidable createSlidable(String name, String prof, String id){
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
          title: Text(name),
          subtitle: Text(prof),
        ),
      ),
      actions: <Widget>[
      IconSlideAction(
        caption: 'İstekler',
        color: Colors.blue,
        icon: Icons.add,
        onTap: () => print('İstekler'),
      ),
      IconSlideAction(
        caption: 'Mesaj Gönder',
        color: Colors.indigo,
        icon: Icons.message,
        onTap: () => print('Mesaj Gönder'),
      ),
    ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Detay',
          color: Colors.black45,
          icon: Icons.more_horiz,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CourseDetail()),
          ),
        ),
        IconSlideAction(
          caption: 'Sil',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => print('Sil'),
        ),
      ],
    );
  }
}