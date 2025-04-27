/// Support for doing something awesome.
///
/// More dartdocs go here.
library;

import 'dart:developer';

import 'package:api_response_log/src/model/log_api_model.dart';

export 'src/model/log_api_model.dart';
export 'src/log_api_page.dart';

// TODO: Export any libraries intended for clients of this package.
mixin ApiLog {
  static int maxItem = 50;
  static List<LogApiModel> _datas = [];

  static List<LogApiModel> get datas => _datas;

  static void clear() {
    _datas.clear();
  }

  static void addApiLog(LogApiModel log, {bool enabled = true}) {
    if (enabled) {
      _datas.insert(0, log);
      if (_datas.length > maxItem) {
        _datas.removeRange(maxItem, _datas.length);
      }
    }
  }
  static void addLog({required String url, String? header, String? method, String? param, String? response, int statusCode = 200}) {
    try {
      LogApiModel logApiModel = LogApiModel(
          url: url, method: method ?? "",
          params: param ?? "", header: header ?? "",);
      logApiModel.response = response ?? "";
      logApiModel.statusCode = statusCode;
      addApiLog(logApiModel);
    }catch(e) {
      log("log api error: ${e.toString()}");
    }
  }
}