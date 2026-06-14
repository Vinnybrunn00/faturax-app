class DateTimeApp {
  final DateTime? _dateTime;
  final String? datePicker;

  DateTimeApp({this._dateTime, this.datePicker});

  int? get year => _dateTime?.year;
  int? get month => _dateTime?.month;
}
