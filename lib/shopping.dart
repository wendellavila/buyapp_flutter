import 'dart:math';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

import 'package:buyapp/item.dart';
import 'package:buyapp/itemInfo.dart';
import 'package:buyapp/profile.dart';
import 'package:buyapp/cart.dart';

class ShoppingItems extends StatefulWidget {
	@override
	_ShoppingItemsState createState() => _ShoppingItemsState();
}

class _ShoppingItemsState extends State<ShoppingItems> {
	final _suggestions = <Item>[];
	final _saved = <Item>{};
	final _random = new Random();
	double balance = 1000.00;

	Widget _buildSuggestions() {
		final Orientation orientation = MediaQuery.of(context).orientation;
		return GridView.builder(
			
			padding: EdgeInsets.all(16.0),
			gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
				crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
				childAspectRatio: (orientation == Orientation.portrait) ? 0.62 : 1.3,
			),
			itemBuilder: (context, i) {
				if (i >= _suggestions.length) {
					_suggestions.add(
						Item(
							_random.nextInt(ItemInfo.productType.length),
							WordPair.random().asPascalCase,
							_random.nextDouble()*400
						)
					);
				}
				return _buildItem(_suggestions[i]);
			}
		);
	}

	Widget _buildItem(Item item) {
		final Orientation orientation = MediaQuery.of(context).orientation;
		final alreadySaved = _saved.contains(item);
		return GestureDetector(
			onTap: () => {_addToCart(alreadySaved, item)},
			child: Card(
				color: alreadySaved ? const Color(0xffe5e5e5) : Colors.white,
				child: Column(
					mainAxisSize: MainAxisSize.min,
					children: [
						Row (
							mainAxisAlignment: MainAxisAlignment.center,
							children: [
								new Image.asset('./assets/' + ItemInfo.images[item.productId],
								fit: BoxFit.contain,
								height: (orientation == Orientation.portrait) ? 140.0 : 200.0,
								width: (orientation == Orientation.portrait) ? 140.0 : 200.0),
							]
						),
						Row (
							mainAxisAlignment: MainAxisAlignment.center,
							children: [
								Container(
									width: 150,
									child: Text(
										item.brand + " " + ItemInfo.productType[item.productId],
										style: TextStyle(fontSize: (orientation == Orientation.portrait) ? 16 : 20,
										fontWeight: FontWeight.bold, color: Colors.red),
										textAlign: TextAlign.center,
									),
								)
							],
						),
						Row (
							mainAxisAlignment: MainAxisAlignment.center,
							children: [
								Text(
									'R\$ ' + item.price.toStringAsFixed(2),
									style: TextStyle(fontSize: (orientation == Orientation.portrait) ? 16 : 18,
									fontWeight: FontWeight.w200, color: Colors.black.withOpacity(0.6)),
								),
							],
						),
						Row (
							mainAxisAlignment: MainAxisAlignment.center,
							children: [
								TextButton(
									child: Icon(
										Icons.add_shopping_cart,
										color: alreadySaved ? Colors.green : Colors.black,
									),
									onPressed: () {
										_addToCart(alreadySaved, item);
									},
								),
							],
						),
					],
				),
			),
		);
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

	void _pushCart() {
		Navigator.push(
        	context, MaterialPageRoute(builder: (context) => Cart(balance, _saved))
		);
	}

	void _pushProfile() {
		Navigator.push(
        	context, MaterialPageRoute(builder: (context) => Profile(balance))
		);
	}

  	@override
    Widget build(BuildContext context) {
      	return Scaffold(
			appBar: AppBar(
				title: Row(children: <Widget>[Icon(Icons.shopping_bag_sharp), Text("BuyApp")]),
				actions: [
					IconButton(icon: Icon(Icons.person), onPressed: _pushProfile),
					IconButton(icon: Icon(Icons.shopping_cart), onPressed: _pushCart),
				],
			),
			body: _buildSuggestions(),
		);
    }
}