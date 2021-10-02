import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;
import 'Crypto_card.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'CoinList.dart';
import 'Theme.dart';
import 'package:flutter_svg/flutter_svg.dart';


class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'KRW'; // 가장 처음으로 선택되는 화폐단위
  bool saving = true; // modalprogress 를 위해서 사용되는 bool 타입 변수
  List<List<double>> value = []; //코인의 데이터들을 저장해줄 리스트의 리스트
  List<String> cryptonames = []; // 카드 이름들
  List<CryptoCard> cryptocards = []; // 전체 카드들
  List<CryptoCard> foundcards = []; // 검색할 카드들
  List<String> bookmarks =[]; // 0 1일로 boolean타입을 대체하여서 sharedpreference로 사용예정
  bool _visible = false; // 검색창 애니메이션 bool타입 초기 상태는 false
  final PageController pageController = PageController( initialPage: 0, );

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
      final prefs = await SharedPreferences.getInstance();
      prefs.setStringList("bookmark", bookmarks);

      setState(() {
        for (List<double> datas in data.values) {
          value.add(datas);
        }

        for (int index = 0; index < cryptoList.length; index++)
          cryptocards.add(CryptoCard(
              index: index,
              key: ValueKey(index),
              value: value[index],
              selectedCurrency: selectedCurrency,
              cryptoCurrency: cryptoList[index]));
        saving = false; //로딩을 끝내기 위해서 false로 변환
        foundcards = cryptocards; // 검색 리스트에 일단은 foundcards를 넣는다.
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


  void _runFilter(String enteredKeyword) { //검색 시스템
    List<CryptoCard> results = [];
    if (enteredKeyword.isEmpty) {
      // 검색창 비어있으면 전체리스트 출력
      results = cryptocards;
    } else {
          for(CryptoCard crypto in cryptocards){
            if(crypto.cryptoCurrency.toLowerCase().contains(enteredKeyword.toLowerCase()))
              results.add(crypto);
          }
     //  toLowerCase함수를 통해 소문자까지 커버
    }
    setState(() {
      foundcards = results; // 리스트 교체
    });

  }


  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100.0),
            child: AppBar(
              title: Text(
               'Crypto Stream',
                style: pagetitleStyle,
              ),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              bottom: TabBar(
                indicatorColor: Colors.black,
                labelStyle: tablabelStyle,
                unselectedLabelStyle: unselectedtablabelStyle,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(text: 'Cypto Streams'),
                  Tab(text: 'My WatchList'),
                ],
              ),
              actions: [
                IconButton(
                  icon: SvgPicture.asset('images/searchicon.svg'
                    , color: Colors.black,
                  ),
                  onPressed: () {
                    // Call setState. This tells Flutter to rebuild the
                    // UI with the changes.
                    setState(() {
                      // 검색창 비어있으면 전체리스트 출력
                      foundcards = cryptocards; // 검색창을 출력할때마다 전체리스트로 변경
                      // 검색창에 어떤 검색어를 입력하고 검색창을 닫아버리면 해당 검색 결과가
                      //지속해서 출력되는 오류가 있었음
                      _visible = !_visible;
                    });
                  }
                ),
                IconButton(
                    icon: SvgPicture.asset('images/settingicon.svg',
                      color: Colors.black,
                    ),
                    onPressed: () => print('setting')),
              ],
            ),
          ),
          body: Column(
            children: [
              AnimatedOpacity( // 해당 위젯만 쓰게되면 gone상태
                opacity: _visible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Visibility( // visibility로 조합
                  visible: _visible,
                  child: Container(
                    margin: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                      color: Colors.black,
                      width: 2.5,
                    ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(15.0) //         <--- border radius here
                      ),
                    ),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
                      height: 30.0,
                      child: TextField(
                        onChanged: (value) => _runFilter(value),// 상단의 runFilter함수를 달아줌
                        decoration: InputDecoration(
                            hintText: '  Input Symbol/Name',
                            hintStyle: hinttextStyle,
                            suffixIcon: Icon(Icons.search)),
                        style: searchtextStyle,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                ),
              ),
              // 검색창
              Expanded(
                child: TabBarView(
                  children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: 50.0,
                          child:
                      Text(
                          'Crypto Streams',
                          textAlign: TextAlign.center,
                          style: pagetitleStyle
                      ),
                        alignment: Alignment.center,
                      ),
                      Expanded(
                        child: ModalProgressHUD(
                          inAsyncCall: saving,
                          child:
                          //CoinList(value: value, selectedCurrency: selectedCurrency,),
                          ListView.builder(
                            //padding: const EdgeInsets.symmetric(horizontal: 40),
                            itemCount: foundcards.length,
                            itemBuilder: (BuildContext context, int index){
                              return foundcards[index];
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
                      Container(
                        height: 50.0,
                        child:
                        Text(
                            'My Watchlist',
                            textAlign: TextAlign.center,
                            style: pagetitleStyle
                        ),
                        alignment: Alignment.center,
                      ),
                      Expanded(
                        child: ModalProgressHUD(
                          inAsyncCall: saving,
                          child:
                          //CoinList(value: value, selectedCurrency: selectedCurrency,),
                          ListView.builder(
                            //padding: const EdgeInsets.symmetric(horizontal: 40),
                            itemCount: foundcards.length,
                            itemBuilder: (BuildContext context, int index){
                              return foundcards[index];
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ]),
              ),
            ]
          )
        )
      );
  }



}
