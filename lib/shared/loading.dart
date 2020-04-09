import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFD9E6EB),
      child: Center(
        child: SpinKitChasingDots(
          color: Color(0xFF033140),
          size: 50.0,
        ),
      ),
    );
  }
}