import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faturax/constants/constants_color.dart';
import 'package:faturax/models/product/new_product.dart';
import 'package:faturax/models/user/user_model.dart';
import 'package:faturax/ui/widgets/event_button.dart';
import 'package:faturax/ui/components/slivers/sliver_app_bar_faturax.dart';
import 'package:faturax/ui/components/slivers/sliver_box_error.dart';
import 'package:faturax/ui/components/slivers/widgets/button_items_compras.dart';
import 'package:faturax/utils/new_compras.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final NewCompras _newCompras = NewCompras();

  @override
  Widget build(BuildContext context) {
    final NewProduct product = Provider.of<NewProduct>(context);
    final UserModel userModel = Provider.of<UserModel>(context);
    final UserView userView = Provider.of<UserView>(context);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: AnimatedSlide(
        curve: Curves.easeIn,
        offset: userView.colapsed ? const Offset(0, 1.5) : Offset.zero,
        duration: Duration(milliseconds: 350),
        child: Container(
          margin: EdgeInsets.all(12),
          child: Material(
            child: EventButton(
              onTap: () async => await _newCompras.showModal(context, product),
              icon: Icons.add,
              color: AppColor.pupleColor,
              title: 'Nova Compra',
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: userView.scrollController,
        slivers: [
          // appbar
          SliverAppBarFuturax(
            userView: userView,
            userModel: userModel,
            product: product,
          ),

          //items
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: userModel.items
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              // se der erro, retorna um SliverBoxError
              if (snapshot.hasError) {
                return SliverBoxError(widget: Text('Erro ao carregar dados'));
              }

              // enquanto carrega retorna um SliverBoxError
              if (!snapshot.hasData) {
                return SliverBoxError(widget: CircularProgressIndicator());
              }

              final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
                  snapshot.data!.docs;

              if (docs.isEmpty) {
                return SliverBoxError(
                  widget: Text('Nenhuma compra encontrada'),
                );
              }

              return SliverList.separated(
                itemCount: docs.length,
                separatorBuilder: (_, _) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 13),
                  color: Colors.black.withAlpha(90),
                  height: .5,
                ),
                itemBuilder: (context, index) {
                  return ButtonItemsCompras(
                    docs: docs[index],
                    userView: userView,
                    product: product,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
