import 'package:flutter/material.dart';

Widget textfield(
    {TextEditingController? ctrl,
    bool? obscureText,
    required bool applyRegExp,
    required bool passwordCheck,
    Widget? suffixIcon,
    String? hintText,
    RegExp? regExpPattern,
    String? errorMsg}) {
  return TextFormField(
    controller: ctrl,
    validator: (value) {
      if (value!.isEmpty) {
        return 'Please enter a value';
      } else if (applyRegExp ? !value.contains(regExpPattern!) : false) {
        return errorMsg;
      } else if (passwordCheck && value.length < 6) {
        return errorMsg;
      }
    },
    obscureText: obscureText ?? false,
    decoration: InputDecoration(
      hintText: hintText,
      contentPadding: const EdgeInsets.all(18),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: Colors.black, width: 2),
      ),
      enabled: true,
      hintStyle: const TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.w400,
        fontSize: 15,
        backgroundColor: Colors.white,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(color: Colors.black, width: 8),
      ),
      isDense: true,
      suffixIcon: suffixIcon ?? const SizedBox.shrink(),
    ),
  );
}
