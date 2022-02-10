import 'package:snap_app/models/success_response.dart';

class HistoryResponse extends SuccessResponse{

  List<Data>? data = [];

  HistoryResponse.fromJson(Map<String, dynamic> parsedJson) : super.fromJson(parsedJson){
    if(parsedJson['data'] != null){
      List<Data>? list = [];
      for(int i = 0 ; i < parsedJson['data'].length ; i++){
        list.add(Data.fromJson(parsedJson['data'][i]));
      }
      data = list;
    }
  }
}

class Data{
  String? id;
  String? userId;
  String? email;
  String? description;
  int? status;
  String? createdAt;

  Data.fromJson(Map<String, dynamic> parsedJson){
    id = parsedJson['_id'];
    userId = parsedJson['userId'];
    email = parsedJson['email'];
    description = parsedJson['description'];
    status = parsedJson['status'];
    createdAt = parsedJson['createdAt'];
  }
}