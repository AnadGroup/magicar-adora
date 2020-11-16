// Copyright 2018 - 2019, Amirreza Madani. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

library date;

import 'package:anad_magicar/date/helper/src/date_formatter.dart';

/// Super interface of Jalali and Georgian classes
abstract class Date {
  /// year
  int get year;

  /// month
  int get month;

  /// day
  int get day;

  /// julian day number
  int get julianDayNumber;

  /// week day number
  int get weekDay;

  /// month length
  int get monthLength;

  /// Formatter for this date object
  DateFormatter get formatter;

  /// checks if this year is a leap year
  bool isLeapYear();

  /// checks if is valid
  bool isValid();
}
