import 'package:dart_mappable/dart_mappable.dart';

part 'user_dto.mapper.dart';

@MappableEnum()
enum UserRoleDto {
  USER,
  ADMIN,
  MODERATOR,
}

@MappableEnum()
enum VerificationStatusDto {
  UNVERIFIED,
  PENDING,
  VERIFIED,
  FAILED,
}

@MappableEnum()
enum VerificationFailureReasonDto {
  UNDERAGE,
  PROVIDER_REJECTED,
  EXPIRED,
}

@MappableClass()
class UserDto with UserDtoMappable {
  final String id;
  final String email;
  final String? name;
  final UserRoleDto role;
  final VerificationStatusDto verificationStatus;
  final DateTime? verifiedAt;
  final VerificationFailureReasonDto? verificationFailureReason;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserDto({
    required this.id,
    required this.email,
    this.name,
    required this.role,
    this.verificationStatus = VerificationStatusDto.UNVERIFIED,
    this.verifiedAt,
    this.verificationFailureReason,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get canParticipate => verificationStatus == VerificationStatusDto.VERIFIED;
}
