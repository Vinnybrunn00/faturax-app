import 'package:faturax_app/constants/constants_color.dart';
import 'package:faturax_app/constants/constants_values.dart';
import 'package:faturax_app/controller/home_view_model.dart';
import 'package:faturax_app/viewmodels/date_picker.dart';
import 'package:faturax_app/repository/user_repository.dart';
import 'package:faturax_app/repository/product_repository.dart';
import 'package:provider/provider.dart';
import 'widgets/box_info_billings.dart';
import 'widgets/box_resume_month.dart';
import 'package:flutter/material.dart';

class SliverAppBarFuturax extends StatelessWidget {
  const SliverAppBarFuturax({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Consumer4<UserRepository, ProductRepository, DatePicker, UserView>(
      builder: (context, userRepository, product, datePicker, userView, _) {
        return SliverAppBar(
          expandedHeight: 260,
          collapsedHeight: 115,
          pinned: true,
          backgroundColor: AppColor.pupleColor,
          title: Text('Olá, ${userRepository.username}'),
          actions: [
            AnimatedOpacity(
              opacity: userView.colapsed ? 1 : 0,
              duration: Duration(milliseconds: 450),
              child: Column(
                mainAxisAlignment: .end,
                crossAxisAlignment: .center,
                children: [
                  Text(
                    userRepository.notVisibility
                        ? '****'
                        : product.convertCentInReais(product.price),
                    style: TextStyle(color: AppColor.whiteColor, fontSize: 16),
                  ),
                  BoxResumeMonth(month: showMonth),
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
                color: AppColor.whiteColor.withAlpha(230),
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
