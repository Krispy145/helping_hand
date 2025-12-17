import 'package:dart_mappable/dart_mappable.dart';
import '../user/user_dto.dart';

part 'auth_responses.mapper.dart';

@MappableClass()
class AuthResponseDto with AuthResponseDtoMappable {
  final String accessToken;
  final UserDto user;

  const AuthResponseDto({
    required this.accessToken,
    required this.user,
  });
}
