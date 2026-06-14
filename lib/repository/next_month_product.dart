import 'package:faturax_app/repository/product_repository.dart';

class NextMonthProduct extends ProductRepository {
  NextMonthProduct() {
    _update();
  }

  String get priceFormat => convertCentInReais(price);

  void _update() async {
    await changePriceTotal(isAfter: true);
    notifyListeners();
  }
}
