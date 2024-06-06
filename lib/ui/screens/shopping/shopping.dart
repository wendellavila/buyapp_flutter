import 'package:flutter/material.dart';

import 'package:buyapp/model/item.dart';
import 'package:buyapp/ui/screens/profile/profile.dart';
import 'package:buyapp/ui/screens/cart/cart.dart';

import 'suggestion_list.dart';

class ShoppingScreen extends StatefulWidget {
  @override
  _ShoppingScreenState createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  final _suggestions = <Item>[];
  final _saved = <Item>{};
  double balance = 1000.00;

  Future<void> _addToCart({
    required bool alreadySaved,
    required Item item,
  }) async {
    String actionTitle;
    String actionText;
    if (alreadySaved) {
      actionTitle = 'Remove product from cart?';
      actionText = 'Remove from cart';
    } else {
      actionTitle = 'Add product to cart?';
      actionText = 'Add to cart';
    }

    bool? dialogResponse = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(actionTitle),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text(actionText),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text('Cancel'),
              ),
            ],
          );
        });

    if (dialogResponse == true) {
      setState(() {
        if (alreadySaved) {
          _saved.remove(item);
        } else {
          _saved.add(item);
        }
      });
    }
  }

  void _pushCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(balance, _saved),
      ),
    );
  }

  void _pushProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Profile(balance),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 4),
              child: Icon(Icons.shopping_bag_sharp),
            ),
            Text("BuyApp"),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: _pushProfile,
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: _pushCart,
          ),
        ],
      ),
      body: SuggestionList(
        context: context,
        suggestions: _suggestions,
        saved: _saved,
        addToCart: _addToCart,
      ),
    );
  }
}
