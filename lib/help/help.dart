import 'package:intl/intl.dart';

class Help {
  static timestampFormat(int timestamp, {String format = 'dd/MM'}) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat(format, 'vi').format(date);
  }

  static timestampFormatLong(int timestamp,
      {String format = 'HH:mm, MM/dd/yyyy'}) {
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat(format).format(date);
  }

  static numberFormat(int value) {
    final formatter = new NumberFormat.decimalPattern();

    return formatter.format(value);
  }

  static convertStringToDate(String date) {
    DateFormat dateFormat = DateFormat("M/dd/yyyy");
    var dateTime = dateFormat.parse(date + '20');
    return timestampFormat(dateTime.millisecondsSinceEpoch);
  }

  static convertTimeStamp(String date) {
    DateFormat dateFormat = DateFormat("M/dd/yyyy");
    var dateTime = dateFormat.parse(date + '20');
    return dateTime.millisecondsSinceEpoch * 1000;
  }

  static dateTimeFormat(DateTime dateTime, {String format = 'dd/MM'}) {
    return DateFormat(format).format(dateTime);
  }
}
