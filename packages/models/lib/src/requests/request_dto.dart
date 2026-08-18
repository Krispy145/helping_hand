import 'package:dart_mappable/dart_mappable.dart';
import '../user/user_dto.dart';
import '../vetting/vetting_dto.dart';

part 'request_dto.mapper.dart';

@MappableEnum()
enum RequestStatusDto {
  PENDING_VETTING,
  APPROVED,
  REJECTED,
  IN_PROGRESS,
  COMPLETED,
  CANCELLED,
}

@MappableEnum()
enum RequestUrgencyDto {
  LOW,
  MEDIUM,
  HIGH,
  CRITICAL,
}

@MappableClass()
class RequestDto with RequestDtoMappable {
  final String id;
  final String title;
  final String description;
  final String? category;
  final RequestStatusDto status;
  final RequestUrgencyDto urgency;
  final double? lat;
  final double? lng;
  final DateTime createdAt;
  final DateTime updatedAt;
  final VettingFeedbackDto? vetting;
  final UserDto? user; // Optional for list views where user might be separate calls, but good to have.

  const RequestDto({
    required this.id,
    required this.title,
    required this.description,
    this.category,
    required this.status,
    required this.urgency,
    this.lat,
    this.lng,
    required this.createdAt,
    required this.updatedAt,
    this.vetting,
    this.user,
  });
}

@MappableClass()
class CreateRequestDto with CreateRequestDtoMappable {
  final String title;
  final String description;
  final String category;
  final RequestUrgencyDto urgency;
  final double? lat;
  final double? lng;

  const CreateRequestDto({
    required this.title,
    required this.description,
    required this.category,
    required this.urgency,
    this.lat,
    this.lng,
  });
}
