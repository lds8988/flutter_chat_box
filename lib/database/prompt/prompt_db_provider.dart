import 'package:sqflite/sqflite.dart';
import 'package:tony_chat_box/database/base_db_provider.dart';
import 'package:tony_chat_box/database/prompt/prompt_info.dart';

class PromptDbProvider extends BaseDbProvider {
  final String _tableName = 'prompt';
  final String _columnId = 'id';
  final String _columnAssistantId = 'assistant_id';
  final String _columnContent = 'content';

  @override
  String createTableString() {
    return '''
           CREATE TABLE $_tableName (
             $_columnId INTEGER PRIMARY KEY AUTOINCREMENT,
             $_columnAssistantId INTEGER,
             $_columnContent TEXT,
             FOREIGN KEY ($_columnAssistantId) REFERENCES assistant(id) ON DELETE CASCADE
           )
         ''';
  }

  @override
  String tableName() {
    return _tableName;
  }

  Future<List<PromptInfo>> getPromptsByAssistantId(String assistantId) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: '$_columnAssistantId = ?',
      whereArgs: [assistantId],
    );
    return List.generate(
        maps.length, (index) => PromptInfo.fromJson(maps[index]));
  }
}
