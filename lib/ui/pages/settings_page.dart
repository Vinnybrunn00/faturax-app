import 'package:faturax_app/constants/constants_color.dart';
import 'package:faturax_app/controller/settings_manager.dart';
import 'package:faturax_app/repository/product_repository.dart';
import 'package:faturax_app/ui/widgets/box_circular_progress.dart';
import 'package:faturax_app/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final SettingsManager _settingsManager = SettingsManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.whiteColor),
        backgroundColor: AppColor.purpleColor,
        title: Consumer<UserRepository>(
          builder: (context, user, _) {
            return Text(user.username.toString());
          },
        ),
        titleTextStyle: TextStyle(color: AppColor.whiteColor, fontSize: 20),
      ),
      backgroundColor: AppColor.whiteColor,
      body: Consumer<ProductRepository>(
        builder: (context, product, _) {
          return Stack(
            children: [
              Column(
                children: _settingsManager
                    .settingsOptions(context)
                    .map(
                      (Map<String, dynamic> elements) => ListTile(
                        title: elements['title'],
                        onTap: elements['onTap'],
                        leading: elements['leading'],
                        trailing: Icon(Icons.arrow_forward_ios, size: 15),
                      ),
                    )
                    .toList(),
              ),
              product.loading ? BoxCircularProgress() : SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }
}
