class LoginResponse {
  bool? success;
  Data? data;

  LoginResponse.fromJson(Map<String, dynamic> parsedJson) {
    success = parsedJson['success'];
    if (parsedJson['data'] != null) {
      data = Data.fromJson(parsedJson['data']);
    }
  }
}

class Data {
  String? id;
  String? email;
  int? verifyToken;
  int? verifyStatus;

  Data.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson['_id'];
    email = parsedJson['email'];
    verifyToken = parsedJson['verifyToken'];
    verifyStatus = parsedJson['verifyStatus'];
  }
}
