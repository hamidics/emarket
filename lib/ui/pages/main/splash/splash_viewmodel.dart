/*
  
 */

import 'dart:async';

import 'package:eMarket/core/utilities/base_logic_viewmodel.dart';
import 'package:eMarket/ui/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashViewModel extends BaseLogicViewModel {
  Animatable<Color> background = TweenSequence<Color>(
    [
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: ThemeColors.Orange,
          end: Colors.white,
        ),
      ),
    ],
  );

  Animatable<Color> progress = TweenSequence<Color>(
    [
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: Colors.white,
          end: ThemeColors.Orange,
        ),
      ),
    ],
  );

  void initialize() async {
    await checkInternet();
    await notificationService.initialize();

    if (isConnected) {
      Timer(Duration(seconds: 5), () {
        SharedPreferences.getInstance().then((value) {
          if (value.getString('userId') != null) {
            navigationService.pushReplacement('home');
          } else {
            navigationService.pushReplacement('login');
          }
        });
      });
    } else {
      Timer(Duration(seconds: 2), () {
        showError('لطفا از ارتباط دستگاه به اینترنت مطمئن شوید.');
      });
    }
  }
}
