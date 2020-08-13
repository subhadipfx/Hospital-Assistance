import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Future<void> dialog(BuildContext context, String message, String header) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Text(header),
      content: Text(message),
      scrollable: true,
      actions: [
        FlatButton(
          child: Text('OK'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ),
  );
}