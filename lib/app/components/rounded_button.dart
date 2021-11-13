/*
import 'package:flutter/material.dart';
import 'package:rootally_task/app/components/circular_loader.dart';

Widget roundedButton({
  required String text,
  required VoidCallback onTap,
  required double width,
  required double height,
  required double fontSize,
  bool? isLoading = false,
}) {
  return ElevatedButton(
    onPressed: onTap,
    style: ButtonStyle(
      enableFeedback: true,
      padding: EdgeInsets.zero,
      //overlayColor: MaterialStateProperty.all(AppColors.kE5E5E5),
      elevation: elevation.msp,
      backgroundColor: Colors.transparent,
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
    ),
    child: Ink(
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
              begin: Alignment(-1, -2.8),
              end: Alignment(1, 5),
              colors: [AppColors.k1FAF9E, AppColors.k0087FF])),
      child: Container(
        height: height,
        child: Center(
          child: isLoading!
              ? buildLoader()
              : Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontStyle: FontStyle.normal,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      ),
    ),
  );
}
*/
