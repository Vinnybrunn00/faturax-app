import 'package:faturax/constants/constants_color.dart';
import 'package:faturax/constants/constants_values.dart';
import 'package:faturax/models/product/new_product.dart';
import 'package:faturax/models/user/user_model.dart';
import 'package:faturax/ui/components/slivers/widgets/box_resume_month.dart';
import 'package:faturax/ui/components/slivers/widgets/button_low_box_info.dart';
import 'package:faturax/ui/pages/profile_page.dart';
import 'package:faturax/ui/pages/ranking_page.dart';
import 'package:flutter/material.dart';

class BoxInfoBillings extends StatelessWidget {
  final UserModel userModel;
  final NewProduct product;

  const BoxInfoBillings({
    super.key,
    required this.userModel,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15),
      margin: EdgeInsets.only(bottom: 60),
      height: size.height * .16,
      width: size.width * .95,
      decoration: BoxDecoration(
        color: Color(0xFF333EBF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: .center,
        crossAxisAlignment: .start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total a pagar no cartão',
                style: TextStyle(color: AppColor.yellowColor220, fontSize: 13),
              ),
              Row(
                spacing: 10,
                children: [
                  ButtonLowBoxInfo(
                    icon: Icons.person,
                    iconColor: Colors.white,
                    builder: (_) => ProfilePage(),
                  ),

                  ButtonLowBoxInfo(
                    isOwner: userModel.isOwner,
                    icon: Icons.attach_money,
                    iconColor: AppColor.greenColor,
                    builder: (_) => RankingPage(newProduct: product),
                  ),
                ],
              ),
            ],
          ),
          Text(
            product.convertCentInReais(product.price),
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              BoxResumeMonth(month: showMonth),
              Row(
                spacing: 10,
                children: [
                  Text(
                    'Crédito',
                    style: TextStyle(color: AppColor.whiteColor, fontSize: 14),
                  ),
                  Image.asset('assets/icons/mastercard.png', width: 35),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
