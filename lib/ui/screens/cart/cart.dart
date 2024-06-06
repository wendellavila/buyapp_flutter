import 'package:flutter/material.dart';

import 'package:buyapp/ui/screens/shopping/shopping.dart';
import 'package:buyapp/model/item.dart';

import 'cart_item.dart';

class CartScreen extends StatefulWidget {
  final double _balance;
  final Set<Item> _saved;
  CartScreen(this._balance, this._saved);

  @override
  _CartScreenState createState() => _CartScreenState(_balance, _saved);
}

class _CartScreenState extends State<CartScreen> {
  double _balance;
  double _totalPrice = 0.0;
  Set<Item> _saved = <Item>{};
  _CartScreenState(this._balance, this._saved);

  Future<void> _clearCart() async {
    bool? dialogResponse = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text("Clear cart?"),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text("Clear cart"),
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
        _saved.clear();
      });
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
    bool? dialogResponse = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text("Confirm purchase"),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text("Confirm purchase"),
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
        if (_balance - _totalPrice >= 0.0) {
          _balance = _balance - _totalPrice;
          _saved.clear();
          _checkoutSuccess();
        } else {
          _checkoutFail();
        }
      });
    }
  }

  Future<void> _addToCart({required bool alreadySaved, required Item item}) async {
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

  @override
  Widget build(BuildContext context) {
    _totalPrice = 0.0;
    final tiles = <Widget>{};
    _saved.forEach((item) {
      tiles.add(CartItem(item: item, saved: _saved, addToCart: _addToCart));
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
              context,
              MaterialPageRoute(builder: (context) => ShoppingScreen()),
            );
          },
        ),
      ),
      body: ListView(children: divided),
      bottomNavigationBar: BottomAppBar(
        color: Colors.red,
        height: 120,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Total Price: R\$ " + _totalPrice.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w200,
                color: Colors.white,
              ),
            ),
            Text(
              "Your Balance: R\$ " + _balance.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w200,
                color: Colors.white,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.shopping_basket,
                    color: Colors.white,
                  ),
                  onPressed: _checkout,
                ),
                IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                  onPressed: _clearCart,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
