import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tony_chat_box/database/sql_manager.dart';

abstract class BaseDbProvider {

  String createTableString();

  String tableName();

  ///创建表sql语句
  String tableBaseString(String sql) {
    return sql;
  }

  Future<Database> getDataBase() async {
    return await open();
  }

  ///super 函数对父类进行初始化
  Future<void> prepare(name, String createSql) async {
    var isTableExits = await SqlManager.getInstance().isTableExits(name);
    if (!isTableExits) {
      Database db = (await SqlManager.getInstance().getDatabase());
      await db.execute(createSql);
    }
  }

  @mustCallSuper
  Future<Database> open() async {
    await prepare(tableName(), createTableString());

    return (await SqlManager.getInstance().getDatabase());
  }

}