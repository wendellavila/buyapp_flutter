import 'package:flutter/material.dart';

import 'package:buyapp/shopping.dart';
import 'package:buyapp/item.dart';
import 'package:buyapp/itemInfo.dart';

class Cart extends StatefulWidget {
	double _balance;
	var _saved = <Item>{};
	Cart(this._balance, this._saved);
	@override
	_CartState createState() => _CartState(_balance, _saved);
}

class _CartState extends State<Cart> {
	double _balance;
	double _totalPrice;
	var _saved = <Item>{};
	_CartState(this._balance, this._saved);

	Future<void> _clearCart() async {
		switch (await showDialog<bool>(
			context: context,
			builder: (BuildContext context){
			return SimpleDialog(
				title: Text("Clear cart?"),
				children: <Widget>[
					SimpleDialogOption(
						onPressed: () {Navigator.pop(context, true);},
						child: Text("Clear cart"),
					),
					SimpleDialogOption(
						onPressed: () {Navigator.pop(context, false);},
						child: Text('Cancel'),
					),
				],
			);
			}
		)) {
			case true:
				setState(() {
					_saved.clear();
				});
			// dialog dismissed
			break;
			case false:
			// dialog dismissed
			break;
		}
	}

	Future<void> _checkoutSuccess() async {
		return showDialog<void>(
			context: context,
			barrierDismissible: false,
			builder: (BuildContext context) {
			return AlertDialog(
				title: Text('Checkout successful'),
				content: SingleChildScrollView(
				child: ListBody(
					children: <Widget>[
					Text('Current balance:'),
					Text('R\$ ' + _balance.toStringAsFixed(2)),
					],
				),
				),
				actions: <Widget>[
				TextButton(
					child: Text('Close'),
					onPressed: () {
					Navigator.of(context).pop();
					},
				),
				],
			);
			},
		);
	}

	Future<void> _checkoutFail() async {
		return showDialog<void>(
			context: context,
			barrierDismissible: false,
			builder: (BuildContext context) {
			return AlertDialog(
				title: Text('Checkout failed'),
				content: SingleChildScrollView(
				child: ListBody(
					children: <Widget>[
					Text('Not enough funds.'),
					],
				),
				),
				actions: <Widget>[
				TextButton(
					child: Text('Close'),
					onPressed: () {
					Navigator.of(context).pop();
					},
				),
				],
			);
			},
		);
	}

	Future<void> _checkout() async {
		switch (await showDialog<bool>(
			context: context,
			builder: (BuildContext context){
			return SimpleDialog(
				title: Text("Confirm purchase"),
				children: <Widget>[
					SimpleDialogOption(
						onPressed: () {Navigator.pop(context, true);},
						child: Text("Confirm purchase"),
					),
					SimpleDialogOption(
						onPressed: () {Navigator.pop(context, false);},
						child: Text('Cancel'),
					),
				],
			);
			}
		)) {
			case true:
				setState(() {
					if(_balance - _totalPrice >= 0.0){
						_balance = _balance - _totalPrice;
						_saved.clear();
						_checkoutSuccess();
					}
					else {
						_checkoutFail();
					}
				});
			// dialog dismissed
			break;
			case false:
			// dialog dismissed
			break;
		}
	}

	Future<void> _addToCart(alreadySaved, pair) async {
		String actionTitle;
		String actionText;
		if (alreadySaved) {
			actionTitle = 'Remove product from cart?';
			actionText = 'Remove from cart';
		} else {
			actionTitle = 'Add product to cart?';
			actionText = 'Add to cart';
		} 
		switch (await showDialog<bool>(
			context: context,
			builder: (BuildContext context){
			return SimpleDialog(
				title: Text(actionTitle),
				children: <Widget>[
					SimpleDialogOption(
						onPressed: () {Navigator.pop(context, true);},
						child: Text(actionText),
					),
					SimpleDialogOption(
						onPressed: () {Navigator.pop(context, false);},
						child: Text('Cancel'),
					),
				],
			);
			}
		)) {
			case true:
				setState(() {
					if (alreadySaved) {
						_saved.remove(pair);
					} else { 
						_saved.add(pair); 
					} 
				});
			// dialog dismissed
			break;
			case false:
			// dialog dismissed
			break;
		}
	}

	Widget _buildItem(Item item){
		final alreadySaved = _saved.contains(item);
		return ListTile(
			leading: new Image.asset('./assets/' + ItemInfo.images[item.productId]),
			title: Text(
				item.brand + " " + ItemInfo.productType[item.productId],
				style: TextStyle(fontSize: 18.0),
			),
			subtitle: Text("R\$" + item.price.toStringAsFixed(2)),
			trailing: TextButton(
				child: Icon(
					alreadySaved ? Icons.add_shopping_cart : Icons.add_shopping_cart,
					color: alreadySaved ? Colors.green : Colors.black,
				),
				onPressed: () {
					_addToCart(alreadySaved, item);
				},
			),
		);
	}

  	@override
    Widget build(BuildContext context) {
		_totalPrice = 0.0;
		final tiles = <Widget>{};
		_saved.forEach((item) {
			tiles.add(_buildItem(item));
			_totalPrice = _totalPrice + item.price;
		});

		final divided = ListTile.divideTiles(
			context: context,
			tiles: tiles,
		).toList();

		return Scaffold(
			appBar: AppBar(
				title: Text("Shopping Cart"),
				leading: new IconButton(
					icon: new Icon(Icons.arrow_back),
					onPressed: () {
						Navigator.push(
							context, MaterialPageRoute(builder: (context) => ShoppingItems()),
						);
					},
				),
			),
			body: ListView(children: divided),
			bottomNavigationBar: BottomAppBar(
				color: Colors.red,
				child: Column(
					mainAxisSize: MainAxisSize.min,
					children: [
						Row(
							mainAxisAlignment: MainAxisAlignment.center,
							children: [
								Text(
									"Total Price: R\$ " + _totalPrice.toStringAsFixed(2),
									style: TextStyle(fontSize: 18, fontWeight: FontWeight.w200, color: Colors.white),
								),
							],
						),
						Row(
							mainAxisAlignment: MainAxisAlignment.center,
							children: [
								Text(
									"Your Balance: R\$ " + _balance.toStringAsFixed(2),
									style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200, color: Colors.white),
								),
							],
						),
						Row(
							mainAxisAlignment: MainAxisAlignment.center,
							children: [
								IconButton(icon: Icon(Icons.shopping_basket, color: Colors.white,), onPressed: _checkout),
								IconButton(icon: Icon(Icons.clear, color: Colors.white,), onPressed: _clearCart),
							],
						),
						
					],
				),
			),
		);
	}
}