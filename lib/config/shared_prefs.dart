import 'dart:convert';
import '/models/birth_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _showIntro = 'showIntro';
const String keyTheme = 'theme';
const String _token = 'token';
const String _firstTime = 'firstTime';
const String _sortType = 'sortType';
const String _birthDetails = 'birthDetails';
const String _skipRegistration = 'skipRegistration';

const String _showLogin = 'showLogin';

class SharedPrefs {
  static SharedPreferences? _sharedPrefs;

  factory SharedPrefs() => SharedPrefs._internal();

  SharedPrefs._internal();

  Future<void> init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  bool get checkPrefsNull =>
      _sharedPrefs != null && _sharedPrefs!.containsKey(keyTheme);

  int get theme => _sharedPrefs?.getInt(keyTheme) ?? 0;

  String? get token => _sharedPrefs?.getString(_token);

  bool get isFirstTime => _sharedPrefs?.getBool(_firstTime) ?? true;

  bool get sortType => _sharedPrefs?.getBool(_firstTime) ?? false;

  bool get skipRegistration =>
      _sharedPrefs?.getBool(_skipRegistration) ?? false;

  bool get showIntro => _sharedPrefs?.getBool(_showIntro) ?? true;

  bool get showLogin => _sharedPrefs?.getBool(_showLogin) ?? false;

  // Map<String, dynamic>? get birthDetails {
  //   if (_sharedPrefs?.getString(_birthDetails) != null) {
  //     return json.decode(_sharedPrefs?.getString(_birthDetails) ?? '{}');
  //   }
  //   return {};
  // }

  BirthDetails? get birthDetails {
    if (_sharedPrefs?.getString(_birthDetails) != null) {
      final data = json.decode(_sharedPrefs?.getString(_birthDetails) ?? '{}')
          as Map<String, dynamic>?;
      if (data != null) {
        return BirthDetails.fromMap(data);
      }
      //return null;
    }
    return null;
  }

  // Future<void> setBirthDetails(Map<String, dynamic> value) async {
  //   if (_sharedPrefs != null) {
  //     await _sharedPrefs?.setString(_birthDetails, json.encode(value));
  //   }
  // }

  Future<void> setShowLogin() async {
    if (_sharedPrefs != null) {
      await _sharedPrefs?.setBool(_showLogin, true);
    }
  }

  Future<void> setBirthDetails(BirthDetails birthDetails) async {
    if (_sharedPrefs != null) {
      await _sharedPrefs?.setString(
          _birthDetails, json.encode(birthDetails.toMap()));
    }
  }

  Future<void> setToken(String value) async {
    if (_sharedPrefs != null) {
      await _sharedPrefs?.setString(_token, value);
    }
  }

  Future<void> disableIntro() async {
    if (_sharedPrefs != null) {
      await _sharedPrefs?.setBool(_showIntro, false);
    }
  }

  Future<void> setSkipRegistration(bool value) async {
    if (_sharedPrefs != null) {
      await _sharedPrefs?.setBool(_skipRegistration, value);
    }
  }

  Future<void> setSortType(bool value) async {
    if (_sharedPrefs != null) {
      await _sharedPrefs?.setBool(_sortType, value);
    }
  }

  Future<bool> deleteEverything() async {
    print('This runs -7');
    if (_sharedPrefs != null) {
      print('This runs -6');
      final result = await _sharedPrefs?.clear();
      return result ?? false;
    }
    return false;
  }

  Future<void> setFirstTime(bool value) async {
    if (_sharedPrefs != null) {
      await _sharedPrefs?.setBool(_firstTime, value);
    }
  }

  //setTheme
  // We can access this as await SharedPrefs().setTheme(event.theme.index);
  Future<void> setTheme(int value) async {
    if (_sharedPrefs != null) {
      await _sharedPrefs?.setInt(keyTheme, value);
    }
  }
}
