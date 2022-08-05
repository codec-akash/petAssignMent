import 'package:pettest/model/asset_model.dart';
import 'package:pettest/model/post_model.dart';
import 'package:pettest/networking/api_provider.dart';

class PostRepo {
  ApiProvider apiProvider = ApiProvider();

  Future<List<PostDataModel>> loadPost() async {
    try {
      var result = await apiProvider
          .getCall("http://jsonplaceholder.typicode.com/posts");
      if (result['error'] != null) {
        throw result['error'];
      }
      List<PostDataModel> postModelList = (result['result'] as List)
          .map((e) => PostDataModel.fromJson(e))
          .toList();

      return postModelList;
    } catch (e) {
      throw "Something went wrong";
    }
  }
}
