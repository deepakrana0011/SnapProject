import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:snap_app/constants/api_constants.dart';
import 'package:snap_app/locator.dart';
import 'package:http/http.dart' as http;
import 'package:snap_app/models/history_response.dart';
import 'package:snap_app/models/login_response.dart';
import 'package:snap_app/models/register_response.dart';
import 'package:snap_app/models/success_response.dart';
import 'package:snap_app/service/fetch_data_exception.dart';

class Api{
  var client =  http.Client();
  Dio dio = locator<Dio>();


  Future<RegisterResponse> register(String email) async{
    try {
          var map = {"email": email};
          var response =
          await dio.post(ApiConstants.baseUrl + ApiConstants.loginRegisterUrl, data: map);
          return RegisterResponse.fromJson(json.decode(response.toString()));
        } on DioError catch (e) {
          if (e.response != null) {
            var errorData = jsonDecode(e.response.toString());
            var errorMessage = errorData["error"];
            throw FetchDataException(errorMessage);
          } else {
            throw const SocketException("");
          }
        }
  }

  Future<LoginResponse> login(String email) async{
    try {
      var map = {"email": email};
      var response =
      await dio.post(ApiConstants.baseUrl + ApiConstants.loginRegisterUrl, data: map);
      return LoginResponse.fromJson(json.decode(response.toString()));
    } on DioError catch (e) {
      if (e.response != null) {
        var errorData = jsonDecode(e.response.toString());
        var errorMessage = errorData["error"];
        throw FetchDataException(errorMessage);
      } else {
        throw const SocketException("");
      }
    }
  }

  Future<SuccessResponse> verifyOtp(String email, String otp) async{
    try {
      var map = {"email": email, "verifyToken" : otp};
      var response =
      await dio.post(ApiConstants.baseUrl + ApiConstants.verifyOtp, data: map);
      return SuccessResponse.fromJson(json.decode(response.toString()));
    } on DioError catch (e) {
      if (e.response != null) {
        var errorData = jsonDecode(e.response.toString());
        var errorMessage = errorData["error"];
        throw FetchDataException(errorMessage);
      } else {
        throw const SocketException("");
      }
    }
  }

  Future<SuccessResponse> resendOtp(String email) async{
    try {
      var map = {"email": email};
      var response =
      await dio.put(ApiConstants.baseUrl + ApiConstants.resendOtp, data: map);
      return SuccessResponse.fromJson(json.decode(response.toString()));
    } on DioError catch (e) {
      if (e.response != null) {
        var errorData = jsonDecode(e.response.toString());
        var errorMessage = errorData["error"];
        throw FetchDataException(errorMessage);
      } else {
        throw const SocketException("");
      }
    }
  }

  Future<SuccessResponse> sendNote(String email, String description, String token) async{
    try {
      var map = {"email": email, "description" : description};
      dio.options.headers["authorization"] = token;
      var response =
      await dio.post(ApiConstants.baseUrl + ApiConstants.sendNote, data: map);
      return SuccessResponse.fromJson(json.decode(response.toString()));
    } on DioError catch (e) {
      if (e.response != null) {
        var errorData = jsonDecode(e.response.toString());
        var errorMessage = errorData["error"];
        throw FetchDataException(errorMessage);
      } else {
        throw const SocketException("");
      }
    }
  }

  Future<SuccessResponse> sendPhoto(String token, String email, File imageFile) async{
    try {
      var map = <String, dynamic>{"email": email};
      if (imageFile != null) {
        var image = MultipartFile.fromFileSync(imageFile.path, filename: "snap.png");
        var imageMap = {
          'image': image,
        };
        map.addAll(imageMap);
      }
      dio.options.headers["authorization"] = token;
      var response =
      await dio.post(ApiConstants.baseUrl + ApiConstants.sendData, data: FormData.fromMap(map));
      return SuccessResponse.fromJson(json.decode(response.toString()));
    } on DioError catch (e) {
      if (e.response != null) {
        var errorData = jsonDecode(e.response.toString());
        var errorMessage = errorData["error"];
        throw FetchDataException(errorMessage);
      } else {
        throw const SocketException("");
      }
    }
  }

  Future<SuccessResponse> sendDocument(String token, String email, PlatformFile? documentFile) async{
    try {
      var map = <String, dynamic>{"email": email};
      if (documentFile != null) {
        var document = MultipartFile.fromFileSync(documentFile.path.toString(), filename: "snapDocument.${documentFile.extension}");
        var documentMap = {
          'image': document,
        };
        map.addAll(documentMap);
      }
      dio.options.headers["authorization"] = token;
      var response =
      await dio.post(ApiConstants.baseUrl + ApiConstants.sendData, data: FormData.fromMap(map));
      return SuccessResponse.fromJson(json.decode(response.toString()));
    } on DioError catch (e) {
      if (e.response != null) {
        var errorData = jsonDecode(e.response.toString());
        var errorMessage = errorData["error"];
        throw FetchDataException(errorMessage);
      } else {
        throw const SocketException("");
      }
    }
  }

  Future<SuccessResponse> sendRecording(String token, String email, File? recordingFile) async{
    try {
      var map = <String, dynamic>{"email": email};
      if (recordingFile != null) {
        var recording = MultipartFile.fromFileSync(recordingFile.path.toString(), filename: "snapRecording.mp4");
        var recordingMap = {
          'image': recording,
        };
        map.addAll(recordingMap);
      }
      dio.options.headers["authorization"] = token;
      var response =
      await dio.post(ApiConstants.baseUrl + ApiConstants.sendData, data: FormData.fromMap(map));
      return SuccessResponse.fromJson(json.decode(response.toString()));
    } on DioError catch (e) {
      if (e.response != null) {
        var errorData = jsonDecode(e.response.toString());
        var errorMessage = errorData["error"];
        throw FetchDataException(errorMessage);
      } else {
        throw const SocketException("");
      }
    }
  }

  Future<HistoryResponse> history(String token) async{
    try {
      dio.options.headers["authorization"] = token;
      var response =
      await dio.get(ApiConstants.baseUrl + ApiConstants.findData);
      return HistoryResponse.fromJson(json.decode(response.toString()));
    } on DioError catch (e) {
      if (e.response != null) {
        var errorData = jsonDecode(e.response.toString());
        var errorMessage = errorData["error"];
        throw FetchDataException(errorMessage);
      } else {
        throw const SocketException("");
      }
    }
  }
}