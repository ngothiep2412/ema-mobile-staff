import 'dart:convert';
import 'dart:io';
import 'package:hrea_mobile_staff/app/modules/tab_view/model/task.dart';
import 'package:hrea_mobile_staff/app/modules/tab_view/model/user_model.dart';
import 'package:hrea_mobile_staff/app/modules/task-detail-view/model/comment_model.dart';
import 'package:hrea_mobile_staff/app/modules/task-detail-view/model/file_model.dart';
import 'package:hrea_mobile_staff/app/modules/task-detail-view/model/item_model.dart';
import 'package:hrea_mobile_staff/app/modules/task-detail-view/model/uploadfile_model.dart';
import 'package:hrea_mobile_staff/app/resources/base_link.dart';
import 'package:hrea_mobile_staff/app/resources/response_api_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class TaskDetailApi {
  static Future<TaskModel> getTaskDetail(String jwtToken, String taskID) async {
    var response = await http.get(
      Uri.parse('${BaseLink.localBaseLink}${BaseLink.getTask}?fieldName=id&conValue=$taskID&sizePage=10&currentPage=1'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      // TaskModel.fromJson(jsonDecode(jsonData));

      return Future<TaskModel>.value(TaskModel.fromJson(jsonDecode(response.body)["result"][0]));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ResponseApi> updateTaskFile(String jwtToken, String taskID, List<TaskFile> listTaskFile) async {
    var response = await http.put(Uri.parse('${BaseLink.localBaseLink}${BaseLink.updateTaskFile}$taskID'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(listTaskFile));

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ResponseApi> updateCommentFile(String jwtToken, String commentID, List<CommentFile> listCommentFile) async {
    var response = await http.put(Uri.parse('${BaseLink.localBaseLink}${BaseLink.updateCommentFile}$commentID'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(listCommentFile));

    if (response.statusCode == 201 || response.statusCode == 200) {
      // TaskModel.fromJson(jsonDecode(jsonData));

      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ResponseApi> updateComment(String jwtToken, String commentID, String content, List<CommentFile> listCommentFile) async {
    Map<String, dynamic> body = {
      "content": content,
      "file": listCommentFile,
    };

    var response = await http.put(Uri.parse('${BaseLink.localBaseLink}${BaseLink.updateComment}$commentID'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(body));

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<List<CommentModel>> getAllComment(String jwtToken, String taskID) async {
    var response = await http.get(
      Uri.parse('${BaseLink.localBaseLink}${BaseLink.getAllComment}/$taskID'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $jwtToken',
      },
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      var jsonData = jsonDecode(response.body)["result"];
      List<CommentModel> listComment = [];
      listComment.addAll(jsonData.map((events) => CommentModel.fromJson(events)).cast<CommentModel>());
      return listComment;
    } else {
      throw Exception('Exception');
    }
  }

  static Future<UserModel> getAssignerDetail(String jwtToken, String assignerID) async {
    var response = await http.get(
      Uri.parse('${BaseLink.localBaseLink}${BaseLink.getAssignerInformation}$assignerID'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $jwtToken',
      },
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      // TaskModel.fromJson(jsonDecode(jsonData));

      return Future<UserModel>.value(UserModel.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ResponseApi> updateStatusTask(String jwtToken, String taskID, String status) async {
    var response = await http.put(
      Uri.parse('${BaseLink.localBaseLink}${BaseLink.updateStatusTask}?taskID=$taskID&status=$status'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $jwtToken',
      },
      // body: jsonEncode(body));
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ResponseApi> updateTitleTask(String jwtToken, String taskID, String eventID, String title) async {
    Map<String, String> body = {
      "title": title,
      "eventID": eventID,
    };

    var response = await http.put(Uri.parse('${BaseLink.localBaseLink}${BaseLink.updateTask}?taskID=$taskID'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(body));

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ResponseApi> updateFileTask(String jwtToken, String taskID, String fileUrl, String fileName) async {
    Map<String, String> body = {
      "taskID": taskID,
      "fileName": fileName,
      "fileUrl": fileUrl,
    };

    var response = await http.post(Uri.parse('${BaseLink.localBaseLink}${BaseLink.updateFileTask}'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(body));

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ResponseApi> updateDescriptionTask(String jwtToken, String taskID, String eventID, String description) async {
    Map<String, String> body = {
      "description": description,
      "eventID": eventID,
    };

    var response = await http.put(Uri.parse('${BaseLink.localBaseLink}${BaseLink.updateTask}?taskID=$taskID'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(body));

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ResponseApi> createSubTask(String jwtToken, String title, String eventID, String parentTask, String itemID) async {
    Map<String, dynamic> body = {
      "title": title,
      "eventID": eventID,
      "desc": "",
      "parentTask": parentTask,
      "priority": "LOW",
      "assignee": [],
      "progress": 0,
      "itemId": itemID,
    };

    var response = await http.post(Uri.parse('${BaseLink.localBaseLink}${BaseLink.createSubTask}'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(body));

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ResponseApi> deleteComment(String jwtToken, String commentID) async {
    var response = await http.delete(Uri.parse('${BaseLink.localBaseLink}${BaseLink.deleteComment}$commentID'), headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      'Authorization': 'Bearer $jwtToken',
    });

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ResponseApi> createComment(String jwtToken, String taskID, String content, List<FileModel> file) async {
    Map<String, dynamic> body = {"taskID": taskID, "content": content, "file": file};

    var response = await http.post(Uri.parse('${BaseLink.localBaseLink}${BaseLink.createComment}'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(body));

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<UploadFileModel> uploadFile(String jwtToken, File file, String extension, String type) async {
    final uri = Uri.parse(BaseLink.localBaseLink + BaseLink.uploadFile);
    MediaType contentType = MediaType('', '');
    if (extension == 'doc' || extension == 'docx') {
      contentType = MediaType('application', 'vnd.openxmlformats-officedocument.wordprocessingml.document');
    } else if (extension == "xlsx") {
      contentType = MediaType('application', 'vnd.openxmlformats-officedocument.spreadsheetml.sheet');
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
    http.MultipartFile multipartFile =
        await http.MultipartFile.fromPath('file', file.path, contentType: contentType, filename: file.path.split('/').last);
    request.files.add(multipartFile);
    request.headers.addAll(_header(jwtToken));
    request.fields['folderName'] = type;
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future<UploadFileModel>.value(UploadFileModel.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 500 || response.statusCode == 400) {
      return Future<UploadFileModel>.value(UploadFileModel.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<ResponseApi> updateEffort(String jwtToken, String taskID, String eventID, double effort) async {
    Map<String, String> body = {
      "effort": effort.toString(),
      "eventID": eventID,
    };

    var response = await http.put(Uri.parse('${BaseLink.localBaseLink}${BaseLink.updateTask}?taskID=$taskID'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(body));

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<List<ItemModel>> getAllItem(String jwtToken, String userID, String eventID) async {
    var response = await http.get(
      Uri.parse('${BaseLink.localBaseLink}${BaseLink.getAllItem}?assignee=$userID&eventID=$eventID'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $jwtToken',
      },
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      var jsonData = jsonDecode(response.body)["result"];
      List<ItemModel> listItem = [];
      listItem.addAll(jsonData.map((events) => ItemModel.fromJson(events)).cast<ItemModel>());
      return listItem;
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
