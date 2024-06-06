import 'package:buyapp/model/item.dart';
import 'package:buyapp/model/itemInfo.dart';
import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    super.key,
    required this.item,
    required this.saved,
    required this.addToCart,
  });

  final Item item;
  final Set<Item> saved;
  final Future<void> Function({required bool alreadySaved, required Item item}) addToCart;

  @override
  Widget build(BuildContext context) {
    final alreadySaved = saved.contains(item);
    return ListTile(
      leading: Image.asset(
        './assets/' + ItemInfo.images[item.productId],
        width: 50,
      ),
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
          addToCart(alreadySaved: alreadySaved, item: item);
        },
      ),
    );
  }
}
