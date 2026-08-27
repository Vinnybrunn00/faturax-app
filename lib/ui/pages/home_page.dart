import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faturax_app/constants/constants_color.dart';
import 'package:faturax_app/services/update_app.dart';
import 'package:faturax_app/viewmodels/home_view_model.dart';
import 'package:faturax_app/viewmodels/date_picker.dart';
import 'package:faturax_app/repository/user_repository.dart';
import 'package:faturax_app/repository/next_month_product.dart';
import 'package:faturax_app/repository/product_repository.dart';
import 'package:faturax_app/ui/components/slivers/sliver_app_bar_faturax.dart';
import 'package:faturax_app/ui/components/slivers/sliver_box_error.dart';
import 'package:faturax_app/ui/components/slivers/widgets/button_items_compras.dart';
import 'package:faturax_app/ui/modals/modal_new_compras.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ModalNewCompras _newCompras = ModalNewCompras();

  @override
  Widget build(BuildContext context) {
    final changePage = Provider.of<ChangePage>(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarContrastEnforced: false,
        systemNavigationBarIconBrightness: .dark,
      ),
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: changePage.index >= 1
            ? null
            : Consumer3<ProductRepository, DatePicker, UserView>(
                builder: (context, product, datePicker, userView, _) {
                  UpdateApp(context: context);
                  return AnimatedSlide(
                    curve: Curves.easeInBack,
                    offset: userView.colapsed
                        ? const Offset(1.8, 0)
                        : Offset.zero,
                    duration: Duration(milliseconds: 450),
                    child: Container(
                      margin: EdgeInsets.all(12),
                      child: Material(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox(
                          height: 60,
                          width: 60,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () async {
                              await _newCompras.showModalNewCompras(
                                context,
                                datePicker,
                                product,
                              );
                            },
                            child: Ink(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColor.purpleColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.add,
                                color: AppColor.whiteColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
        backgroundColor: AppColor.backgroundColorWhite,
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
                        Compras(product: product),
                      ],
                    );
                  },
            ),
      ),
    );
  }
}

class Compras extends StatelessWidget {
  final ProductRepository product;

  const Compras({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: product.items.orderBy('timestamp', descending: true).snapshots(),
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
          return SliverBoxError(widget: Text('Nenhuma compra encontrada'));
        }

        return SliverPadding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          sliver: SliverList.builder(
            itemCount: docs.length,
            itemBuilder: (_, index) {
              final String id = docs[index].id;

              return TweenAnimationBuilder(
                key: ValueKey(id),
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 550),
                curve: Curves.easeOut,
                builder: (_, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, (1 - value) * 20),
                      child: child,
                    ),
                  );
                },
                child: ButtonItemsCompras(docs: docs[index]),
              );
            },
          ),
        );
      },
    );
  }
}

class ChangePage with ChangeNotifier {
  int _index = 0;

  int get index => _index;

  void changePage(int index) {
    _index = index;
    notifyListeners();
  }

  List<Map<String, String>> get pages => [
    {'title': 'Em Aberto'},
    {'title': 'Pagas'},
  ];
}
