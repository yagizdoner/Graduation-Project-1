import 'package:cse465ers/models/student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse465ers/models/studentInfo.dart';

class DatabaseService {

  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference studentCollection = Firestore.instance.collection('students');

  Future updateStudentData(String mail, String name, String surname, String studentNumber, String univercity) async {
    return await studentCollection.document(uid).setData({
      'mail': mail,
      'name': name,
      'surname': surname,
      'studentNumber': studentNumber,
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

  // studentData from snapshot
  StudentData _StudentDataFromSnapshot(DocumentSnapshot snapshot){
    return StudentData(
      uid: uid,
      mail: snapshot.data['mail'] ,
      name: snapshot.data['name'] ,
      surname: snapshot.data['surname'] ,
      studentNumber: snapshot.data['studentNumber'] ,
      univercity: snapshot.data['univercity'] ,
    );
  }

  // get brew stream
  Stream<List<StudentInfo>> get brews{
    return studentCollection.snapshots()
    .map(_studentListFromSnapshot);
  }

  // get user doc stream
  Stream<StudentData> get userData{
    return studentCollection.document(uid).snapshots()
    .map(_StudentDataFromSnapshot);
  }
}