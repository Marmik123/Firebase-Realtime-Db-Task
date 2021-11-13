import 'package:flutter/material.dart';

showSnackBar({String? messg, required BuildContext context}) {
  final snackBar = SnackBar(content: Text('$messg'));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
