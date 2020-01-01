import 'package:dio/dio.dart';

class AppState {
  Dio dio;

  AppState() {
    dio = Dio();
    dio.options.baseUrl = "https://abode-backend.herokuapp.com";
  }
}
