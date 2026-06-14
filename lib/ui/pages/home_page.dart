import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faturax_app/constants/constants_color.dart';
import 'package:faturax_app/controller/home_view_model.dart';
import 'package:faturax_app/viewmodels/date_picker.dart';
import 'package:faturax_app/repository/user_repository.dart';
import 'package:faturax_app/repository/next_month_product.dart';
import 'package:faturax_app/repository/product_repository.dart';
import 'package:faturax_app/ui/components/slivers/sliver_app_bar_faturax.dart';
import 'package:faturax_app/ui/components/slivers/sliver_box_error.dart';
import 'package:faturax_app/ui/components/slivers/widgets/button_items_compras.dart';
import 'package:faturax_app/ui/modals/modal_new_compras.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ModalNewCompras _newCompras = ModalNewCompras();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Consumer3<ProductRepository, DatePicker, UserView>(
        builder: (context, product, datePicker, userView, _) {
          return AnimatedSlide(
            curve: Curves.easeInBack,
            offset: userView.colapsed ? const Offset(1.8, 0) : Offset.zero,
            duration: Duration(milliseconds: 450),
            child: Container(
              margin: EdgeInsets.all(12),
              child: Material(
                child: SizedBox(
                  height: 60,
                  width: 60,
                  child: InkWell(
                    onTap: () async => await _newCompras.showModalNewCompras(
                      context,
                      datePicker,
                      product,
                    ),
                    borderRadius: BorderRadius.circular(23),
                    child: Ink(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColor.pupleColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(Icons.add, color: AppColor.whiteColor),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),

      backgroundColor: Colors.white,
      body:
          Consumer5<
            ProductRepository,
            UserView,
            UserRepository,
            DatePicker,
            NextMonthProduct
          >(
            builder:
                (
                  context,
                  product,
                  userView,
                  userRepository,
                  datePicker,
                  afterMonth,
                  _,
                ) {
                  return CustomScrollView(
                    controller: userView.scrollController,
                    slivers: [
                      // appbar
                      SliverAppBarFuturax(),

                      //items
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: userRepository.items
                            .orderBy('timestamp', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          // se der erro, retorna um SliverBoxError
                          if (snapshot.hasError) {
                            return SliverBoxError(
                              widget: Text('Erro ao carregar dados'),
                            );
                          }

                          // enquanto carrega retorna um SliverBoxError
                          if (!snapshot.hasData) {
                            return SliverBoxError(
                              widget: CircularProgressIndicator(),
                            );
                          }

                          final List<
                            QueryDocumentSnapshot<Map<String, dynamic>>
                          >
                          docs = snapshot.data!.docs;

                          if (docs.isEmpty) {
                            return SliverBoxError(
                              widget: Text('Nenhuma compra encontrada'),
                            );
                          }

                          return SliverList.separated(
                            itemCount: docs.length,
                            separatorBuilder: (_, _) => Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 13,
                              ),
                              color: Colors.black.withAlpha(90),
                              height: .5,
                            ),
                            itemBuilder: (context, index) {
                              return ButtonItemsCompras(docs: docs[index]);
                            },
                          );
                        },
                      ),
                    ],
                  );
                },
          ),
    );
  }
}
