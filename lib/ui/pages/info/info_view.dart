/*
  
 */

import 'package:eMarket/ui/helpers/colors.dart';
import 'package:eMarket/ui/pages/info/info_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:stacked/stacked.dart';

class InfoView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InfoViewModel>.nonReactive(
        builder: (context, viewModel, child) => Scaffold(
              appBar: AppBar(
                title: Text('ارتباط با ما'),
              ),
              body: SafeArea(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: ListBody(
                        children: [
                          Image.asset(
                            'asset/images/logo-mini.png',
                            scale: 1.5,
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.info,
                              color: ThemeColors.Orange,
                            ),
                            title: Text(
                              'راه های ارتباطی با ما :',
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.call,
                              color: ThemeColors.Orange,
                            ),
                            title: Text(
                              'شماره تماس :',
                            ),
                            trailing: Text(
                              '+93 79 450 8080',
                              textDirection: TextDirection.ltr,
                              style: TextStyle(fontSize: 17),
                            ),
                            onTap: () => viewModel.call(),
                          ),
                          ListTile(
                            leading: Icon(
                              MdiIcons.telegram,
                              color: ThemeColors.Orange,
                            ),
                            title: Text(
                              'تلگرام :',
                            ),
                            trailing: Text(
                              '@emarketafghanistan',
                              textDirection: TextDirection.ltr,
                              style: TextStyle(fontSize: 17),
                            ),
                            onTap: () => viewModel.telegram(),
                          ),
                          ListTile(
                            leading: Icon(
                              MdiIcons.whatsapp,
                              color: ThemeColors.Orange,
                            ),
                            title: Text(
                              'واتز اپ :',
                            ),
                            trailing: Text(
                              '+93 79 450 8080',
                              textDirection: TextDirection.ltr,
                              style: TextStyle(fontSize: 17),
                            ),
                            onTap: () => viewModel.whatsapp(),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.location_on,
                              color: ThemeColors.Orange,
                            ),
                            title: Text(
                                'هرات، مارکت الماس شرق، طبقه چهارم پلاک ۹۹'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        viewModelBuilder: () => InfoViewModel());
  }
}
