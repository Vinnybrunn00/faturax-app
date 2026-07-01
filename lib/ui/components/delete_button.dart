import 'package:faturax_app/constants/constants_color.dart';
import 'package:faturax_app/models/items_compras_model.dart';
import 'package:faturax_app/repository/product_repository.dart';
import 'package:faturax_app/services/logs_services.dart';
import 'package:faturax_app/ui/helpers/helpers.dart';
import 'package:faturax_app/ui/widgets/box_circular_progress.dart';
import 'package:flutter/material.dart';
import 'package:iconsx_plus/iconsx_plus.dart';
import 'package:provider/provider.dart';

class DeleteButton extends StatelessWidget {
  final ItemComprasModel _items;

  DeleteButton({super.key, required this._items});

  final Helpers _helpers = Helpers();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: () async {
        await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => Dialog(
            backgroundColor: AppColor.whiteColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Consumer<ProductRepository>(
              builder: (context, product, _) {
                return Padding(
                  padding: EdgeInsets.all(24),
                  child: Stack(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.red.shade400,
                              size: 36,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Apagar compra',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Tem certeza que deseja apagar a compra "${_items.name.trim()}"?\n\nEsta ação não pode ser desfeita.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColor.greyColor,
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 28),
                          Row(
                            spacing: 12,
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    side: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Text(
                                    'Cancelar',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final String deleteMsg = await product
                                        .deleteCompra(_items.id);

                                    if (!context.mounted) return;

                                    _helpers.showMessageInfo(
                                      context,
                                      message: deleteMsg,
                                    );
                                    if (!context.mounted) return;
                                    // LOG - Delete compra
                                    final priceFormat = product
                                        .convertCentInReais(_items.priceInt);

                                    LogsServices(
                                      context: context,
                                      message:
                                          'deletou a compra ${_items.name} de $priceFormat',
                                      type: 'INFO',
                                    );

                                    Navigator.of(context).pop();
                                  },

                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade500,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 14),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    'Apagar',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      product.loading
                          ? BoxCircularProgress()
                          : SizedBox.shrink(),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
      child: Ink(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppColor.borderColor, width: 1.2),
        ),
        child: Icon(
          BoxIcons.bx_trash,
          color: AppColor.redColor.withAlpha(155),
          size: 18,
        ),
      ),
    );
  }
}
