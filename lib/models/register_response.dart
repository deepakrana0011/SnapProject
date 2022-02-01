import 'package:snap_app/models/success_response.dart';

class RegisterResponse extends SuccessResponse {
  late Data data;
  late String jwtToken;

  RegisterResponse.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    if (parsedJson['data'] != null) {
      data = Data.fromJson(parsedJson['data']);
    }
    jwtToken = parsedJson['jwtToken'];
  }
}

class Data {
  late String message;

  Data.fromJson(Map<String, dynamic> parsedJson) {
    message = parsedJson['message'];
  }
}
