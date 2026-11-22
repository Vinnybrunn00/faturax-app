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
import 'package:material_ui/material_ui.dart';

class BoxInfoBillings extends StatelessWidget {
  BoxInfoBillings({super.key});

  final NavigatorsApp _navigatorsApp = NavigatorsApp();

  Color? setColor(int diference) {
    if (diference > 0) {
      return AppColor.greenColor;
    }

    if (diference < 0) {
      return AppColor.redColor;
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
      padding: EdgeInsets.only(left: 16, right: 16),
      margin: EdgeInsets.only(bottom: 58),
      height: size.height * .175,
      width: size.width * .94,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColor.backgroundPurpleColor,
            AppColor.backgroundPurpleColor.withAlpha(215),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.whiteColor.withAlpha(28)),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: Offset(0, 6),
            color: Colors.black.withAlpha(35),
          ),
        ],
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
                          color: AppColor.whiteColor.withAlpha(190),
                          fontSize: 13,
                          fontWeight: .w500,
                          letterSpacing: 0.2,
                        ),
                      ),
                      Row(
                        spacing: 8,
                        children: [
                          ButtonLowBoxInfo(
                            icon: userModel.notVisibility
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            iconColor: Colors.white,
                            size: 18,
                            onTap: () => userModel.setVisibity(),
                          ),

                          ButtonLowBoxInfo(
                            icon: Icons.settings_outlined,
                            iconColor: Colors.white,
                            size: 18,
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
                  SizedBox(height: 2),
                  Row(
                    spacing: 8,
                    crossAxisAlignment: .center,
                    children: [
                      Text(
                        userModel.notVisibility
                            ? 'R\$ ••••'
                            : product.convertCentInReais(product.price),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: .w700,
                          letterSpacing: -0.5,
                          height: 1,
                        ),
                      ),
                      if (!userModel.notVisibility)
                        Container(
                          padding: EdgeInsets.fromLTRB(6, 2, 8, 2),
                          decoration: BoxDecoration(
                            color: AppColor.whiteColor.withAlpha(25),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              setIcon(diference) != null
                                  ? Icon(
                                      setIcon(diference),
                                      size: 15,
                                      color: setColor(diference),
                                    )
                                  : SizedBox(width: 2),
                              Text(
                                product.convertCentInReais(
                                  afterMonth.price - product.price,
                                ),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: .w600,
                                  color: setColor(diference),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(8, 4, 10, 4),
                          decoration: BoxDecoration(
                            color: AppColor.yellowColor220.withAlpha(30),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: .min,
                            spacing: 5,
                            children: [
                              Icon(
                                Icons.event_outlined,
                                size: 14,
                                color: AppColor.yellowColor220,
                              ),
                              Flexible(
                                child: Text(
                                  'Previsto para ${datePicker.dateTimeFormat(DateTime.now())}: ${userModel.notVisibility ? '••••' : product.convertCentInReais(afterMonth.price)}',
                                  overflow: .ellipsis,
                                  style: TextStyle(
                                    color: AppColor.yellowColor220,
                                    fontSize: 12,
                                    fontWeight: .w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        spacing: 6,
                        children: [
                          Text(
                            'Crédito',
                            style: TextStyle(
                              color: AppColor.whiteColor.withAlpha(200),
                              fontSize: 12,
                              fontWeight: .w500,
                            ),
                          ),
                          Image.asset('assets/icons/mastercard.png', width: 30),
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
