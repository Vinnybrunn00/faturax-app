import 'package:faturax/constants/regex_password.dart';
import 'package:faturax/core/contract/user_contract.dart';

class Username implements ContractUser {
  final String _username;

  Username({required String username}) : _username = username;

  @override
  String get getValue => _username;

  @override
  void validate() {
    final Map<bool, String> rules = {
      _username.isEmpty: 'O campo usuário não pode estar vazio',
      _username.length <= 3: 'Campo usuário muito curto, tente outro',
      hasSpace.hasMatch(_username): 'O campo usuário não pode conter espaços',
    };
    for (final rule in rules.entries) {
      if (rule.key) {
        throw rule.value;
      }
    }
  }
}
