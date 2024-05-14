import 'package:flutter/material.dart';

Widget clipWidget(String text, color, textColor) {
  return Padding(
    padding: const EdgeInsets.only(left: 10, bottom: 10),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color,
        border: Border.all(color: Colors.white),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    ),
  );
}
