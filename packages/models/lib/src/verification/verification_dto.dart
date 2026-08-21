import 'package:dart_mappable/dart_mappable.dart';

import '../user/user_dto.dart';

part 'verification_dto.mapper.dart';

@MappableClass(caseStyle: CaseStyle.camelCase)
class VerificationStubCompleteDto with VerificationStubCompleteDtoMappable {
  final String outcome;

  const VerificationStubCompleteDto({required this.outcome});
}

@MappableClass(caseStyle: CaseStyle.camelCase)
class EligibilityCheckDto with EligibilityCheckDtoMappable {
  final String dateOfBirth;

  const EligibilityCheckDto({required this.dateOfBirth});
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class EligibilityResultDto with EligibilityResultDtoMappable {
  final bool eligible;
  final int ageThreshold;

  const EligibilityResultDto({
    required this.eligible,
    required this.ageThreshold,
  });
}

@MappableClass(caseStyle: CaseStyle.snakeCase)
class VerificationStatusResponseDto with VerificationStatusResponseDtoMappable {
  final String id;
  final String email;
  final String? name;
  final UserRoleDto role;
  final VerificationStatusDto verificationStatus;
  final DateTime? verifiedAt;
  final VerificationFailureReasonDto? verificationFailureReason;
  final int? ageThreshold;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? provider;
  final String? referenceId;
  final bool stub;
  final String? launchUrl;
  final String? documentLaunchUrl;
  final DateTime? expiresAt;

  const VerificationStatusResponseDto({
    required this.id,
    required this.email,
    this.name,
    required this.role,
    this.verificationStatus = VerificationStatusDto.UNVERIFIED,
    this.verifiedAt,
    this.verificationFailureReason,
    this.ageThreshold,
    required this.createdAt,
    required this.updatedAt,
    this.provider,
    this.referenceId,
    this.stub = false,
    this.launchUrl,
    this.documentLaunchUrl,
    this.expiresAt,
  });

  bool get isVerified => verificationStatus == VerificationStatusDto.VERIFIED;

  bool get needsDocument =>
      verificationStatus == VerificationStatusDto.REQUIRES_DOCUMENT;

  bool get isUnderage =>
      verificationFailureReason == VerificationFailureReasonDto.UNDERAGE;
}
