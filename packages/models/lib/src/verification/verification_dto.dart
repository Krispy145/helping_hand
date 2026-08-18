import 'package:dart_mappable/dart_mappable.dart';

part 'verification_dto.mapper.dart';

@MappableClass(caseStyle: CaseStyle.camelCase)
class VerificationStubCompleteDto with VerificationStubCompleteDtoMappable {
  final String outcome;

  const VerificationStubCompleteDto({required this.outcome});
}
