import 'package:flutter/material.dart';
import 'package:pettest/model/asset_model.dart';
import 'package:pettest/networking/api_provider.dart';

class AssetRepo {
  AssetRepo();

  ApiProvider apiProvider = ApiProvider();

  Future<AssetModel> loadAsset() async {
    try {
      var result = await apiProvider.getCall("https://random.dog/woof.json");
      if (result['error'] != null) {
        throw result['error'];
      }
      AssetModel assetModel = AssetModel.fromJson(result['result']);
      return assetModel;
    } catch (e) {
      throw "Something went wrong";
    }
  }
}
