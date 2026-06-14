import 'package:faturax_app/constants/regex_patterns.dart';
import 'package:faturax_app/core/contract/user_contracts.dart';

class Password implements ContractsUser {
  final String _password;

  Password({required this._password});

  @override
  String get getValue => _password;

  @override
  void validate() {
    if (_password.isEmpty) {
      throw 'O campo senha não pode estar vazio.';
    }

    if (hasSpace.hasMatch(_password)) {
      throw 'O campo senha não pode conter espaços';
    }
  }
}
