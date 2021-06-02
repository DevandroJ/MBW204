import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final Color color;
  Loader({
    this.color
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 18.0,
        height: 18.0,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color ?? Colors.white),
        ),
      ),
    );
  }
}