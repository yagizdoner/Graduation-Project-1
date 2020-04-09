import 'package:cse465ers/screens/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:cse465ers/models/student.dart';
import 'package:cse465ers/services/auth.dart';
import 'package:provider/provider.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return StreamProvider<Student>.value(
      value: AuthService().student,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
      ),
    );
  }
}