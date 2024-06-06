import 'package:buyapp/model/item.dart';
import 'package:buyapp/model/itemInfo.dart';
import 'package:flutter/material.dart';

class SuggestionItem extends StatelessWidget {
  const SuggestionItem({
    super.key,
    required this.context,
    required this.item,
    required this.saved,
    required this.addToCart,
  });

  final BuildContext context;
  final Item item;
  final Set<Item> saved;
  final Future<void> Function({required bool alreadySaved, required Item item}) addToCart;

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final alreadySaved = saved.contains(item);

    return Card(
      color: alreadySaved ? const Color(0xffe5e5e5) : Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => {
          addToCart(alreadySaved: alreadySaved, item: item),
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              './assets/' + ItemInfo.images[item.productId],
              fit: BoxFit.contain,
              height: (orientation == Orientation.portrait) ? 140.0 : 200.0,
              width: (orientation == Orientation.portrait) ? 140.0 : 200.0,
            ),
            Container(
              width: 150,
              child: Text(
                item.brand + " " + ItemInfo.productType[item.productId],
                style: TextStyle(
                  fontSize: (orientation == Orientation.portrait) ? 16 : 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              'R\$ ' + item.price.toStringAsFixed(2),
              style: TextStyle(
                fontSize: (orientation == Orientation.portrait) ? 16 : 18,
                fontWeight: FontWeight.w200,
                color: Colors.black.withOpacity(0.6),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.add_shopping_cart,
                color: alreadySaved ? Colors.green : Colors.black,
              ),
              onPressed: () {
                addToCart(alreadySaved: alreadySaved, item: item);
              },
            ),
          ],
        ),
      ),
    );
  }
}
