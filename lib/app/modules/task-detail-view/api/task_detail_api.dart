import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/model/task.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/model/user_model.dart';
import 'package:hrea_mobile_staff/app/resources/base_link.dart';
import 'package:hrea_mobile_staff/app/resources/response_api_model.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';

class TaskDetailApi {
  static Future<TaskModel> getTaskDetail(String jwtToken, String taskID) async {
    var response = await http.get(
      Uri.parse(
          '${BaseLink.localBaseLink}${BaseLink.getTask}?fieldName=id&conValue=$taskID&sizePage=10&currentPage=1'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $jwtToken',
      },
    );
    print('abc task' + response.statusCode.toString());
    if (response.statusCode == 201 || response.statusCode == 200) {
      // TaskModel.fromJson(jsonDecode(jsonData));

      return Future<TaskModel>.value(
          TaskModel.fromJson(jsonDecode(response.body)["result"][0]));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<UserModel> getAssignerDetail(
      String jwtToken, String assignerID) async {
    var response = await http.get(
      Uri.parse(
          '${BaseLink.localBaseLink}${BaseLink.getAssignerInformation}$assignerID'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $jwtToken',
      },
    );
    print('abc assginer' + response.statusCode.toString());
    if (response.statusCode == 201 || response.statusCode == 200) {
      // TaskModel.fromJson(jsonDecode(jsonData));

      return Future<UserModel>.value(
          UserModel.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ResponseApi> updateStatusTask(
      String jwtToken, String taskID, String status) async {
    // Map<String, String> body = {
    //   "taskID": taskID,
    //   "status": status,
    // };
    print(taskID);

    var response = await http.put(
      Uri.parse(
          '${BaseLink.localBaseLink}${BaseLink.updateStatusTask}?taskID=$taskID&status=$status'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $jwtToken',
      },
      // body: jsonEncode(body));
    );
    print('abc updateStatusTask' + response.statusCode.toString());

    if (response.statusCode == 201 || response.statusCode == 200) {
      // TaskModel.fromJson(jsonDecode(jsonData));

      return Future<ResponseApi>.value(
          ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      return Future<ResponseApi>.value(
          ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ResponseApi> updateFileTask(
      String jwtToken, String taskID, String fileUrl) async {
    Map<String, String> body = {
      "taskID": taskID,
      "fileUrl": fileUrl,
    };
    print(taskID);

    var response = await http.post(
        Uri.parse('${BaseLink.localBaseLink}${BaseLink.updateFileTask}'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(body));

    print('abc updateFile' + response.statusCode.toString());

    if (response.statusCode == 201 || response.statusCode == 200) {
      // TaskModel.fromJson(jsonDecode(jsonData));

      return Future<ResponseApi>.value(
          ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      return Future<ResponseApi>.value(
          ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ResponseApi> updateDescriptionTask(String jwtToken,
      String taskID, String eventID, String description) async {
    Map<String, String> body = {
      "description": description,
      "eventID": eventID,
    };
    print(taskID);

    var response = await http.put(
        Uri.parse(
            '${BaseLink.localBaseLink}${BaseLink.updateTask}?taskID=$taskID'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(body));

    print('abc updateStatusTask' + response.statusCode.toString());

    if (response.statusCode == 201 || response.statusCode == 200) {
      // TaskModel.fromJson(jsonDecode(jsonData));

      return Future<ResponseApi>.value(
          ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      return Future<ResponseApi>.value(
          ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ResponseApi> createSubTask(
      String jwtToken,
      String title,
      String eventID,
      // String startDate,
      // String endDate,
      // String priority,
      // int estimationTime,
      String parentTask) async {
    Map<String, dynamic> body = {
      "title": title,
      "eventID": eventID,
      "startDate": "2023-10-18T16:26:26.728Z",
      "endDate": "2023-10-18T16:26:26.728Z",
      "desc": "",
      "priority": "LOW",
      "estimationTime": 1,
      "parentTask": parentTask,
      "assignee": [],
    };

    var response = await http.post(
        Uri.parse('${BaseLink.localBaseLink}${BaseLink.createSubTask}'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(body));

    print('abc updateStatusTask' + response.statusCode.toString());

    if (response.statusCode == 201 || response.statusCode == 200) {
      // TaskModel.fromJson(jsonDecode(jsonData));

      return Future<ResponseApi>.value(
          ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      return Future<ResponseApi>.value(
          ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ResponseApi> createComment(
      String jwtToken, String taskID, String content) async {
    Map<String, dynamic> body = {
      "taskID": taskID,
      "content": content,
    };

    var response = await http.post(
        Uri.parse('${BaseLink.localBaseLink}${BaseLink.getTask}'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(body));

    print('abc comment' + response.statusCode.toString());
    if (response.statusCode == 201 || response.statusCode == 200) {
      // TaskModel.fromJson(jsonDecode(jsonData));

      return Future<ResponseApi>.value(
          ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      // TaskModel.fromJson(jsonDecode(jsonData));

      return Future<ResponseApi>.value(
          ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ResponseApi> uploadFile(
      String jwtToken, File file, String extension) async {
    final uri = Uri.parse(BaseLink.localBaseLink + BaseLink.uploadFile);
    var contentType;
    if (extension == 'doc' || extension == 'docx') {
      contentType = MediaType('application',
          'vnd.openxmlformats-officedocument.wordprocessingml.document');
    } else if (extension == "xlsx") {
      contentType = MediaType('application',
          'vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    } else if (extension == "jpg") {
      contentType = MediaType('image', 'jpg');
    } else if (extension == "jpeg") {
      contentType = MediaType('image', 'jpeg');
    } else if (extension == "png") {
      contentType = MediaType('image', 'png');
    } else if (extension == "pdf") {
      contentType = MediaType('application', 'pdf');
    }
    http.MultipartRequest request = http.MultipartRequest('POST', uri);
    http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
        'file', file.path,
        contentType: contentType, filename: file.path.split('/').last);
    request.files.add(multipartFile);
    request.headers.addAll(_header(jwtToken));
    request.fields['folderName'] = 'task';
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    print(response.body);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future<ResponseApi>.value(
          ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 500 || response.statusCode == 400) {
      return Future<ResponseApi>.value(
          ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }
}

_header(String token) {
  return {
    "Content-Type": "multipart/form-data",
    "Authorization": "Bearer $token",
  };
}
