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
  List<Widget> cryptocards = [];
  List<String> bookmarks =[]; // 0 1일로 boolean타입을 대체하여서 sharedpreference로 사용예정


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
                  onPressed: () => print('search'),
                ),
                IconButton(
                    icon: SvgPicture.asset('images/settingicon.svg',
                      color: Colors.black,
                    ),
                    onPressed: () => print('setting')),
              ],
            ),
          ),
          body: TabBarView(
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
          ]),
        )
      );
  }
}
