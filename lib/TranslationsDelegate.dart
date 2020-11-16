import 'dart:async';

import 'package:flutter/material.dart';

import 'translation_strings.dart';

class TranslationsDelegate extends LocalizationsDelegate<Translations> {
  final Locale overriddenLocale;
  TranslationsDelegate(this.overriddenLocale);

  @override
  bool isSupported(Locale locale) => ['fa', 'en'].contains(locale.languageCode);

  @override
  Future<Translations> load(Locale locale) => Translations.load(locale);

  @override
  bool shouldReload(TranslationsDelegate old) => false;
}
