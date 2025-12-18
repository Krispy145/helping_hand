class ApiEndpoints {
  static const String root = '/';
  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register';
  static const String requests = '/requests';
  static const String requestsNearby = '/requests/nearby';
  static const String sessions = '/sessions';
  static String sessionsMessages(String id) => '/sessions/$id/messages';
  static const String chatSocket = '/chat';
}
