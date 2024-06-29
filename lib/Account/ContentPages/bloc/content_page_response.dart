// @dart=2.9
class ContentPageResponse {
  int status;
  String message;
  String info;
  ContentData contentData;

  ContentPageResponse({
    this.status,
    this.message,
    this.info,
    this.contentData,
  });

  ContentPageResponse.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    info = json["info"];
    contentData = ContentData.fromJson(json["data"]);
  }
}

class ContentData {
  String title;
  String content;
  String image;

  ContentData({
    this.title,
    this.content,
    this.image,
  });

  ContentData.fromJson(Map<String, dynamic> json) {
    title = json["title"];
    content = json["content"];
    image = json["image"];
  }
}
