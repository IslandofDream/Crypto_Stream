import 'dart:convert';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;

const List<String> currenciesList = [ //화폐 단위를 나타내는 리스트
  'KRW',
  'BTC'
  // 빗썸은 krw btc 외 지원하지 않음
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
  'XRP',
  'BCH',
  'QTUM',
  'BTG',
  'TRX',
  'ELF',
  'OMG',
  'KNC',
  'GLM',
  'ZIL',
  'WAXP',
  'POWR',
  'LRC',
];

const coinAPIURL = 'https://api.bithumb.com/public/ticker/';


//const apiKey = 'EE392200-9201-4407-82B8-36C7042E74EB'; 현재까지는 쓰임새를 모르겠다.

class CoinData {
  Future getCoinData(String selectedCurrency) async { //코인의 데이터를 받아온다.

    Map<String, List<double>> cryptoMap = {}; // 하나의 key 그리고 value를 집어넣는 List
    String requestURL = '$coinAPIURL/all_$selectedCurrency';
    http.Response response = await http.get(requestURL);
    for(String crypto in cryptoList){
      List<double> coindata = []; //하나의 코인에 대한 데이터들 list로 value를 넣어준다.

      if (response.statusCode == 200) { // statusCode 정상일 경우
        print(response.body);
        var decodedData = jsonDecode(response.body);

        var curPrice = decodedData['data'][crypto]['closing_price']; // 현재가
        var lastPrice = decodedData['data'][crypto]['fluctate_rate_24H']; // 24시간 변화율
        var tradeVal = decodedData['data'][crypto]['acc_trade_value_24H']; // 최근 24시간 거래량


        coindata.add(double.parse(curPrice));
        coindata.add(double.parse(lastPrice));
        coindata.add(double.parse(tradeVal));

        cryptoMap[crypto] = coindata;

        print(cryptoMap);
      } else {
        print(response.statusCode);
        throw '코인 정보를 불러 올 수 없습니다.';
      }
    }
    return  cryptoMap;
  }
}
