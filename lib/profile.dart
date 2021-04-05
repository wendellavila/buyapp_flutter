import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
	final _balance;
	Profile(this._balance);
  	@override
  	_ProfileState createState() => _ProfileState(_balance);
}

class _ProfileState extends State<Profile> {
	final _balance;
	_ProfileState(this._balance);

	Widget _buildProfile(){
		return ListTile(
			leading: Icon(Icons.attach_money, color: Colors.black),
			title: Text(
				"Curent balance",
				style: TextStyle(fontSize: 16.0),
			),
			subtitle: Text(
				"R\$" + _balance.toStringAsFixed(2),
			),
		);
	}

  	@override
    Widget build(BuildContext context) {
      	return Scaffold(
			appBar: AppBar(
			title: Text("Profile"),
			),
			body: _buildProfile(),
		);
    }
}