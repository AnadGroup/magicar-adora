import 'package:anad_magicar/components/date_picker/flutter_datetime_picker.dart';

List<int> _leapYearMonths = const <int>[1, 3, 5, 7, 8, 10, 12];
List<int> _leapFAYearMonths = const <int>[1, 2, 3, 4, 5, 6];

int calcDateCount(int year, int month,LocaleType localeType) {
  if(localeType==LocaleType.fa){
    if (_leapYearMonths.contains(month)) {
      return 31;
    } else if (month == 12) {
      if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
        return 29;
      }
      return 30;
    }
    return 30;
  }
  else {
    if (_leapYearMonths.contains(month)) {
      return 31;
    } else if (month == 2) {
      if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
        return 29;
      }
      return 28;
    }
    return 30;
  }
}
