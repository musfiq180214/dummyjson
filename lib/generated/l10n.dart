// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Sign In`
  String get sign_in {
    return Intl.message('Sign In', name: 'sign_in', desc: '', args: []);
  }

  /// `Register`
  String get register {
    return Intl.message('Register', name: 'register', desc: '', args: []);
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Guest`
  String get guest {
    return Intl.message('Guest', name: 'guest', desc: '', args: []);
  }

  /// `Guest Other`
  String get guest_other {
    return Intl.message('Guest Other', name: 'guest_other', desc: '', args: []);
  }

  /// `Guest Home`
  String get guest_home {
    return Intl.message('Guest Home', name: 'guest_home', desc: '', args: []);
  }

  /// `Welcome Guest`
  String get welcome_guest {
    return Intl.message(
      'Welcome Guest',
      name: 'welcome_guest',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Guest to other screen`
  String get welcome_guest_another {
    return Intl.message(
      'Welcome Guest to other screen',
      name: 'welcome_guest_another',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your user name`
  String get please_enter_username {
    return Intl.message(
      'Please enter your user name',
      name: 'please_enter_username',
      desc: '',
      args: [],
    );
  }

  /// ` Enter Username`
  String get enter_username {
    return Intl.message(
      ' Enter Username',
      name: 'enter_username',
      desc: '',
      args: [],
    );
  }

  /// `Enter Password`
  String get please_enter_pass {
    return Intl.message(
      'Enter Password',
      name: 'please_enter_pass',
      desc: '',
      args: [],
    );
  }

  /// `New to this app?`
  String get new_to_app {
    return Intl.message(
      'New to this app?',
      name: 'new_to_app',
      desc: '',
      args: [],
    );
  }

  /// `Product List`
  String get product_list {
    return Intl.message(
      'Product List',
      name: 'product_list',
      desc: '',
      args: [],
    );
  }

  /// `Product Search`
  String get product_search {
    return Intl.message(
      'Product Search',
      name: 'product_search',
      desc: '',
      args: [],
    );
  }

  /// `Search Product...`
  String get search_product {
    return Intl.message(
      'Search Product...',
      name: 'search_product',
      desc: '',
      args: [],
    );
  }

  /// `Type to Search`
  String get type_to_search {
    return Intl.message(
      'Type to Search',
      name: 'type_to_search',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'bn'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
