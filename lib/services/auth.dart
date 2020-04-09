import 'package:cse465ers/models/student.dart';
import 'package:cse465ers/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create student object based on FirebaseUser
  Student _studentFromFirebaseStudent(FirebaseUser student){
    return student != null ? Student(uid: student.uid) : null;
  }

  // auth change student stream
  Stream<Student> get student{
    return _auth.onAuthStateChanged
      .map(_studentFromFirebaseStudent);
  }

  // sign in email & password
  Future signInWithEmailAndPassword(String email, String password) async{
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser student = result.user;
      return _studentFromFirebaseStudent(student);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  // register with email & password
  Future registerStudent(String email, String name, String surname, String studentNumber, String univercity, String password) async{
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser student = result.user;
      //create a new document for the user with the uid
      await DatabaseService(uid:student.uid).updateStudentData(email, name, surname, studentNumber, univercity);
      return _studentFromFirebaseStudent(student);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}