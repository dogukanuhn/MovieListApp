import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CategoryPin extends StatelessWidget {
  String text;
  Color color;
  CategoryPin(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 5),
      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      decoration: BoxDecoration(
          color: color.withOpacity(.3),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Text(
        this.text,
        style: TextStyle(color: this.color),
      ),
    );
  }
}
