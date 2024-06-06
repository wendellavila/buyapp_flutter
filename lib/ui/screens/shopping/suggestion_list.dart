import 'dart:math';
import 'package:buyapp/model/item.dart';
import 'package:buyapp/model/itemInfo.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

import 'suggestion_item.dart';

class SuggestionList extends StatelessWidget {
  const SuggestionList({
    super.key,
    required this.context,
    required this.suggestions,
    required this.saved,
    required this.addToCart,
  });

  final BuildContext context;
  final List<Item> suggestions;
  final Set<Item> saved;
  final Future<void> Function({required bool alreadySaved, required Item item}) addToCart;

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final random = new Random();

    return GridView.builder(
      padding: EdgeInsets.all(16.0),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 260.0,
        childAspectRatio: (orientation == Orientation.portrait) ? 0.75 : 0.65,
      ),
      itemBuilder: (context, i) {
        if (i >= suggestions.length) {
          suggestions.add(
            Item(
              random.nextInt(ItemInfo.productType.length),
              WordPair.random().asPascalCase,
              random.nextDouble() * 400,
            ),
          );
        }
        return SuggestionItem(context: context, item: suggestions[i], saved: saved, addToCart: addToCart);
      },
    );
  }
}
