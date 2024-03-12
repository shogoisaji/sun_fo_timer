import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sun_fo_timer/repository/shared_preferences_keys.dart';

part 'shared_preferences_repository.g.dart';

@Riverpod(keepAlive: true)
SharedPreferencesRepository sharedPreferencesRepository(
  SharedPreferencesRepositoryRef ref,
) {
  throw UnimplementedError();
}

class SharedPreferencesRepository {
  SharedPreferencesRepository(this._prefs);

  final SharedPreferences _prefs;

  Future<String?> getString(SharedPreferencesKey key) async {
    final String? value = _prefs.getString(key.value);
    print('SharedPreferencesRepository getString: $value');
    return value;
  }

  Future<double?> getDouble(SharedPreferencesKey key) async {
    final double? value = _prefs.getDouble(key.value);
    print('SharedPreferencesRepository getDouble: $value');
    return value;
  }

  Future<bool> setString(SharedPreferencesKey key, String value) async {
    print('SharedPreferencesRepository setString: $value');
    return _prefs.setString(key.value, value);
  }

  Future<bool> setDouble(SharedPreferencesKey key, double value) async {
    print('SharedPreferencesRepository setDouble: $value');
    return _prefs.setDouble(key.value, value);
  }

  Future<bool> clearPref(SharedPreferencesKey key) async {
    print('SharedPreferencesRepository clearString');
    return _prefs.remove(key.value);
  }
}
