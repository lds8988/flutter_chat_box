import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SPUtil{
  //创建工厂方法
  static SPUtil? _instance;
  factory SPUtil.getInstance() => _instance ??= SPUtil._initial();
  SharedPreferences? _preferences;

  SPUtil._initial();

  static Future<SPUtil?> perInit() async {
    if (_instance == null) {
      //静态方法不能访问非静态变量所以需要创建变量再通过方法赋值回去
      SharedPreferences preferences = await SharedPreferences.getInstance();
      _instance = SPUtil._pre(preferences);
    }
    return _instance;
  }


  SPUtil._pre(SharedPreferences prefs) {
    _preferences = prefs;
  }
  ///设置String类型的
  void setString(key, value) {
    _preferences?.setString(key, value);
  }
  ///设置setStringList类型的
  void setStringList(key, value) {
    _preferences?.setStringList(key, value);
  }
  ///设置setBool类型的
  void setBool(key, value) {
    _preferences?.setBool(key, value);
  }
  ///设置setDouble类型的
  void setDouble(key, value) {
    _preferences?.setDouble(key, value);
  }
  ///设置setInt类型的
  void setInt(key, value) {
    _preferences?.setInt(key, value);
  }
  ///存储Json类型的
  void setJson(key, value) {
    value = jsonEncode(value);
    _preferences?.setString(key, value);
  }
  ///通过泛型来获取数据
  T? get<T>(key) {
    var result = _preferences?.get(key);
    if (result != null) {
      return result as T;
    }
    return null;
  }
  ///获取JSON
  Map<String, dynamic>? getJson(key) {
    String? result = _preferences?.getString(key);
    if (result?.isNotEmpty ?? false) {
      return jsonDecode(result!);
    }
    return null;
  }
  ///文中的StringUtil中的isNotEmpty的判断
  ///  static isNotEmpty(String? str) {
  /// return str?.isNotEmpty ?? false;
  /// }
  ///清除全部
  void clean() {
    _preferences?.clear();
  }
  ///移除某一个
  void remove(key) {
    _preferences?.remove(key);
  }
}