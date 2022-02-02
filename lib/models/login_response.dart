import 'package:snap_app/models/register_response.dart' as login;

class LoginResponse {
  bool? success;
  login.Data? data;

  LoginResponse.fromJson(Map<String, dynamic> parsedJson) {
    success = parsedJson['success'];
    if (parsedJson['data'] != null) {
      data = login.Data.fromJson(parsedJson['data']);
    }
  }
}

