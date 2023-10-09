import 'dart:convert';
import 'package:hrea_mobile_staff/app/modules/tab_view/model/user_model.dart';
import 'package:hrea_mobile_staff/app/resources/login_model.dart';
import 'package:http/http.dart' as http;
import 'package:hrea_mobile_staff/app/resources/base_link.dart';

class LoginApi {
  static Future<LoginReponseApi> login(String email, String password) async {
    print('email ${email} password ${password}');
    Map<String, String> body = {
      "email": email,
      "password": password,
    };
    var response =
        await http.post(Uri.parse(BaseLink.localBaseLink + BaseLink.login),
            headers: {
              "Accept": "application/json",
              "content-type": "application/json",
            },
            body: jsonEncode(body));
    print('abc' + response.statusCode.toString());
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future<LoginReponseApi>.value(
          LoginReponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 500 || response.statusCode == 400) {
      return Future<LoginReponseApi>.value(
          LoginReponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<UserModel> getProfile(String jwtToken) async {
    var response = await http.get(
      Uri.parse(BaseLink.localBaseLink + BaseLink.getProfile),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $jwtToken',
      },
    );
    print('abc' + response.statusCode.toString());
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future<UserModel>.value(
          UserModel.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }
}
