

import 'package:eMarket/ui/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, viewModel, child) => Scaffold(
        body: PersistentTabView(
          context,
          controller: viewModel.controller,
          screens: viewModel.buildScreens(),
          items: viewModel.navBarItems(),
          confineInSafeArea: true,
          backgroundColor: ThemeColors.Orange,
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: true,
          stateManagement: true,
          hideNavigationBarWhenKeyboardShows: true,
          hideNavigationBar: false,
          margin: EdgeInsets.all(0.0),
          popActionScreens: PopActionScreensType.once,
          bottomScreenMargin: 0.0,
          decoration: NavBarDecoration(
            colorBehindNavBar: Colors.pink,
            borderRadius: BorderRadius.circular(0.0),
          ),
          popAllScreensOnTapOfSelectedTab: true,
          itemAnimationProperties: ItemAnimationProperties(
            duration: Duration(milliseconds: 400),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: ScreenTransitionAnimation(
            animateTabTransition: false,
            curve: Curves.ease,
            duration: Duration(milliseconds: 200),
          ),
          navBarStyle: NavBarStyle.style9,
        ),
      ),
      viewModelBuilder: () => HomeViewModel(),
      // onModelReady: (viewModel) => viewModel.initialize(),
    );
  }
}
