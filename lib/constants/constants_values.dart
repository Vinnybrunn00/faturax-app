import 'dart:math' as math;

import 'package:intl/intl.dart';

String get showMonth => DateFormat('MMMM', 'pt_BR').format(DateTime.now());

final String formatDatePt = "MMMM 'de' yyyy";

String get itemId {
  const int max = 999999999;
  const int min = 100000000;
  final math.Random random = math.Random();
  final int randomNumber = random.nextInt(max - min);
  return randomNumber.toString();
}
