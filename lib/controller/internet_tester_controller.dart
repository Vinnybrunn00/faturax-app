import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

class InternetTesterController with ChangeNotifier {
  InternetTesterController() {
    _iniciarMonitoramento();
  }

  bool _status = true;
  bool get status => _status;

  bool _isDisposed = false;
  Timer? _timer;

  void _iniciarMonitoramento() async {
    await _executarTesteReal();

    if (!_isDisposed) {
      _timer = Timer(Duration(seconds: 3), _iniciarMonitoramento);
    }
  }

  Future<void> _executarTesteReal() async {
    try {
      final lookup = await InternetAddress.lookup(
        'dns.google',
      ).timeout(const Duration(seconds: 3));

      final bool resultadoAtual =
          lookup.isNotEmpty && lookup[0].rawAddress.isNotEmpty;

      if (_status != resultadoAtual) {
        _status = resultadoAtual;
        notifyListeners();
      }
    } catch (_) {
      if (_status != false) {
        _status = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _timer?.cancel();
    super.dispose();
  }
}
