import 'package:sqflite/sqflite.dart';
import 'package:tony_chat_box/database/base_db_provider.dart';

import 'conversation_info.dart';

class ConversationDbProvider extends BaseDbProvider {
  static const String _tableConversationName = 'conversations';
  static const String _columnUuid = 'uuid';
  static const String _columnName = 'name';
  static const String _columnModel = 'model';

  Future<List<ConversationInfo>> getConversations() async {
    final db = await getDataBase();
    final List<Map<String, dynamic>> maps =
        await db.query(_tableConversationName);
    return List.generate(maps.length, (i) {
      return ConversationInfo.fromJson(maps[i]);
    });
  }

  Future<ConversationInfo> getConversation(String conversationId) async {
    final db = await getDataBase();
    final List<Map<String, dynamic>> maps = await db.query(
      _tableConversationName,
      where: 'uuid = ?',
      whereArgs: [conversationId],
    );
    return ConversationInfo.fromJson(maps[0]);
  }

  Future<void> addConversation(ConversationInfo conversation) async {
    final db = await getDataBase();
    await db.insert(
      _tableConversationName,
      conversation.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateConversation(ConversationInfo conversation) async {
    final db = await getDataBase();
    await db.update(
      _tableConversationName,
      conversation.toJson(),
      where: '$_columnUuid = ?',
      whereArgs: [conversation.uuid],
    );
  }

  Future<void> deleteConversation(String uuid) async {
    final db = await getDataBase();
    await db.transaction((txn) async {
      await txn.delete(
        _tableConversationName,
        where: '$_columnUuid = ?',
        whereArgs: [uuid],
      );
    });
  }

  @override
  String createTableString() {
    return '''
          CREATE TABLE $_tableConversationName (
            $_columnUuid TEXT PRIMARY KEY,
            $_columnName TEXT,
            $_columnModel TEXT
          )
        ''';
  }

  @override
  String tableName() {
    return _tableConversationName;
  }
}
