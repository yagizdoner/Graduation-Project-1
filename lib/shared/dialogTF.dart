import 'package:flutter/cupertino.dart';

class DialogTF extends StatefulWidget {
  @override
  _DialogTFState createState() => _DialogTFState();
}

class _DialogTFState extends State<DialogTF> {
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text("Accept?"),
      content: Text("Cidden mi harbi mi :D ?"),
      actions: <Widget>[
        CupertinoDialogAction(child: Text("No")),
        CupertinoDialogAction(child: Text("Yes")),
      ],
    );
  }
}