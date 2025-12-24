import 'package:flutter/material.dart';

class LocaleNotifier extends ValueNotifier<Locale> {
  LocaleNotifier(super.initialLocale);

  void changeLocale(Locale newLocale) {
    if (value != newLocale) {
      value = newLocale;
    }
  }
}
