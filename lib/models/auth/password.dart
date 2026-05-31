import 'package:faturax/constants/regex_password.dart';
import 'package:faturax/core/contract/user_contract.dart';

class Password implements ContractUser {
  final String _password;

  Password({required String password}) : _password = password;

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
