import 'package:faturax_app/constants/regex_patterns.dart';
import 'package:faturax_app/core/contract/user_contracts.dart';

class Username implements ContractsUser {
  final String _username;

  Username({required this._username});

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
