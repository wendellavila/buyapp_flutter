import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  Profile(this._balance);
  final _balance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: ListTile(
        leading: Icon(Icons.attach_money, color: Colors.black),
        title: Text(
          "Curent balance",
          style: TextStyle(fontSize: 16.0),
        ),
        subtitle: Text(
          "R\$" + _balance.toStringAsFixed(2),
        ),
      ),
    );
  }
}
