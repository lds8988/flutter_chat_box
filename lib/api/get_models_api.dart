import 'package:tony_chat_box/api/base_api.dart';

class GetModelsApi extends BaseApi {
  @override
  String getPath() {
    return '/v1/models';
  }

  @override
  RequestType getMethod() {
    return RequestType.get;
  }
}