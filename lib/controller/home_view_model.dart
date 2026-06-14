import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserView with ChangeNotifier {
  UserView() {
    _update();
  }

  final ScrollController _scrollController = ScrollController();

  ScrollController get scrollController => _scrollController;

  bool _colapsed = false;
  String? _formatDate;

  bool get colapsed => _colapsed;
  String? get formatDate => _formatDate;

  void _addListener() {
    _scrollController.addListener(() {
      final bool isColapsed = _scrollController.offset > 140;

      if (_colapsed != isColapsed) {
        _colapsed = isColapsed;
        notifyListeners();
      }
    });
  }

  String showDataCompra(int timestamp) {
    final DateTime data = DateTime.fromMillisecondsSinceEpoch(timestamp);

    return DateFormat('dd/MM/yyyy').format(data);
  }

  void dateViewer(int timestamp) {
    final DateTime data = DateTime.fromMillisecondsSinceEpoch(timestamp);

    final String format = DateFormat('dd/MM/yyyy - HH:mm').format(data);

    _formatDate = format;
    notifyListeners();
  }

  void _update() {
    _addListener();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
