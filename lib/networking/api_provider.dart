import 'package:dio/dio.dart';
import 'package:pettest/networking/response_handler.dart';

class ApiProvider {
  Future<Map<String, dynamic>> getCall(String url) async {
    Dio dio = Dio();
    try {
      print(url);
      var uriResponse = await dio.get(url, options: Options(headers: {}));
      print("Response : - $uriResponse");
      return ApiResponseHandler.output(uriResponse);
    } catch (e) {
      return ApiResponseHandler.outputError();
    }
  }
}
