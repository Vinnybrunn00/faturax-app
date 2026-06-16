import 'package:faturax_app/constants/constants_color.dart';
import 'package:faturax_app/navigators/navigators_app.dart';
import 'package:faturax_app/viewmodels/date_picker.dart';
import 'package:faturax_app/repository/user_repository.dart';
import 'package:faturax_app/repository/next_month_product.dart';
import 'package:faturax_app/repository/product_repository.dart';
import 'package:faturax_app/ui/pages/settings_page.dart';
import 'package:iconsx_plus/iconsx_plus.dart';
import 'package:provider/provider.dart';
import 'button_low_box_info.dart';
import 'package:flutter/material.dart';

class BoxInfoBillings extends StatelessWidget {
  BoxInfoBillings({super.key});

  final NavigatorsApp _navigatorsApp = NavigatorsApp();

  Color? setColor(int diference) {
    if (diference > 0) {
      return AppColor.greenColor;
    }

    if (diference < 0) {
      return Color(0xFFFF3300);
    }
    return AppColor.whiteColor.withAlpha(200);
  }

  IconData? setIcon(int diference) {
    if (diference > 0) {
      return BoxIcons.bx_up_arrow_alt;
    }

    if (diference < 0) {
      return BoxIcons.bx_down_arrow_alt;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(left: 13, right: 13),
      margin: EdgeInsets.only(bottom: 58),
      height: size.height * .175,
      width: size.width * .95,
      decoration: BoxDecoration(
        color: Color(0xFF333EBF),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(blurRadius: 8, color: Color(0xFF333EBF))],
      ),
      child:
          Consumer4<
            NextMonthProduct,
            ProductRepository,
            UserRepository,
            DatePicker
          >(
            builder: (context, afterMonth, product, userModel, datePicker, _) {
              final int diference = (afterMonth.price - product.price);

              return Column(
                mainAxisAlignment: .center,
                crossAxisAlignment: .start,
                spacing: 3,
                children: [
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(
                        'Total a pagar no mês atual',
                        style: TextStyle(
                          color: AppColor.whiteColor.withAlpha(180),
                          fontSize: 13,
                        ),
                      ),
                      Row(
                        spacing: 10,
                        children: [
                          ButtonLowBoxInfo(
                            icon: Icons.visibility,
                            iconColor: Colors.white,
                            onTap: () => userModel.setVisibity(),
                          ),

                          ButtonLowBoxInfo(
                            icon: Icons.settings,
                            iconColor: Colors.white,
                            onTap: () async {
                              await _navigatorsApp.push(
                                context,
                                SettingsPage(),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    spacing: 5,
                    children: [
                      Text(
                        userModel.notVisibility
                            ? '****'
                            : product.convertCentInReais(product.price),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          height: 1,
                        ),
                      ),
                      Row(
                        children: [
                          if (!userModel.notVisibility)
                            setIcon(diference) != null
                                ? Icon(
                                    setIcon(diference),
                                    size: 17,
                                    color: setColor(diference),
                                  )
                                : SizedBox.shrink(),
                          Text(
                            userModel.notVisibility
                                ? '****'
                                : product.convertCentInReais(
                                    afterMonth.price - product.price,
                                  ),
                            style: TextStyle(
                              fontSize: 12,
                              color: userModel.notVisibility
                                  ? Colors.grey
                                  : setColor(diference),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 7),
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColor.yellowColor220,
                            width: .7,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Valor previsto para ${datePicker.dateTimeFormat(DateTime.now())} ',
                              style: TextStyle(
                                color: AppColor.yellowColor220,
                                fontSize: 12,
                                fontWeight: .w500,
                              ),
                            ),
                            Text(
                              userModel.notVisibility
                                  ? '****'
                                  : product.convertCentInReais(
                                      afterMonth.price,
                                    ),
                              style: TextStyle(
                                color: AppColor.yellowColor220,
                                fontSize: 12,
                                fontWeight: .w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        spacing: 6,
                        children: [
                          Text(
                            'Crédito',
                            style: TextStyle(
                              color: AppColor.whiteColor,
                              fontSize: 14,
                            ),
                          ),
                          Image.asset('assets/icons/mastercard.png', width: 35),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
    );
  }
}
