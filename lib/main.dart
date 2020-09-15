import 'package:bookapp/constants.dart';
import 'package:bookapp/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(TextTheme(
            headline6: TextStyle(
                color: Colors.white, fontSize: 19, fontWeight: FontWeight.w300),
            headline5: TextStyle(color: Colors.white, fontSize: 20),
            subtitle1: TextStyle(
              color: gray,
            ))),
        backgroundColor: Color(0xff1d212b),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Wrapper(),
    );
  }
}
