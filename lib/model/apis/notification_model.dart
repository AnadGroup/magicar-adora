import 'package:meta/meta.dart';

class NotificationModelApi {
  int NotifId;
  int DeviceId;
  int ActionId;
  String Status;
  bool IsRead;
  String CreatedDate;
  String LastUpdateDate;
  NotificationModelApi(
      {@required this.NotifId,
      @required this.DeviceId,
      @required this.ActionId,
      @required this.IsRead,
      @required this.Status,
      @required this.CreatedDate,
      @required this.LastUpdateDate});

  Map<String, dynamic> toJson() {
    return {
      "NotifId": this.NotifId,
      "DeviceId": this.DeviceId,
      "ActionId": this.ActionId,
      "Status": this.Status,
    };
  }

  factory NotificationModelApi.fromJson(Map<String, dynamic> json) {
    return NotificationModelApi(
        NotifId: json["NotifId"],
        ActionId: json["ActionId"],
        DeviceId: json["DeviceId"],
        Status: json["Status"]);
  }
}
