import 'package:flutter/material.dart';
import 'Crypto_card.dart';
import 'coin_data.dart';

class CoinList extends StatefulWidget{
  const CoinList({
    required this.value,
    required this.selectedCurrency,
  });

  final List<List<double>> value;
  final String selectedCurrency;
  @override
  State<CoinList> createState() => _CoinList();

}

class _CoinList extends State<CoinList> {

  //final List<CryptoCard> _items = List<CryptoCard>.generate(cryptoList.length, (int index) =>CryptoCard(value: super.value[index], selectedCurrency: selectedCurrency, cryptoCurrency: cryptoCurrency));

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: ReorderableListView(
        //padding: const EdgeInsets.symmetric(horizontal: 40),
        children: <Widget>[
          for (int index = 0; index < cryptoList.length; index++)
            CryptoCard(key: ValueKey(index), value: widget.value[index], selectedCurrency: widget.selectedCurrency, cryptoCurrency: cryptoList[index])
        ],

        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            // final int item = _items.removeAt(oldIndex);
            // _items.insert(newIndex, item);
          });
        },
      ),
    );
  }
}
