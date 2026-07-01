import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserView with ChangeNotifier {
  UserView() {
    _update();
  }

  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  bool _colapsed = false;
  bool get colapsed => _colapsed;

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

  String dateViewer(int timestamp) {
    final DateTime data = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final String format = DateFormat('dd/MM/yyyy - HH:mm').format(data);
    return format;
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
