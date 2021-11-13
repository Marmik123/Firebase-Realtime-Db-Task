import 'package:flutter/material.dart';

Widget buildLoader() {
  return const SizedBox(
    height: 20,
    width: 20,
    child: Center(
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: Colors.blueGrey,
      ),
    ),
  );
}
