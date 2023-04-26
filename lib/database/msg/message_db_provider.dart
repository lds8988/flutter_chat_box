import 'package:sqflite/sqflite.dart';
import 'package:tony_chat_box/database/base_db_provider.dart';
import 'package:tony_chat_box/database/msg/msg_info.dart';
import 'package:tony_chat_box/database/prompt/prompt_db_provider.dart';

class MessageDbProvider extends BaseDbProvider {
  static const String _tableMessageName = 'messages';
  static const String _columnUuid = 'uuid';
  static const String _columnId = 'id';
  static const String _columnRole = 'role';
  static const String _columnText = 'text';
  static const String _columnState = 'state';
  static const String _columnFinishReason = 'finish_reason';

  Future<List<MsgInfo>> getMessagesByConversationUUid(
    String uuid, {
    String order = "ASC",
  }) async {
    final db = await getDataBase();
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
    final db = await getDataBase();
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
    final db = await getDataBase();
    return await db.insert(
      _tableMessageName,
      message.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> addSystemMessage(String conversationId, String prompt) async {
    var systemMsgInfo = MsgInfo(
      conversationId: conversationId,
      text: prompt,
      roleInt: Role.system.index,
      stateInt: MsgState.received.index,
    );

    final db = await getDataBase();
    return await db.insert(
      _tableMessageName,
      systemMsgInfo.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> addSystemMessageByAssistantId(
    String conversationId,
    String assistantId,
  ) async {
    final db = await getDataBase();
    var batch = db.batch();

    var prompts = await PromptDbProvider().getPromptsByRobotId(assistantId);

    for (var prompt in prompts) {
      var systemMsgInfo = MsgInfo(
        conversationId: conversationId,
        text: prompt.content,
        roleInt: Role.system.index,
        stateInt: MsgState.received.index,
      );
      batch.insert(
        _tableMessageName,
        systemMsgInfo.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<void> updateMessage(MsgInfo msgInfo) async {
    final db = await getDataBase();
    await db.update(
      _tableMessageName,
      msgInfo.toJson(),
      where: '$_columnId = ?',
      whereArgs: [msgInfo.id],
    );
  }

  Future<void> deleteMessage(int id) async {
    final db = await getDataBase();
    await db.delete(
      _tableMessageName,
      where: '$_columnId = ?',
      whereArgs: [id],
    );
  }

  @override
  String createTableString() {
    return '''
           CREATE TABLE $_tableMessageName (
             $_columnId INTEGER PRIMARY KEY AUTOINCREMENT,
             $_columnUuid TEXT,
             $_columnRole INTEGER,
             $_columnText TEXT,
             $_columnState INTEGER,
             $_columnFinishReason TEXT,
             FOREIGN KEY ($_columnUuid) REFERENCES conversations($_columnUuid)
           )
         ''';
  }

  @override
  String tableName() {
    return _tableMessageName;
  }
}
