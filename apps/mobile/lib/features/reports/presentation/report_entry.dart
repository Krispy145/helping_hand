import 'package:models/models.dart';

class ReportEntry {
  final String? sessionId;
  final String? requestId;
  final String? targetUserId;
  final ReportTypeDto? suggestedType;
  final bool sessionActive;

  const ReportEntry({
    this.sessionId,
    this.requestId,
    this.targetUserId,
    this.suggestedType,
    this.sessionActive = false,
  });
}
