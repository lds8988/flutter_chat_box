import 'package:flutter_chatgpt/repository/msg/msg_info.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'conversation_info.dart';


class ConversationRepository {
  static const String _tableConversationName = 'conversations';
  static const String _tableMessageName = 'messages';
  static const String _columnUuid = 'uuid';
  static const String _columnName = 'name';
  static const String _columnId = 'id';
  static const String _columnRole = 'role';
  static const String _columnText = 'text';
  static Database? _database;
  static ConversationRepository? _instance;

  ConversationRepository._internal();

  factory ConversationRepository.getInstance() {
    _instance ??= ConversationRepository._internal();
    return _instance!;
  }

  Future<Database> _getDb() async {
    if (_database == null) {
      final String path = join(await getDatabasesPath(), 'chatgpt.db');

      _database = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $_tableConversationName (
            $_columnUuid TEXT PRIMARY KEY,
            $_columnName TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE $_tableMessageName (
            $_columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $_columnUuid TEXT,
            $_columnRole INTEGER,
            $_columnText TEXT,
            FOREIGN KEY ($_columnUuid) REFERENCES conversations($_columnUuid)
          )
        ''');
      });
    }
    return _database!;
  }

  Future<List<ConversationInfo>> getConversations() async {
    final db = await _getDb();
    final List<Map<String, dynamic>> maps =
        await db.query(_tableConversationName);
    return List.generate(maps.length, (i) {
      final uuid = maps[i][_columnUuid];
      final name = maps[i][_columnName];
      return ConversationInfo(
        uuid: uuid,
        name: name,
      );
    });
  }

  Future<void> addConversation(ConversationInfo conversation) async {
    final db = await _getDb();
    await db.insert(
      _tableConversationName,
      conversation.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateConversation(ConversationInfo conversation) async {
    final db = await _getDb();
    await db.update(
      _tableConversationName,
      conversation.toJson(),
      where: '$_columnUuid = ?',
      whereArgs: [conversation.uuid],
    );
  }

  Future<void> deleteConversation(String uuid) async {
    final db = await _getDb();
    await db.transaction((txn) async {
      await txn.delete(
        _tableConversationName,
        where: '$_columnUuid = ?',
        whereArgs: [uuid],
      );
      await txn.delete(
        _tableMessageName,
        where: '$_columnUuid = ?',
        whereArgs: [uuid],
      );
    });
  }

  Future<List<MsgInfo>> getMessagesByConversationUUid(String uuid) async {
    final db = await _getDb();
    final List<Map<String, dynamic>> maps = await db
        .query(_tableMessageName, where: '$_columnUuid = ?', whereArgs: [uuid]);
    return List.generate(maps.length, (i) {
      final role = maps[i][_columnRole];
      final text = maps[i][_columnText];
      final uuid = maps[i][_columnUuid];
      final id = maps[i][_columnId];
      return MsgInfo(
        id: id,
        roleInt: role,
        text: text,
        conversationId: uuid,
      );
    });
  }

  Future<void> addMessage(MsgInfo message) async {
    final db = await _getDb();
    await db.insert(
      _tableMessageName,
      message.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteMessage(int id) async {
    final db = await _getDb();
    await db.delete(
      _tableMessageName,
      where: '$_columnId = ?',
      whereArgs: [id],
    );
  }
}
