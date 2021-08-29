import 'package:flutter/material.dart';

class CryptoCard extends StatelessWidget { // 코인하나의 가격을 표시하는 카드 위젯
  const CryptoCard({
    required Key key,
    required this.value,
    required this.selectedCurrency,
    required this.cryptoCurrency
  }) : super(key: key);

  final List<double> value;
  final String selectedCurrency;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0),
      child: Card(
        color: Colors.greenAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Column(
              children: <Widget>[
                Text(
                  '1 $cryptoCurrency = ${value[0]} $selectedCurrency',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '거래대금 : ≈ ${value[2].toStringAsFixed(2)}원',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 15.0),
                ),
                Text(
                  '${value[1].toStringAsFixed(3)}%',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: (value[1]) > 0.0 ? Colors.red : Colors.blue, // 등락률에 따라서 색변화
                  ),
                ),
              ]
          ),
        ),
      ),
    );
  }
}
