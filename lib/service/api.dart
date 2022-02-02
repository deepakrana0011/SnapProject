import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:snap_app/constants/api_constants.dart';
import 'package:snap_app/locator.dart';
import 'package:http/http.dart' as http;
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
}