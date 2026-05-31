import 'package:faturax/constants/constants_color.dart';
import 'package:faturax/constants/constants_values.dart';
import 'package:faturax/models/product/new_product.dart';
import 'package:faturax/models/user/user_model.dart';
import 'package:faturax/ui/components/slivers/widgets/box_info_billings.dart';
import 'package:faturax/ui/components/slivers/widgets/box_resume_month.dart';
import 'package:flutter/material.dart';

class SliverAppBarFuturax extends StatelessWidget {
  final UserView userView;
  final UserModel userModel;
  final NewProduct product;

  const SliverAppBarFuturax({
    super.key,
    required this.userView,
    required this.userModel,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SliverAppBar(
      expandedHeight: 260,
      collapsedHeight: 115,
      pinned: true,
      backgroundColor: AppColor.pupleColor,
      title: Text('Olá, ${userModel.username}'),
      actions: [
        AnimatedOpacity(
          opacity: userView.colapsed ? 1 : 0,
          duration: Duration(milliseconds: 450),
          child: Column(
            mainAxisAlignment: .end,
            crossAxisAlignment: .center,
            children: [
              Text(
                product.convertCentInReais(product.price),
                style: TextStyle(color: AppColor.whiteColor, fontSize: 16),
              ),
              BoxResumeMonth(month: showMonth),
            ],
          ),
        ),
      ],
      actionsPadding: EdgeInsets.only(right: 20),
      titleTextStyle: TextStyle(fontSize: 21),
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          mainAxisAlignment: .end,
          children: [BoxInfoBillings(userModel: userModel, product: product)],
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
  }
}
