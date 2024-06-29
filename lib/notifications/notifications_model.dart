// @dart=2.9
class NotificationsModel {
  NotificationsModel({
    this.status,
    this.message,
    this.info,
    this.data,
  });

  int status;
  String message;
  String info;
  List<Datum> data;

  factory NotificationsModel.fromJson(Map<String, dynamic> json) =>
      NotificationsModel(
        status: json["status"],
        message: json["message"],
        info: json["info"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "info": info,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.id,
    this.title,
    this.message,
  });

  String id;
  String title;
  String message;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "message": message,
      };
}
