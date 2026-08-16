class ApiEndpoints {
  static const String root = '/';
  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register';
  static const String authMe = '/auth/me';
  static const String requests = '/requests';
  static const String requestsNearby = '/requests/nearby';
  static const String sessions = '/sessions';
  static const String sessionsAvailability = '/sessions/availability';
  static String session(String id) => '/sessions/$id';
  static String sessionsMessages(String id) => '/sessions/$id/messages';
  static String sessionCancel(String id) => '/sessions/$id/cancel';
  static String sessionComplete(String id) => '/sessions/$id/complete';
  static const String chatSocket = '/chat';
}
