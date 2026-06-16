import 'package:flutter/widgets.dart';

enum Mode { isLogin, isSignup }

class AuthModel with ChangeNotifier {
  String username = '';
  String password = '';

  bool _isDisposed = false;

  Mode _mode = Mode.isLogin;

  bool get isLogin => _mode == Mode.isLogin;

  bool get isSignup => _mode == Mode.isSignup;

  bool get isObscure => _isObscure;

  bool _isLoading = false;
  bool _isObscure = true;

  set setLoading(bool loading) {
    _isLoading = loading;

    if (!_isDisposed) {
      notifyListeners();
    }
  }

  bool get isLoading => _isLoading;

  void changeMode() {
    _mode = isLogin ? Mode.isSignup : Mode.isLogin;
    notifyListeners();
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
