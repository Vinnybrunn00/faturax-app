import 'package:faturax_app/constants/constants_color.dart';
import 'package:faturax_app/repository/product_repository.dart';
import 'package:faturax_app/ui/widgets/box_circular_progress.dart';
import 'package:faturax_app/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.whiteColor),
        backgroundColor: AppColor.pupleColor,
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
                children: [
                  Consumer<UserRepository>(
                    builder: (context, user, child) {
                      return ListTile(
                        onTap: () async {
                          product.changeLoading();

                          await Future.delayed(Duration(seconds: 2));
                          await user.signOut();

                          product.changeLoading();
                        },
                        leading: Icon(Icons.logout, color: AppColor.redColor),
                        trailing: Icon(Icons.arrow_forward_ios, size: 15),
                        title: Text('Sair da conta'),
                      );
                    },
                  ),
                ],
              ),
              product.loading ? BoxCircularProgress() : SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }
}
