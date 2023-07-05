class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 1000);
  static const String baseUrl = "http://10.0.2.2:4000";
  // static const String baseUrl = "http://192.168.4.4:4000";
  // static const String baseUrl = "http://172.26.0.95:4000";

  //===================Routes=====================================
  static const String signIn = "/users/signIn";
  static const String signUp = "/users/signUp";
}
