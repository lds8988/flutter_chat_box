import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tony_chat_box/repository/msg/msg_info.dart';

import 'conversation_info.dart';

class ConversationRepository {
  static const String _tableConversationName = 'conversations';
  static const String _tableMessageName = 'messages';
  static const String _columnUuid = 'uuid';
  static const String _columnName = 'name';
  static const String _columnId = 'id';
  static const String _columnRole = 'role';
  static const String _columnText = 'text';
  static const String _columnState = 'state';
  static const String _columnFinishReason = 'finish_reason';
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

      _database = await openDatabase(path, version: 2,
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
            $_columnState INTEGER,
            $_columnFinishReason TEXT,
            FOREIGN KEY ($_columnUuid) REFERENCES conversations($_columnUuid)
          )
        ''');
      }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion == 1 && newVersion == 2) {
          await db.execute('''
            ALTER TABLE $_tableMessageName ADD COLUMN $_columnFinishReason TEXT
          ''');
        }
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

  Future<List<MsgInfo>> getMessagesByConversationUUid(
    String uuid, {
    String order = "ASC",
  }) async {
    final db = await _getDb();
    // 根据conversation的uuid查询message，过滤掉stateInt为2并且roleInt为2的消息
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT * FROM $_tableMessageName
      WHERE $_columnUuid = ?
      AND NOT ($_columnState = ${MsgState.failed.index} AND $_columnRole = ${Role.assistant.index})
      AND NOT $_columnRole = ${Role.system.index}
      ORDER BY $_columnId $order
      ''',
      [uuid],
    );

    return List.generate(maps.length, (i) {
      return MsgInfo(
        id: maps[i][_columnId],
        roleInt: maps[i][_columnRole],
        text: maps[i][_columnText],
        conversationId: maps[i][_columnUuid],
        stateInt: maps[i][_columnState],
        finishReason: maps[i][_columnFinishReason] ?? 'null',
      );
    });
  }

  Future<List<MsgInfo>> getSystemMessagesByConversationUuid(String uuid) async {
    final db = await _getDb();
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT * FROM $_tableMessageName
      WHERE $_columnUuid = ?
      AND $_columnRole = ${Role.system.index}
      ''',
      [uuid],
    );

    return List.generate(maps.length, (i) {
      return MsgInfo(
        id: maps[i][_columnId],
        roleInt: maps[i][_columnRole],
        text: maps[i][_columnText],
        conversationId: maps[i][_columnUuid],
        stateInt: maps[i][_columnState],
        finishReason: maps[i][_columnFinishReason] ?? 'null',
      );
    });
  }

  Future<int> addMessage(MsgInfo message) async {

    final db = await _getDb();
    return await db.insert(
      _tableMessageName,
      message.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> addSystemMessage(String conversationId, String text) async {

    var systemMsgInfo = MsgInfo(
      conversationId: conversationId,
      text: text,
      roleInt: Role.system.index,
      stateInt: MsgState.received.index,
    );

    final db = await _getDb();
    return await db.insert(
      _tableMessageName,
      systemMsgInfo.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateMessage(MsgInfo msgInfo) async {
    final db = await _getDb();
    await db.update(
      _tableMessageName,
      msgInfo.toJson(),
      where: '$_columnId = ?',
      whereArgs: [msgInfo.id],
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
