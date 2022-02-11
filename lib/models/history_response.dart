import 'package:snap_app/models/success_response.dart';

class HistoryResponse extends SuccessResponse{
  //type : 1 == Note
  //type : 2 == Image
  //type : 3 == Document
  //type : 4 == Recording

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
  String? image;
  int? status;
  String? createdAt;
  String? type;

  Data.fromJson(Map<String, dynamic> parsedJson){
    id = parsedJson['_id'];
    userId = parsedJson['userId'];
    email = parsedJson['email'];
    description = parsedJson['description'] != null ? parsedJson['description'] : "";
    image = parsedJson['image'] != null ? parsedJson['image'] : "";
    status = parsedJson['status'];
    createdAt = parsedJson['createdAt'];
    type = parsedJson['type'];
  }
}