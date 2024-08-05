import 'package:todo_list_app/constants/app_constants.dart';
import 'package:todo_list_app/utils/preference_helper.dart';

class Prefs {
  static Future<String> get getLoginToken =>
      PreferencesHelper.getString(AppConstants.loginToken);

  static Future setLoginToken(String value) =>
      PreferencesHelper.setString(AppConstants.loginToken, value);

  static Future<void> clear() =>
      PreferencesHelper.clearPreference();
}
