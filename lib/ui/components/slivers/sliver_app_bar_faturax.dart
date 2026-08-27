import 'package:faturax_app/constants/constants_color.dart';
import 'package:faturax_app/ui/pages/home_page.dart';
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
    return Consumer4<UserRepository, ProductRepository, UserView, ChangePage>(
      builder: (context, userRepository, product, userView, changePage, _) {
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
            preferredSize: Size.fromHeight(0),
            child: Container(
              padding: .only(left: 10, right: 10, top: 5, bottom: 0),
              width: size.width,
              decoration: BoxDecoration(
                color: Color(0xffF6F8FA),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
                border: Border.all(color: Color(0xffd1d9e0)),
              ),
              child: Row(
                mainAxisAlignment: .spaceAround,
                children: changePage.pages.asMap().entries.map((entry) {
                  final String title = entry.value['title']!;

                  final bool selected = changePage.index == entry.key;

                  return Material(
                    child: Column(
                      spacing: 2,
                      children: [
                        InkWell(
                          onTap: selected
                              ? null
                              : () => changePage.changePage(entry.key),
                          borderRadius: BorderRadius.circular(12),
                          child: Ink(
                            padding: .fromLTRB(15, 8, 15, 8),
                            width: size.width * .4,
                            decoration: BoxDecoration(
                              color: Color(0xffF6F8FA),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                title,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: selected ? .w600 : .w300,
                                ),
                              ),
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          height: selected ? 2 : 0,
                          width: size.width * .4,
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColor.purpleColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
