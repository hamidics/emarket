/*
  
 */

import 'package:eMarket/ui/pages/main/splash/splash_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:stacked/stacked.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  AnimationController _backgroundController;
  AnimationController _logoController;
  Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    _logoController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0.0),
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticIn,
    ));
  }

  @override
  void dispose() {
    _logoController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SplashViewModel>.reactive(
      builder: (context, viewModel, child) => AnimatedBuilder(
        animation: _backgroundController,
        builder: (context, child) => Scaffold(
          key: viewModel.scaffoldKey,
          backgroundColor: viewModel.background
              .evaluate(AlwaysStoppedAnimation(_backgroundController.value)),
          body: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              SlideTransition(
                position: _offsetAnimation,
                child: Image.asset(
                  'asset/images/logo-mini.png',
                  scale: 1.5,
                ),
              ),
              Positioned(
                bottom: 20,
                child: SpinKitChasingDots(
                  color: viewModel.progress.evaluate(
                      AlwaysStoppedAnimation(_backgroundController.value)),
                ),
              )
            ],
          ),
        ),
      ),
      viewModelBuilder: () => SplashViewModel(),
      onModelReady: (viewModel) => viewModel.initialize(),
    );
  }
}
