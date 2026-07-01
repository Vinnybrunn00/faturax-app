import 'package:cloud_firestore/cloud_firestore.dart';

class ItemComprasModel {
  final String id;
  final String name;
  final String? startDate;
  final bool isFixed;
  final int priceInt;
  final int parcelasParciais;
  final int parcelasTotais;
  final int timeStamp;

  ItemComprasModel({
    required this.id,
    required this.name,
    required this.startDate,
    required this.isFixed,
    required this.priceInt,
    required this.parcelasParciais,
    required this.parcelasTotais,
    required this.timeStamp,
  });

  factory ItemComprasModel.fromQueryDocument({
    required QueryDocumentSnapshot<Map<String, dynamic>> queryDocument,
  }) {
    final Map<String, dynamic> data = queryDocument.data();
    return ItemComprasModel(
      id: queryDocument.id,
      name: data['name'] as String,
      startDate: data['start_date'] as String?,
      isFixed: data['isFixed'] as bool,
      priceInt: data['price_int'] as int,
      parcelasParciais: data['parcelas_parciais'] as int,
      parcelasTotais: data['parcelas_totais'] as int,
      timeStamp: data['timestamp'] as int,
    );
  }

  bool get lastParcela => (parcelasTotais - parcelasParciais) == 1;
  bool get pending => !isFixed && !isPago;

  bool get isPago {
    if (isFixed) return false;
    return parcelasTotais == parcelasParciais;
  }
}
