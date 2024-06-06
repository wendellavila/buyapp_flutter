import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:buyapp/ui/screens/shopping/shopping.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BuyApp',
      theme: ThemeData(
        primaryColor: Colors.red,
        fontFamily: GoogleFonts.montserrat().fontFamily,
      ),
      debugShowCheckedModeBanner: false,
      home: ShoppingScreen(),
    );
  }
}
