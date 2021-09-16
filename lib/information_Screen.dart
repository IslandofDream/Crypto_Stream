import 'package:crypto_stream/Crypto_card.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:crypto_stream/Theme.dart';
import 'package:crypto/crypto.dart';

class InformationScreen extends StatelessWidget {
  final int index;
  final List<double> value; // 코인의 정보들
  final String selectedCurrency; // 현금 단위
  final String cryptoCurrency; // 코인 화폐 단위

  const InformationScreen({Key? key, required this.index,
    required this.value,
    required this.selectedCurrency,
    required this.cryptoCurrency
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          cryptoList[index],
          style: pagetitleStyle,
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white ,
        child: SizedBox(
          height: 115,
          child: CryptoCard(
              index: index,
              key: ValueKey(index),
              value: this.value,
              selectedCurrency: this.selectedCurrency,
              cryptoCurrency: this.cryptoCurrency),
        ),
        ),
      );
  }
}
