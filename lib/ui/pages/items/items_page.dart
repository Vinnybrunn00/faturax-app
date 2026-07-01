import 'package:faturax_app/constants/constants_color.dart';
import 'package:faturax_app/models/items_compras_model.dart';
import 'package:faturax_app/services/logs_services.dart';
import 'package:faturax_app/ui/components/inputs/input_compras.dart';
import 'package:faturax_app/ui/widgets/box_circular_progress.dart';
import 'package:faturax_app/viewmodels/items_model.dart';
import 'package:faturax_app/repository/product_repository.dart';
import 'package:faturax_app/ui/widgets/event_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemsPage extends StatelessWidget {
  final ItemComprasModel _items;

  const ItemsPage({super.key, required this._items});

  @override
  Widget build(BuildContext context) {
    final ItemsModel itemsModel = Provider.of<ItemsModel>(context);
    return Scaffold(
      backgroundColor: AppColor.backgroundColorWhite,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColorWhite,
        title: Text('Editar Compra'),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 8, right: 8),
        padding: EdgeInsets.only(top: 25, right: 8, bottom: 25, left: 8),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.borderColor),
        ),
        child: Consumer<ProductRepository>(
          builder: (context, product, child) {
            return Stack(
              children: [
                Column(
                  mainAxisSize: .min,
                  spacing: 15,
                  children: [
                    InputCompras(
                      title: 'Nome da Compra',
                      hintText: _items.name,
                      readOnly: true,
                      enabled: false,
                    ),

                    InputCompras(
                      title: 'Valor da Compra',
                      hintText: product.convertCentInReais(_items.priceInt),
                      readOnly: true,
                      enabled: false,
                    ),

                    InputCompras(
                      enabled: !product.loading,
                      onChanged: (String parcelas) =>
                          itemsModel.onChange(parcelas, _items.parcelasTotais),
                      title: 'Numero de parcelas pagas',
                      hintText: 'ex: 5',
                      maxLength: 2,
                      keyboardType: TextInputType.number,
                      errorText:
                          'Parcelado em ${_items.parcelasTotais} vezes (${_items.parcelasParciais} parcelas pagas)',
                    ),

                    EventButton(
                      title: 'Salvar Compra',
                      onTap: itemsModel.enabled
                          ? () async {
                              await product.changeParcelas(
                                itemsModel,
                                _items.id,
                              );

                              if (!context.mounted) return;
                              // LOG - editar compra
                              LogsServices(
                                context: context,
                                message:
                                    'editou a compra "${_items.name}" para ${itemsModel.parcelas} parcela(s)',
                                type: 'INFO',
                              );

                              Navigator.of(context).pop();
                            }
                          : null,
                      color: itemsModel.enabled
                          ? AppColor.purpleColor
                          : Color(0x834150F7),
                    ),
                  ],
                ),
                product.loading ? BoxCircularProgress() : SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }
}
