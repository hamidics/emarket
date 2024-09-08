/*
  
 */

import 'package:eMarket/core/utilities/base_logic_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoViewModel extends BaseLogicViewModel {
  void call() {
    _launch('tel:+93794508080');
  }

  void telegram() {
    _launch('https://t.me/emarketafghanistan');
  }

  void whatsapp() {
    _launch('https://wa.me/93794508080');
  }

  void _launch(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
