import 'package:flutter/widgets.dart';

class AuthModel with ChangeNotifier {
  String username = '';
  String password = '';

  bool _isObscure = true;
  bool get isObscure => _isObscure;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isDisposed = false;

  set setLoading(bool loading) {
    _isLoading = loading;

    if (!_isDisposed) {
      notifyListeners();
    }
  }

  void setObscureText() {
    _isObscure = !_isObscure;
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
