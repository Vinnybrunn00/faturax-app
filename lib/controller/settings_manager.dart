import 'package:faturax_app/constants/constants_color.dart';
import 'package:faturax_app/navigators/navigators_app.dart';
import 'package:faturax_app/repository/product_repository.dart';
import 'package:faturax_app/repository/user_repository.dart';
import 'package:faturax_app/ui/helpers/helpers.dart';
import 'package:faturax_app/ui/pages/log_page.dart';
import 'package:faturax_app/ui/pages/ranking_page.dart';
import 'package:flutter/material.dart';
import 'package:iconsx_plus/iconsx_plus.dart';
import 'package:provider/provider.dart';

class SettingsManager {
  final NavigatorsApp _navigatorsApp = NavigatorsApp();
  final Helpers _helpers = Helpers();

  List<Map<String, dynamic>> settingsOptions(BuildContext context) {
    final List<Map<String, dynamic>> options = [
      {
        'title': Text('Devedores'),
        'onTap': () => _pushRanking(context),
        'leading': Icon(Icons.attach_money_rounded, color: AppColor.greenColor),
      },
      {
        'title': Text('Logs'),
        'onTap': () => _pushLogs(context),
        'leading': Icon(BoxIcons.bx_terminal, color: AppColor.blackBlue),
      },
      {
        'title': Text('Sair da conta'),
        'onTap': () => _signOut(context),
        'leading': Icon(Icons.logout, color: AppColor.redColor),
      },
    ];

    return options;
  }

  void _pushLogs(BuildContext context) async {
    final UserRepository user = _userProvider(context);

    if (!user.isOwner) {
      _showMsg(context);
    } else {
      await _navigatorsApp.push(context, LogPage());
    }
  }

  void _pushRanking(BuildContext context) async {
    final UserRepository user = _userProvider(context);

    if (!user.isOwner) {
      _showMsg(context);
    } else {
      await _navigatorsApp.push(context, RankingPage());
    }
  }

  void _signOut(BuildContext context) async {
    final ProductRepository product = context.read<ProductRepository>();
    final UserRepository user = _userProvider(context);

    product.changeLoading();

    await Future.delayed(Duration(seconds: 2));
    await user.signOut();

    product.changeLoading();
  }

  UserRepository _userProvider(BuildContext context) {
    return Provider.of<UserRepository>(context, listen: false);
  }

  void _showMsg(BuildContext context) {
    _helpers.showMessageInfo(
      context,
      message: 'Apenas Vinícius pode usar essa função.',
    );
  }
}
