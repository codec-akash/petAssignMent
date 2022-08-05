class AssetModel {
  String? url;

  AssetModel({this.url});

  bool get isVideo => url!.endsWith('.mp4') && url!.startsWith('http');

  AssetModel.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['url'] = this.url;
    return data;
  }
}
