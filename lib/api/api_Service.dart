import 'package:http/http.dart' as http;
import 'package:nk_global_ft/model/image_model.dart';
import 'dart:convert';

import 'package:nk_global_ft/model/login_model.dart';
import 'package:nk_global_ft/model/common_model.dart';
import 'package:nk_global_ft/model/mainSchedule_model.dart';
import 'package:nk_global_ft/model/master_model.dart';
import 'package:nk_global_ft/model/portlist_model.dart';
import 'package:nk_global_ft/model/schedule_model.dart';

class APIService {
  var url = Uri.parse('https://www.kuls.co.kr/NK/flutter/DBHelper.php');

  Future getSelect(String sFunctionName, List<String> sParam) async {
    var result;
    var sBody = jsonEncode(
        {"TYPE": "SELECT", "FUNCNAME": sFunctionName, "PARAMS": sParam});
    var headers = {'Content-Type': "application/json"};

    switch (sFunctionName) {
      case "CALENDAR_S1":
        final response = await http.post(url, body: sBody, headers: headers);
        result = ScheduleResultModel.fromJson(json.decode(response.body));
        break;
      case "LOGIN_S1":
        final response = await http.post(url, body: sBody, headers: headers);
        result = UserResultModel.fromJson(json.decode(response.body));
        break;
      case "MAIN_S1":
        final response = await http.post(url, body: sBody, headers: headers);
        result = MainSchResultModel.fromJson(json.decode(response.body));
        break;
      case "MASTER_S1":
        final response = await http.post(url, body: sBody, headers: headers);
        result = MasterResultModel.fromJson(json.decode(response.body));
        break;
      case "HISTORY_S1":
        final response = await http.post(url, body: sBody, headers: headers);
        result = MainSchResultModel.fromJson(json.decode(response.body));
        break;
      case "HISTORY_S2":
        final response = await http.post(url, body: sBody, headers: headers);
        result = MainSchResultModel.fromJson(json.decode(response.body));
        break;
      case "IMAGE_S1":
        final response = await http.post(url, body: sBody, headers: headers);
        result = ImageResultModel.fromJson(json.decode(response.body));
        break;
      case "IMAGE_S2":
        final response = await http.post(url, body: sBody, headers: headers);
        result = ImageResultModel.fromJson(json.decode(response.body));
        break;
      case "MAIN_S2":
        final response = await http.post(url, body: sBody, headers: headers);
        result = PortlistResultModel.fromJson(json.decode(response.body));
        break;
      default:
        break;
    }
    return result;
  }

  Future getInsert(String sFunctionName, List<String> sParam) async {
    var result;
    var sBody = jsonEncode(
        {"TYPE": "INSERT", "FUNCNAME": sFunctionName, "PARAMS": sParam});
    var headers = {'Content-Type': "application/json"};

    switch (sFunctionName) {
      case "FILE_I1":
        final response = await http.post(url, body: sBody, headers: headers);
        result = resultModel.fromJson(json.decode(response.body));
        break;
      default:
        break;
    }
    return result;
  }

  Future getUpdate(String sFunctionName, List<String> sParam) async {
    var result;
    var sBody = jsonEncode(
        {"TYPE": "UPDATE", "FUNCNAME": sFunctionName, "PARAMS": sParam});
    var headers = {'Content-Type': "application/json"};

    switch (sFunctionName) {
      case "BOARD_U1":
        final response = await http.post(url, body: sBody, headers: headers);
        result = resultModel.fromJson(json.decode(response.body));
        break;
      case "MASTER_U1":
        final response = await http.post(url, body: sBody, headers: headers);
        result = resultModel.fromJson(json.decode(response.body));
        break;
      case "MASTER_U2":
        final response = await http.post(url, body: sBody, headers: headers);
        result = resultModel.fromJson(json.decode(response.body));
        break;
      default:
        break;
    }
    return result;
  }

  Future getDelete(String sFunctionName, List<String> sParam) async {
    var result;
    var sBody = jsonEncode(
        {"TYPE": "DELETE", "FUNCNAME": sFunctionName, "PARAMS": sParam});
    var headers = {'Content-Type': "application/json"};

    switch (sFunctionName) {
      case "HISTORY_APP_D1":
        final response = await http.post(url, body: sBody, headers: headers);
        result = resultModel.fromJson(json.decode(response.body));
        break;
      default:
        break;
    }
    return result;
  }
}
