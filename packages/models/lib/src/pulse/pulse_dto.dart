import 'package:dart_mappable/dart_mappable.dart';
import '../requests/request_dto.dart';

part 'pulse_dto.mapper.dart';

@MappableEnum()
enum AppealStatusDto {
  OPEN,
  UPHELD,
  OVERTURNED,
}

@MappableClass()
class PulseSummaryDto with PulseSummaryDtoMappable {
  final int sessionsCompleted;
  final int requestsHelped;
  final int requestsRejected;
  final int reportsFiled;
  final int crisisSupportRoutes;
  final int harmReports;
  final int minCount;

  const PulseSummaryDto({
    required this.sessionsCompleted,
    required this.requestsHelped,
    required this.requestsRejected,
    required this.reportsFiled,
    required this.crisisSupportRoutes,
    required this.harmReports,
    this.minCount = 5,
  });
}

@MappableClass()
class PulseQueueItemDto with PulseQueueItemDtoMappable {
  final String appealId;
  final AppealStatusDto status;
  final String reason;
  final DateTime createdAt;
  final RequestDto request;
  final String? triggeredRule;
  final String? reasonCode;

  const PulseQueueItemDto({
    required this.appealId,
    required this.status,
    required this.reason,
    required this.createdAt,
    required this.request,
    this.triggeredRule,
    this.reasonCode,
  });
}

@MappableClass()
class CreateAppealDto with CreateAppealDtoMappable {
  final String? reason;

  const CreateAppealDto({this.reason});
}
