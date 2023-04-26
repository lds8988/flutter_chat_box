import 'package:sqflite/sqflite.dart';
import 'package:tony_chat_box/database/assistant/assistant_info.dart';
import 'package:tony_chat_box/database/base_db_provider.dart';
import 'package:tony_chat_box/database/prompt/prompt_db_provider.dart';
import 'package:tony_chat_box/database/sql_manager.dart';
import 'package:tony_chat_box/utils/log_util.dart';
import 'package:uuid/uuid.dart';

class AssistantDbProvider extends BaseDbProvider {
  final String _tableName = 'assistant';
  final String _columnId = 'id';
  final String _columnTitle = 'title';
  final String _columnDesc = 'desc';

  final sceneList = [
    {
      "title": "前端开发智能助手",
      "description": "协助你解决一切前端开发问题",
      'prompts': [
        '需要你扮演技术精湛的前端开发工程师，解决前端问题',
      ]
    },
    {
      "title": "后端开发智能助手",
      "description": "协助你解决一切后端开发问题",
      'prompts': [
        '需要你扮演技术精湛的后端开发工程师，解决后端问题',
      ]
    },
    {
      "title": "Flutter 开发智能助手",
      "description": "协助你解决一切 Flutter 开发问题",
      'prompts': [
        '需要你扮演技术精湛的 Flutter 开发工程师，解决 Flutter 开发相关的问题',
      ]
    },
    {
      "title": "小程序开发智能助手",
      "description": "协助你解决一切小程序开发问题",
      'prompts': [
        '需要你扮演技术精湛的小程序开发工程师，解决小程序开发相关的问题',
      ]
    },
    {
      "title": "运维智能助手",
      "description": "协助你解决一切运维问题",
      'prompts': [
        '需要你扮演运维工程师，需要维护系统的稳定性',
      ]
    },
    {
      "title": "小红书标题智能助手",
      "description": '协助你起小红书标题',
      'prompts': [
        '''
          💃 10S自测适合裙子or裤子 (结果)\n
          ✂️ 旧衣改造穿出新花样 (事件)\n
          👗 穿搭博主 vs 现实中穿搭 (对比)\n
          🔢 4种体型女生穿搭技巧！ (解决方案)\n
          🎨 最显白颜色穿搭 (结果)\n
          🙋 当代女生买裙子难处 (细分人群+共鸣)\n
          👠 双开门衣柜装鞋情况 (数字+结果)\n
          👗 微胖穿搭建议 (细分人群+数字)\n
          🧦 万能袜子搭配公式 (解决方案+结果)\n
          请基于上述小红书标题和括号里的编写逻辑，针对用户输入生成10个新的小红书标题，标题中应当使用恰当的emoji表情
        '''
      ]
    },
    {
      "title": "小红书内容智能助手",
      "description": '协助你写小红书内容',
      'prompts': [
        '''
          一篇小红书笔记主要包括4个部分：
          开头：痛点引入+情景描述+人设+方法介绍+点赞诱导
          中间：讲知识点，范围控制在1~5个，如果是5个重点讲其中的两个，如果是3个重点讲其中1个，有重点，效果会更好。
          结尾：提高关注率
          说明： 我是写的内容常常是一个系列来的，欢迎大家点击主页查看更多精彩内容（目的引导用户看下一篇，想看更多去主页）
          最后：给笔记打上热门标签
          请以上述规则为基础，作为一位小红书博主以我给出的主题写一篇小红书笔记，全部规则都要用上
        '''
      ]
    },
  ];

  @override
  String createTableString() {
    return '''
           CREATE TABLE $_tableName (
             $_columnId TEXT PRIMARY KEY,
             $_columnTitle TEXT,
             $_columnDesc TEXT
           )
         ''';
  }

  @override
  String tableName() {
    return _tableName;
  }

  @override
  Future<void> prepare(name, String createSql) async {

    var isTableExits = await SqlManager.getInstance().isTableExits(name);

    if (!isTableExits) {
      Database db = (await SqlManager.getInstance().getDatabase());

      var batch = db.batch();

      batch.execute(createSql);

      PromptDbProvider promptDbProvider = PromptDbProvider();
      batch.execute(promptDbProvider.createTableString());

      for (var scene in sceneList) {
        var assistantId = const Uuid().v4();

        batch.rawInsert(
          'INSERT INTO $name ($_columnId, $_columnTitle, $_columnDesc) VALUES (?, ?, ?)',
          [
            assistantId,
            scene['title'],
            scene['description'],
          ],
        );

        for (var prompt in scene['prompts'] as List<String>) {
          batch.rawInsert(
            'INSERT INTO ${promptDbProvider.tableName()} (assistant_id, content)VALUES (?, ?)',
            [
              assistantId,
              prompt,
            ],
          );
        }
      }

      await batch.commit();
    }
  }

  Future<List<AssistantInfo>> getAssistantList() async {
    Database db = await getDataBase();

    var assistantList = await db.query(_tableName);

    return List.generate(
      assistantList.length,
      (index) => AssistantInfo.fromJson(assistantList[index]),
    );
  }
}
