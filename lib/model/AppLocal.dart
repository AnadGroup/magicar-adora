import 'package:flutter/material.dart';

enum AppLocal { PERSIAN, ENGLISH }

final appPeriasnLocalData = Locale("fa");
final appEnglishLocalData = Locale("en");

final appLocalData = {
  AppLocal.PERSIAN: appPeriasnLocalData,
  AppLocal.ENGLISH: appEnglishLocalData,
};
