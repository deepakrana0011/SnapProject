class SuccessResponse{

  late bool success;
  late String message = "verify";

  SuccessResponse();

  SuccessResponse.fromJson(Map<String, dynamic> parsedJson){
    success = parsedJson['success'];
    message = parsedJson['message'];
  }
}