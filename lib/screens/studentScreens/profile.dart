import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse465ers/main.dart';
import 'package:cse465ers/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  
  final String mail;
  const Profile(this.mail);
  
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  
  String password = '';
  String error = '';
  String univercity = '';
  String stuNumber = '';
  String imageName = 'no';
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final databaseReference = Firestore.instance;
  Future fut;
  File _image;

  @override
  void initState() {
    super.initState();
    fut = getStudentDetailFromDB();
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Color(0xFFD9E6EB),
      body: FutureBuilder(
        future: fut,
        builder:  (BuildContext context,AsyncSnapshot snapshot){
          if(snapshot.connectionState != ConnectionState.done){
            return Loading();
          }
          if(!snapshot.hasData){
            return Scaffold(
              backgroundColor: Color(0xFFD9E6EB),
              body: Text("\n\n     BİR SORUNLA KARŞILAŞILDI. LÜTFEN SAYFAYI YENİLEYİNİZ !"),
            );
          }
        final data = snapshot.data;
        return Container(
          color: Color(0xFFD9E6EB),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height/40),
                Row(
                  children: <Widget>[
                    SizedBox(width: MediaQuery.of(context).size.width/4),
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: Color(0xff476cfb),
                        child: ClipOval(
                          child: new SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: (data[2]!=null)? Image.network(
                                                  data[2],
                                                  fit: BoxFit.cover,
                                                )
                                                : Image(
                                                  image: AssetImage('assets/profile.png'),
                                                  fit: BoxFit.cover,
                                                ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width/30),
                    IconButton(
                      iconSize: 40,
                      icon: Icon(
                          Icons.camera_enhance,
                          color: Colors.black,
                        ),
                      onPressed: (){
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                title: Text("Resim Seçiniz."),
                                actions: <Widget>[
                                  CupertinoDialogAction(
                                    child: Text("Kamera"),
                                    onPressed:  () async{
                                      await openCamera();
                                      Navigator.pop(context);
                                    },
                                  ),
                                  CupertinoDialogAction(
                                    child: Text("Galeri"),
                                    onPressed:  () async{
                                      await openGallery();
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                      },
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height/60),
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
                              hintText: data[0],
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
                              hintText: data[1],
                              suffixIcon: Icon(
                                Icons.done,
                                color: Color(0xFF033140),
                              ),
                            ),
                            cursorColor: Color(0xFF033140),
                            validator: (val) => val.isEmpty ? 'Lütfen Numaranızı Giriniz' : null,
                            onChanged: (val) {
                              setState(() => stuNumber = val);
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
                        SizedBox(width:MediaQuery.of(context).size.width/30),
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
                      updateCourseToDB(univercity, stuNumber);
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
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                ),
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
                    showAlertDialogTF(context);
                  }
                ),
              ],
            ),
          ),
        );
        }
      ),
    );
  }

  void updateCourseToDB(String u, String n) async{
    Future<String> getUserDoc() async {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      FirebaseUser user = await _auth.currentUser();
      return user.uid;
    }
    getUserDoc().then((val){
      if(val!=null){
        databaseReference.collection('students')
                .document(val).updateData({'univercity': u,
                                        'studentNumber': n,});
      }
    });
  }

  getStudentDetailFromDB() async{
    Future<String> getUserDoc() async {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      FirebaseUser user = await _auth.currentUser();
      return user.uid;
    }
    
    List<String> a = new List();
    List<String> b = new List();
    List<String> c = new List();
    List<String> d = new List();
  
    var val = await getUserDoc();
    if(val!=null){
      DocumentReference document = databaseReference.collection('students').document(val);
      await document.get().then<dynamic>(( DocumentSnapshot snapshot) async{
          a.add(snapshot.data["univercity"]);
          b.add(snapshot.data["studentNumber"]);
          c.add(snapshot.data["profilePicture"]);
          d.add(await getPic(c[0]));
      });
      return [a[0],b[0],d[0]];
    }
  }

  Future<String> getPic(String s) async{
    String u;
    if(s != "no"){
      var ref = FirebaseStorage.instance.ref().child(s);
      u = await ref.getDownloadURL(); 
      return u;
    }
    return null;
  }

  showAlertDialogTF(BuildContext context){
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("Silmek İstediğine Emin misin?"),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("Sil"),
              onPressed:  () async{
                deleteUser();
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

  openCamera() async{
    var img = await ImagePicker.pickImage(source: ImageSource.camera);
    if(img != null){
      setState(() {
        _image = img;
      });
      uploadPic();
    }
  }

  openGallery() async{
    var img = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(img != null){
      setState(() {
        _image = img;
      });
      uploadPic();
    }
  }

  Future uploadPic() async{
    if(_image != null){
      String fileName = _image.path;
      var spl = fileName.split("/");
      StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(spl[spl.length-1]);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      StorageTaskSnapshot taskSnapshot=await uploadTask.onComplete;
      await setImageToDB(spl[spl.length-1]);

      fut = getStudentDetailFromDB();
      setState(() {});
    }
  }

  Future<String> setImageToDB(String url) async {
    return await Firestore.instance.collection('students').getDocuments().then((var asd){
        for(int i=0; i<asd.documents.length ;++i){
          if(asd.documents[i].data["mail"] == widget.mail){
            databaseReference
              .collection('students')
              .document(asd.documents[i].documentID)
              .updateData({'profilePicture': url,});
          }
        }
      }
    );
  }

  deleteUser() async{
    final _fireStore = Firestore.instance;
    var val = await _fireStore.collection('students').getDocuments();
    for(int i=0 ; i<val.documents.length ; ++i){
      if(val.documents[i].data['mail'] == widget.mail){
        var id = val.documents[i].documentID;
        await _fireStore.collection('students').document(id).delete();
        FirebaseUser user = await FirebaseAuth.instance.currentUser();
        user.delete();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyApp()),
        );
        break;
      }
    }
  }
}