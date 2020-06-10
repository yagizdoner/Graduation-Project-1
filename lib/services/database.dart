import 'package:cse465ers/models/student.dart';
import 'package:cse465ers/models/prof.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse465ers/models/studentInfo.dart';
import 'package:cse465ers/models/profInfo.dart';

class DatabaseService {

  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference studentCollection = Firestore.instance.collection('students');
  final CollectionReference profCollection = Firestore.instance.collection('profs');

  Future updateStudentData(String mail, String name, String surname, String studentNumber, String univercity) async {
    return await studentCollection.document(uid).setData({
      'mail': mail,
      'name': name,
      'surname': surname,
      'studentNumber': studentNumber,
      'univercity': univercity,
    });
  }

  Future updateProfData(String mail, String name, String surname, String phoneNumber, String univercity) async {
    return await profCollection.document(uid).setData({
      'mail': mail,
      'name': name,
      'surname': surname,
      'phoneNumber': phoneNumber,
      'univercity': univercity,
    });
  }

  // student list from snapshots
  List<StudentInfo> _studentListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc) {
      return StudentInfo(
        mail: doc.data['mail'] ?? '',
        name: doc.data['name'] ?? '',
        surname: doc.data['surname'] ?? '',
        studentNumber: doc.data['studentNumber'] ?? '',
        univercity: doc.data['univercity'] ?? '',
      );
    }).toList();
  }

  // student list from snapshots
  List<ProfInfo> _profListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc) {
      return ProfInfo(
        mail: doc.data['mail'] ?? '',
        name: doc.data['name'] ?? '',
        surname: doc.data['surname'] ?? '',
        phoneNumber: doc.data['phoneNumber'] ?? '',
        univercity: doc.data['univercity'] ?? '',
      );
    }).toList();
  }

  // studentData from snapshot
  StudentData _studentDataFromSnapshot(DocumentSnapshot snapshot){
    return StudentData(
      uid: uid,
      mail: snapshot.data['mail'] ,
      name: snapshot.data['name'] ,
      surname: snapshot.data['surname'] ,
      studentNumber: snapshot.data['studentNumber'] ,
      univercity: snapshot.data['univercity'] ,
    );
  }

  // studentData from snapshot
  ProfData _profDataFromSnapshot(DocumentSnapshot snapshot){
    return ProfData(
      uid: uid,
      mail: snapshot.data['mail'] ,
      name: snapshot.data['name'] ,
      surname: snapshot.data['surname'] ,
      phoneNumber: snapshot.data['phoneNumber'] ,
      univercity: snapshot.data['univercity'] ,
    );
  }

  Stream<List<StudentInfo>> get student{
    return studentCollection.snapshots()
    .map(_studentListFromSnapshot);
  }

  Stream<List<ProfInfo>> get prof{
    return profCollection.snapshots()
    .map(_profListFromSnapshot);
  }

  // get user doc stream
  Stream<StudentData> get studentData{
    return studentCollection.document(uid).snapshots()
    .map(_studentDataFromSnapshot);
  }

  // get prof doc stream
  Stream<ProfData> get profData{
    return profCollection.document(uid).snapshots()
    .map(_profDataFromSnapshot);
  }
}