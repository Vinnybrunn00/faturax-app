import 'dart:async';
import 'package:faturax_app/constants/constants_values.dart';
import 'package:faturax_app/viewmodels/date_time_app.dart';
import 'package:faturax_app/ui/widgets/theme_data_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker with ChangeNotifier {
  String? _date;

  late DateTimeApp _dateTimeApp;

  DateTimeApp get dateTimeApp => _dateTimeApp;

  String? get date => _date;

  set setDate(String value) {
    _date = value;
  }

  String dateTimeFormat(DateTime now) {
    final dateTime = DateTime(now.year, now.month + 1);
    return DateFormat('MMMM', 'pt_BR').format(dateTime);
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? showDataPicker = await showDatePicker(
      context: context,
      barrierDismissible: true,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      firstDate: DateTime(1500),
      lastDate: DateTime(2500),
      locale: const Locale('pt', 'BR'),
      builder: (context, child) {
        return ThemeDataPicker(child: child);
      },
    );

    if (showDataPicker != null) {
      final String format = DateFormat(
        formatDatePt,
        'pt_BR',
      ).format(showDataPicker);

      _date = format;
      _dateTimeApp = DateTimeApp(dateTime: showDataPicker, datePicker: _date);
      notifyListeners();
    }
  }
}
