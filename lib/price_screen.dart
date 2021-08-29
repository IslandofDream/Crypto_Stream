import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;
import 'Crypto_card.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'CoinList.dart';
import 'Theme.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'KRW'; // 가장 처음으로 선택되는 화폐단위
  bool saving = true; // modalprogress 를 위해서 사용되는 bool 타입 변수
  List<List<double>> value = []; //코인의 데이터들을 저장해줄 리스트의 리스트
  List<Widget> cryptocards = [];
  List<double> Initvalue(int num) {
    try {
      return value[num];
    } catch (e) {
      List<double> list = [0.0, 0.0, 0.0];
      return list;
    }
  }

  void getData() async {
    // coindata 클래스를 통해서 코인데이터를 가져오는 함수
    try {
      Map data = await CoinData().getCoinData(selectedCurrency);

      setState(() {
        for (List<double> datas in data.values) {
          value.add(datas);
        }

        for (int index = 0; index < cryptoList.length; index++)
          cryptocards.add(CryptoCard(
              key: ValueKey(index),
              value: value[index],
              selectedCurrency: selectedCurrency,
              cryptoCurrency: cryptoList[index]));
        saving = false; //로딩을 끝내기 위해서 true로 변환
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }




  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController( initialPage: 0, );

    return Scaffold(
      appBar: AppBar(
        title: Text('Crypto Stream'),
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        // TODO: RefreshIndicator 혹은 다른 방식의 데이터 갱신 방식
        children: <Widget>[
      
          // Padding(
          //   padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0),
          //   child: TextField(
          //     decoration: InputDecoration(
          //         hintText: 'Search',
          //         hintStyle: TextStyle(color: Colors.black)),
          //   ),
          // ),
          Expanded(
            child: PageView(
              controller: pageController,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(child:
                      Text(
                        'Crypto Streams',
                        textAlign: TextAlign.start,
                        style: pagetitleStyle
                      )),
                      Expanded(
                        child: ModalProgressHUD(
                        inAsyncCall: saving,
                        child:
                        //CoinList(value: value, selectedCurrency: selectedCurrency,),
                        ReorderableListView(
                          //padding: const EdgeInsets.symmetric(horizontal: 40),
                          children: cryptocards,
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
                    ),
                      ),
                  ],
                  ),
                ),
                // page 1

                Expanded(
                  child: Column(
                    children: [
                      SizedBox(child:
                      Text(
                          'My Watchlist',
                          textAlign: TextAlign.left,
                          style: pagetitleStyle
                      )),
                      Expanded(
                        child: ModalProgressHUD(
                          inAsyncCall: saving,
                          child:
                          //CoinList(value: value, selectedCurrency: selectedCurrency,),
                          ReorderableListView(
                            //padding: const EdgeInsets.symmetric(horizontal: 40),
                            children: cryptocards,
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
                        ),
                      ),
                    ],
                  ),
                ),
                //page 2
              ]
            ),
          ),


          // CryptoCard(value: Initvalue(0) , selectedCurrency: selectedCurrency, cryptoCurrency: cryptoList[0],),
          // CryptoCard(value: Initvalue(1), selectedCurrency: selectedCurrency, cryptoCurrency: cryptoList[1],),
          // CryptoCard(value: Initvalue(2), selectedCurrency: selectedCurrency, cryptoCurrency: cryptoList[2],),
          // //CryptoCard(value: Initvalue(3), selectedCurrency: selectedCurrency, cryptoCurrency: cryptoList[3],),
          // CryptoCard(value: Initvalue(4), selectedCurrency: selectedCurrency, cryptoCurrency: cryptoList[4],),
        ],
      ),
    );
  }
}
