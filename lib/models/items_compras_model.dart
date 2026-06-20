class ItemComprasModel {
  final String name;
  final String startDate;
  final bool isFixed;
  final int priceInt;
  final int parcelasParciais;
  final int parcelasTotais;
  final int timeStamp;

  ItemComprasModel({
    required this.name,
    required this.startDate,
    required this.isFixed,
    required this.priceInt,
    required this.parcelasParciais,
    required this.parcelasTotais,
    required this.timeStamp,
  });

  factory ItemComprasModel.fromMapData({required Map<String, dynamic> data}) {
    return ItemComprasModel(
      name: data['name'] as String,
      startDate: data['start_date'] as String,
      isFixed: data['isFixed'] as bool,
      priceInt: data['price_int'] as int,
      parcelasParciais: data['parcelas_parciais'] as int,
      parcelasTotais: data['parcelas_totais'] as int,
      timeStamp: data['timestamp'] as int,
    );
  }

  int get lastParcelas => parcelasTotais - parcelasParciais;

  bool get isPago {
    if (isFixed) return false;
    return parcelasTotais == parcelasParciais;
  }
}
