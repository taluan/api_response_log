class LogApiModel {
  String url = "";
  String method = "";
  String params = "";
  String header = "";
  String response = "";
  int statusCode = 0;
  DateTime createdDate = DateTime.now();
  DateTime? endRequestDate;

  bool get isSuccess => statusCode >= 200 && statusCode < 300;

  int get duration => endRequestDate != null ? endRequestDate!.difference(createdDate).inMilliseconds : 0;

  LogApiModel({this.url = "", this.method = "", this.params = "", this.header = "", this.response = "Đang chờ response"});
}