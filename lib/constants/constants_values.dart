import 'package:intl/intl.dart';

final Iterable<MapEntry<int, String>> installments = [
  '1 parcela',
  '2 parcelas',
  '3 parcelas',
  '4 parcelas',
  '5 parcelas',
  '6 parcelas',
  '7 parcelas',
  '8 parcelas',
  '9 parcelas',
  '10 parcelas',
  '11 parcelas',
  '12 parcelas',
].asMap().entries;

String get showMonthCalendar =>
    DateFormat("MMMM 'de' yyyy", 'pt_BR').format(DateTime.now());

String get showMonth => DateFormat('MMMM', 'pt_BR').format(DateTime.now());
