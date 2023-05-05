import 'package:tony_chat_box/api/base_api.dart';

class CompletionsApi extends BaseApi {
  @override
  String getPath() {
    return '/v1/chat/completions';
  }

}