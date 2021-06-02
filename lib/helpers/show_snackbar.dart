import 'package:flutter/material.dart';

class ShowSnackbar {
  ShowSnackbar._();
  static snackbar(BuildContext context, String content, String label, Color backgroundColor) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        content: Text(content),
        action: SnackBarAction(
          textColor: Colors.white,
          label: label,
          onPressed: () => Scaffold.of(context).hideCurrentSnackBar()
        ),
      )
    );
  }
}
