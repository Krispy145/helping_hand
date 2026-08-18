import 'package:dart_mappable/dart_mappable.dart';

part 'vetting_dto.mapper.dart';

@MappableClass()
class HelplineDto with HelplineDtoMappable {
  final String name;
  final String phone;
  final String? region;

  const HelplineDto({required this.name, required this.phone, this.region});
}

@MappableClass()
class VettingFeedbackDto with VettingFeedbackDtoMappable {
  final String? triggeredRule;
  final String? reasonCode;
  final String? userMessage;
  final bool showHelplines;
  final List<HelplineDto> helplines;

  const VettingFeedbackDto({
    this.triggeredRule,
    this.reasonCode,
    this.userMessage,
    this.showHelplines = false,
    this.helplines = const [],
  });
}
