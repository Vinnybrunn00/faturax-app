import 'package:faturax/constants/constants_color.dart';
import 'package:faturax/models/user/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.whiteColor),
        backgroundColor: AppColor.pupleColor,
        title: Text(user.username.toString()),
        titleTextStyle: TextStyle(color: AppColor.whiteColor, fontSize: 20),
      ),
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: [
          ListTile(
            onTap: () async => await user.signOut(),
            leading: Icon(Icons.logout, color: AppColor.redColor),
            trailing: Icon(Icons.arrow_forward_ios, size: 15),
            title: Text('Sair da conta'),
          ),
        ],
      ),
    );
  }
}
