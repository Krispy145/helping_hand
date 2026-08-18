import 'package:dart_mappable/dart_mappable.dart';

part 'report_dto.mapper.dart';

@MappableEnum()
enum ReportTypeDto {
  HELPER_MISCONDUCT,
  HELPEE_MISUSE,
  SCAM,
  THEFT,
  UNSAFE_SITUATION,
}

@MappableEnum()
enum ReportSeverityDto {
  LOW,
  MEDIUM,
  HIGH,
}

@MappableEnum()
enum ReportStatusDto {
  NEW,
  TRIAGED,
  ACTIONED,
  REJECTED,
}

@MappableClass(caseStyle: CaseStyle.camelCase)
class CreateReportDto with CreateReportDtoMappable {
  final ReportTypeDto type;
  final String description;
  final String? sessionId;
  final String? requestId;
  final String? targetUserId;
  final bool? endSession;
  final List<String>? evidenceUrls;

  const CreateReportDto({
    required this.type,
    required this.description,
    this.sessionId,
    this.requestId,
    this.targetUserId,
    this.endSession,
    this.evidenceUrls,
  });
}

@MappableClass()
class ReportDto with ReportDtoMappable {
  final String id;
  final ReportTypeDto type;
  final ReportSeverityDto severity;
  final String description;
  final ReportStatusDto status;
  final String? sessionId;
  final String? requestId;
  final String? targetUserId;
  final bool sessionEnded;
  final bool penalizesReporter;
  final DateTime createdAt;

  const ReportDto({
    required this.id,
    required this.type,
    required this.severity,
    required this.description,
    required this.status,
    this.sessionId,
    this.requestId,
    this.targetUserId,
    required this.sessionEnded,
    required this.penalizesReporter,
    required this.createdAt,
  });
}
