/*
  
 */

import 'dart:convert';

import 'package:eMarket/core/services/global_service.dart';
import 'package:eMarket/ui/pages/main/home/home_viewmodel.dart';

class GlobalServiceController implements GlobalService {
  @override
  String apiUrl = 'https://www.emarket.af/wp-json/wc/v3/';

  @override
  String consumerKey = 'ck_549adccd17bd6b5f2a52742bce493462575fca34';

  @override
  String secretCode = 'cs_efc6a426118ace28bb4baf48bafe568f886a9dc3';

  @override
  String authenticationUrl = 'https://www.emarket.af/wp-json/digits/v1/';

  @override
  String wpUrl = 'https://www.emarket.af/wp-json/wp/v2/';

  @override
  HomeViewModel homeViewModel;

  @override
  String generateUrl(String endPoint) {
    var url = apiUrl +
        endPoint +
        '?consumer_key=' +
        consumerKey +
        '&consumer_secret=' +
        secretCode;
    return url;
  }

  @override
  String addKeys(String url) {
    url =
        url + 'consumer_key=' + consumerKey + '&consumer_secret=' + secretCode;
    return url;
  }

  @override
  String authorizationHeader() =>
      'Basic ' + base64Encode(utf8.encode('$consumerKey:$secretCode'));
}
