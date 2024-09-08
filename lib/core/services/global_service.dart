/*
  
 */

import 'package:eMarket/ui/pages/main/home/home_viewmodel.dart';

abstract class GlobalService {
  String apiUrl;
  String consumerKey;
  String secretCode;
  String authenticationUrl;
  String wpUrl;

  HomeViewModel homeViewModel;

  String generateUrl(String endPoint);

  String addKeys(String url);

  String authorizationHeader();
}
