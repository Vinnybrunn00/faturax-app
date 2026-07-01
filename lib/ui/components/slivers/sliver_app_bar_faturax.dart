import 'package:faturax_app/constants/constants_color.dart';
import 'package:faturax_app/viewmodels/home_view_model.dart';
import 'package:faturax_app/repository/user_repository.dart';
import 'package:faturax_app/repository/product_repository.dart';
import 'package:provider/provider.dart';
import 'widgets/box_info_billings.dart';
import 'package:flutter/material.dart';

class SliverAppBarFuturax extends StatelessWidget {
  const SliverAppBarFuturax({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Consumer3<UserRepository, ProductRepository, UserView>(
      builder: (context, userRepository, product, userView, _) {
        return SliverAppBar(
          expandedHeight: 260,
          collapsedHeight: 115,
          pinned: true,
          backgroundColor: AppColor.purpleColor,
          title: Text('Olá, ${userRepository.username}'),
          actions: [
            AnimatedOpacity(
              opacity: userView.colapsed ? 1 : 0,
              duration: Duration(milliseconds: 450),
              child: Column(
                mainAxisAlignment: .center,
                children: [
                  AnimatedContainer(
                    padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                    duration: Duration(milliseconds: 550),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColor.greenColor.withAlpha(133),
                      ),
                    ),
                    child: Text(
                      userRepository.notVisibility
                          ? '****'
                          : product.convertCentInReais(product.price),
                      style: TextStyle(
                        color: AppColor.greenColor,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          actionsPadding: EdgeInsets.only(right: 20),
          titleTextStyle: TextStyle(color: AppColor.whiteColor, fontSize: 21),
          flexibleSpace: FlexibleSpaceBar(
            background: Column(
              mainAxisAlignment: .end,
              children: [BoxInfoBillings()],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(0.0),
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 8),
              width: size.width,
              decoration: BoxDecoration(
                color: AppColor.backgroundColorWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
              ),
              child: Text(
                'Suas Compras',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        );
      },
    );
  }
}
