import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'information_Screen.dart';


class CryptoCard extends StatefulWidget { // 코인하나의 가격을 표시하는 카드 위젯
  const CryptoCard({
    required Key key,
    required this.index,
    required this.value,
    required this.selectedCurrency,
    required this.cryptoCurrency
  }) : super(key: key);

  final int index; // 상세화면을 위한 index
  final List<double> value; // 코인의 정보들
  final String selectedCurrency; // 현금 단위
  final String cryptoCurrency; // 현재 코인 단위
  @override
  _CryptoCardState createState() => _CryptoCardState();

}

class _CryptoCardState extends State<CryptoCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0),
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InformationScreen(index: this.widget.index, value: this.widget.value, selectedCurrency: this.widget.selectedCurrency, cryptoCurrency: this.widget.cryptoCurrency,))
        ),
        child: Card(
          color: Colors.greenAccent,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '1 ${widget.cryptoCurrency} = ${widget.value[0]} ${widget.selectedCurrency}',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${widget.value[1].toStringAsFixed(3)}%',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: (widget.value[1]) > 0.0 ? Colors.red : Colors.blue, // 등락률에 따라서 색변화
                        fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  Text(
                    '거래대금 : ≈ ${widget.value[2].toStringAsFixed(2)}원',
                    style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black
                    ),
                    textAlign: TextAlign.start,
                  ),

                ]
            ),
          ),
        ),
      ),
    );
  }



}
