import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tony_chat_box/utils/log_util.dart';

class SqlManager {
  Database? _database;

  static const _version = 3;
  static const _name = 'chatgpt.db';

  SqlManager._internal() {
    _init();
  }

  static final SqlManager _instance = SqlManager._internal();

  factory SqlManager.getInstance() => _instance;

  _init() async {
    var databasesPath = await getDatabasesPath();

    String path = join(databasesPath, _name);

    _database = await openDatabase(
      path,
      version: _version,
      onOpen: (Database db) {
        db.execute('PRAGMA foreign_keys = ON');
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        var batch = db.batch();
        if (oldVersion < 3) {
          batch.execute('ALTER TABLE messages RENAME TO messages_old');
          batch.execute('''
              CREATE TABLE messages (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                uuid TEXT,
                role INTEGER,
                text TEXT,
                state INTEGER,
                finish_reason TEXT,
                FOREIGN KEY (uuid) REFERENCES conversations(uuid) ON DELETE CASCADE
              )
            ''');
          batch.execute("INSERT INTO messages SELECT * FROM messages_old");

          batch.execute('DROP TABLE messages_old');

          batch.commit();
        }
      },
    );
  }

  /// 判断表是否存在
  Future<bool> isTableExits(String tableName, {Database? database}) async {
    database ??= await getDatabase();

    var res = await database.rawQuery(
        "select * from Sqlite_master where type = 'table' and name = '$tableName'");
    return res.isNotEmpty;
  }

  Future<Database> getDatabase() async {
    if (_database == null) {
      await _init();
    }

    return _database!;
  }

  /// 关闭
  void close() {
    _database?.close();
    _database = null;
  }
}
