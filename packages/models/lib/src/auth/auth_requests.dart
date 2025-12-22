import 'package:dart_mappable/dart_mappable.dart';

part 'auth_requests.mapper.dart';

@MappableClass(caseStyle: CaseStyle.snakeCase)
class LoginRequestDto with LoginRequestDtoMappable {
  final String email;
  final String password;

  const LoginRequestDto({required this.email, required this.password});
}

@MappableClass()
class RegisterRequestDto with RegisterRequestDtoMappable {
  final String email;
  final String password;
  final String name;

  const RegisterRequestDto({required this.email, required this.password, required this.name});
}
