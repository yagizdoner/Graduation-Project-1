import 'dart:async';
import 'package:cse465ers/models/student.dart';
import 'package:cse465ers/models/prof.dart';
import 'package:cse465ers/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create student object based on FirebaseUser
  Student _studentFromFirebaseStudent(FirebaseUser student){
    return student != null ? Student(uid: student.uid) : null;
  }

  // create prof object based on FirebaseUser
  Prof _profFromFirebaseProf(FirebaseUser prof){
    return prof != null ? Prof(uid: prof.uid) : null;
  }

  // auth change student stream
  Stream<Student> get student{
    return _auth.onAuthStateChanged
      .map(_studentFromFirebaseStudent);
  }

  // auth change student stream
  Stream<Prof> get prof{
    return _auth.onAuthStateChanged
      .map(_profFromFirebaseProf);
  }

  // sign in email & password Student
  Future signInWithEmailAndPasswordStudent(String email, String password) async{
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser student = result.user;
      return _studentFromFirebaseStudent(student); // verification açınca bu satırı sil.
      /*if(student.isEmailVerified){
        return _studentFromFirebaseStudent(student);
      }
      return null;*/
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  // sign in email & password Professor
  Future signInWithEmailAndPasswordProf(String email, String password) async{
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser prof = result.user;
      return _profFromFirebaseProf(prof);  // verification açınca, bu satırı sil.
      /*if (prof.isEmailVerified){ 
        return _profFromFirebaseProf(prof);
      }
      return null;*/
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
      // await student.sendEmailVerification();
      await DatabaseService(uid:student.uid).updateStudentData(email, name, surname, studentNumber, univercity);
      return _studentFromFirebaseStudent(student);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  // register with email & password
  Future registerProf(String email, String name, String surname, String phoneNumber, String univercity, String password) async{
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser prof = result.user;
      // await prof.sendEmailVerification();
      await DatabaseService(uid:prof.uid).updateProfData(email, name, surname, phoneNumber, univercity);
      return _profFromFirebaseProf(prof);
     } catch (e) {
        print(e.message);
        return null;
     }
  }

  Future<void> updatePass(String _email) async{
    try{
      await _auth.sendPasswordResetEmail(email: _email);
    }
    catch(e){
      print(e.toString());
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