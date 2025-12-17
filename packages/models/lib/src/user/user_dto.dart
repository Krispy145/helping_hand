import 'package:dart_mappable/dart_mappable.dart';

part 'user_dto.mapper.dart';

@MappableEnum()
enum UserRoleDto {
  USER,
  ADMIN,
  MODERATOR,
}

@MappableClass()
class UserDto with UserDtoMappable {
  final String id;
  final String email;
  final String? name;
  final UserRoleDto role;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserDto({
    required this.id,
    required this.email,
    this.name,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });
}
