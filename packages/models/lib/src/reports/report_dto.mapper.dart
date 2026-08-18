// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'report_dto.dart';

class ReportTypeDtoMapper extends EnumMapper<ReportTypeDto> {
  ReportTypeDtoMapper._();

  static ReportTypeDtoMapper? _instance;
  static ReportTypeDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ReportTypeDtoMapper._());
    }
    return _instance!;
  }

  static ReportTypeDto fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  ReportTypeDto decode(dynamic value) {
    switch (value) {
      case r'HELPER_MISCONDUCT':
        return ReportTypeDto.HELPER_MISCONDUCT;
      case r'HELPEE_MISUSE':
        return ReportTypeDto.HELPEE_MISUSE;
      case r'SCAM':
        return ReportTypeDto.SCAM;
      case r'THEFT':
        return ReportTypeDto.THEFT;
      case r'UNSAFE_SITUATION':
        return ReportTypeDto.UNSAFE_SITUATION;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(ReportTypeDto self) {
    switch (self) {
      case ReportTypeDto.HELPER_MISCONDUCT:
        return r'HELPER_MISCONDUCT';
      case ReportTypeDto.HELPEE_MISUSE:
        return r'HELPEE_MISUSE';
      case ReportTypeDto.SCAM:
        return r'SCAM';
      case ReportTypeDto.THEFT:
        return r'THEFT';
      case ReportTypeDto.UNSAFE_SITUATION:
        return r'UNSAFE_SITUATION';
    }
  }
}

extension ReportTypeDtoMapperExtension on ReportTypeDto {
  String toValue() {
    ReportTypeDtoMapper.ensureInitialized();
    return MapperContainer.globals.toValue<ReportTypeDto>(this) as String;
  }
}

class ReportSeverityDtoMapper extends EnumMapper<ReportSeverityDto> {
  ReportSeverityDtoMapper._();

  static ReportSeverityDtoMapper? _instance;
  static ReportSeverityDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ReportSeverityDtoMapper._());
    }
    return _instance!;
  }

  static ReportSeverityDto fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  ReportSeverityDto decode(dynamic value) {
    switch (value) {
      case r'LOW':
        return ReportSeverityDto.LOW;
      case r'MEDIUM':
        return ReportSeverityDto.MEDIUM;
      case r'HIGH':
        return ReportSeverityDto.HIGH;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(ReportSeverityDto self) {
    switch (self) {
      case ReportSeverityDto.LOW:
        return r'LOW';
      case ReportSeverityDto.MEDIUM:
        return r'MEDIUM';
      case ReportSeverityDto.HIGH:
        return r'HIGH';
    }
  }
}

extension ReportSeverityDtoMapperExtension on ReportSeverityDto {
  String toValue() {
    ReportSeverityDtoMapper.ensureInitialized();
    return MapperContainer.globals.toValue<ReportSeverityDto>(this) as String;
  }
}

class ReportStatusDtoMapper extends EnumMapper<ReportStatusDto> {
  ReportStatusDtoMapper._();

  static ReportStatusDtoMapper? _instance;
  static ReportStatusDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ReportStatusDtoMapper._());
    }
    return _instance!;
  }

  static ReportStatusDto fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  ReportStatusDto decode(dynamic value) {
    switch (value) {
      case r'NEW':
        return ReportStatusDto.NEW;
      case r'TRIAGED':
        return ReportStatusDto.TRIAGED;
      case r'ACTIONED':
        return ReportStatusDto.ACTIONED;
      case r'REJECTED':
        return ReportStatusDto.REJECTED;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(ReportStatusDto self) {
    switch (self) {
      case ReportStatusDto.NEW:
        return r'NEW';
      case ReportStatusDto.TRIAGED:
        return r'TRIAGED';
      case ReportStatusDto.ACTIONED:
        return r'ACTIONED';
      case ReportStatusDto.REJECTED:
        return r'REJECTED';
    }
  }
}

extension ReportStatusDtoMapperExtension on ReportStatusDto {
  String toValue() {
    ReportStatusDtoMapper.ensureInitialized();
    return MapperContainer.globals.toValue<ReportStatusDto>(this) as String;
  }
}

class CreateReportDtoMapper extends ClassMapperBase<CreateReportDto> {
  CreateReportDtoMapper._();

  static CreateReportDtoMapper? _instance;
  static CreateReportDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CreateReportDtoMapper._());
      ReportTypeDtoMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'CreateReportDto';

  static ReportTypeDto _$type(CreateReportDto v) => v.type;
  static const Field<CreateReportDto, ReportTypeDto> _f$type = Field(
    'type',
    _$type,
  );
  static String _$description(CreateReportDto v) => v.description;
  static const Field<CreateReportDto, String> _f$description = Field(
    'description',
    _$description,
  );
  static String? _$sessionId(CreateReportDto v) => v.sessionId;
  static const Field<CreateReportDto, String> _f$sessionId = Field(
    'sessionId',
    _$sessionId,
    opt: true,
  );
  static String? _$requestId(CreateReportDto v) => v.requestId;
  static const Field<CreateReportDto, String> _f$requestId = Field(
    'requestId',
    _$requestId,
    opt: true,
  );
  static String? _$targetUserId(CreateReportDto v) => v.targetUserId;
  static const Field<CreateReportDto, String> _f$targetUserId = Field(
    'targetUserId',
    _$targetUserId,
    opt: true,
  );
  static bool? _$endSession(CreateReportDto v) => v.endSession;
  static const Field<CreateReportDto, bool> _f$endSession = Field(
    'endSession',
    _$endSession,
    opt: true,
  );
  static List<String>? _$evidenceUrls(CreateReportDto v) => v.evidenceUrls;
  static const Field<CreateReportDto, List<String>> _f$evidenceUrls = Field(
    'evidenceUrls',
    _$evidenceUrls,
    opt: true,
  );

  @override
  final MappableFields<CreateReportDto> fields = const {
    #type: _f$type,
    #description: _f$description,
    #sessionId: _f$sessionId,
    #requestId: _f$requestId,
    #targetUserId: _f$targetUserId,
    #endSession: _f$endSession,
    #evidenceUrls: _f$evidenceUrls,
  };

  static CreateReportDto _instantiate(DecodingData data) {
    return CreateReportDto(
      type: data.dec(_f$type),
      description: data.dec(_f$description),
      sessionId: data.dec(_f$sessionId),
      requestId: data.dec(_f$requestId),
      targetUserId: data.dec(_f$targetUserId),
      endSession: data.dec(_f$endSession),
      evidenceUrls: data.dec(_f$evidenceUrls),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static CreateReportDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CreateReportDto>(map);
  }

  static CreateReportDto fromJson(String json) {
    return ensureInitialized().decodeJson<CreateReportDto>(json);
  }
}

mixin CreateReportDtoMappable {
  String toJson() {
    return CreateReportDtoMapper.ensureInitialized()
        .encodeJson<CreateReportDto>(this as CreateReportDto);
  }

  Map<String, dynamic> toMap() {
    return CreateReportDtoMapper.ensureInitialized().encodeMap<CreateReportDto>(
      this as CreateReportDto,
    );
  }

  CreateReportDtoCopyWith<CreateReportDto, CreateReportDto, CreateReportDto>
  get copyWith =>
      _CreateReportDtoCopyWithImpl<CreateReportDto, CreateReportDto>(
        this as CreateReportDto,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return CreateReportDtoMapper.ensureInitialized().stringifyValue(
      this as CreateReportDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return CreateReportDtoMapper.ensureInitialized().equalsValue(
      this as CreateReportDto,
      other,
    );
  }

  @override
  int get hashCode {
    return CreateReportDtoMapper.ensureInitialized().hashValue(
      this as CreateReportDto,
    );
  }
}

extension CreateReportDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CreateReportDto, $Out> {
  CreateReportDtoCopyWith<$R, CreateReportDto, $Out> get $asCreateReportDto =>
      $base.as((v, t, t2) => _CreateReportDtoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class CreateReportDtoCopyWith<$R, $In extends CreateReportDto, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>?
  get evidenceUrls;
  $R call({
    ReportTypeDto? type,
    String? description,
    String? sessionId,
    String? requestId,
    String? targetUserId,
    bool? endSession,
    List<String>? evidenceUrls,
  });
  CreateReportDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _CreateReportDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CreateReportDto, $Out>
    implements CreateReportDtoCopyWith<$R, CreateReportDto, $Out> {
  _CreateReportDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CreateReportDto> $mapper =
      CreateReportDtoMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>?
  get evidenceUrls => $value.evidenceUrls != null
      ? ListCopyWith(
          $value.evidenceUrls!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(evidenceUrls: v),
        )
      : null;
  @override
  $R call({
    ReportTypeDto? type,
    String? description,
    Object? sessionId = $none,
    Object? requestId = $none,
    Object? targetUserId = $none,
    Object? endSession = $none,
    Object? evidenceUrls = $none,
  }) => $apply(
    FieldCopyWithData({
      if (type != null) #type: type,
      if (description != null) #description: description,
      if (sessionId != $none) #sessionId: sessionId,
      if (requestId != $none) #requestId: requestId,
      if (targetUserId != $none) #targetUserId: targetUserId,
      if (endSession != $none) #endSession: endSession,
      if (evidenceUrls != $none) #evidenceUrls: evidenceUrls,
    }),
  );
  @override
  CreateReportDto $make(CopyWithData data) => CreateReportDto(
    type: data.get(#type, or: $value.type),
    description: data.get(#description, or: $value.description),
    sessionId: data.get(#sessionId, or: $value.sessionId),
    requestId: data.get(#requestId, or: $value.requestId),
    targetUserId: data.get(#targetUserId, or: $value.targetUserId),
    endSession: data.get(#endSession, or: $value.endSession),
    evidenceUrls: data.get(#evidenceUrls, or: $value.evidenceUrls),
  );

  @override
  CreateReportDtoCopyWith<$R2, CreateReportDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _CreateReportDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ReportDtoMapper extends ClassMapperBase<ReportDto> {
  ReportDtoMapper._();

  static ReportDtoMapper? _instance;
  static ReportDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ReportDtoMapper._());
      ReportTypeDtoMapper.ensureInitialized();
      ReportSeverityDtoMapper.ensureInitialized();
      ReportStatusDtoMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ReportDto';

  static String _$id(ReportDto v) => v.id;
  static const Field<ReportDto, String> _f$id = Field('id', _$id);
  static ReportTypeDto _$type(ReportDto v) => v.type;
  static const Field<ReportDto, ReportTypeDto> _f$type = Field('type', _$type);
  static ReportSeverityDto _$severity(ReportDto v) => v.severity;
  static const Field<ReportDto, ReportSeverityDto> _f$severity = Field(
    'severity',
    _$severity,
  );
  static String _$description(ReportDto v) => v.description;
  static const Field<ReportDto, String> _f$description = Field(
    'description',
    _$description,
  );
  static ReportStatusDto _$status(ReportDto v) => v.status;
  static const Field<ReportDto, ReportStatusDto> _f$status = Field(
    'status',
    _$status,
  );
  static String? _$sessionId(ReportDto v) => v.sessionId;
  static const Field<ReportDto, String> _f$sessionId = Field(
    'sessionId',
    _$sessionId,
    key: r'session_id',
    opt: true,
  );
  static String? _$requestId(ReportDto v) => v.requestId;
  static const Field<ReportDto, String> _f$requestId = Field(
    'requestId',
    _$requestId,
    key: r'request_id',
    opt: true,
  );
  static String? _$targetUserId(ReportDto v) => v.targetUserId;
  static const Field<ReportDto, String> _f$targetUserId = Field(
    'targetUserId',
    _$targetUserId,
    key: r'target_user_id',
    opt: true,
  );
  static bool _$sessionEnded(ReportDto v) => v.sessionEnded;
  static const Field<ReportDto, bool> _f$sessionEnded = Field(
    'sessionEnded',
    _$sessionEnded,
    key: r'session_ended',
  );
  static bool _$penalizesReporter(ReportDto v) => v.penalizesReporter;
  static const Field<ReportDto, bool> _f$penalizesReporter = Field(
    'penalizesReporter',
    _$penalizesReporter,
    key: r'penalizes_reporter',
  );
  static DateTime _$createdAt(ReportDto v) => v.createdAt;
  static const Field<ReportDto, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    key: r'created_at',
  );

  @override
  final MappableFields<ReportDto> fields = const {
    #id: _f$id,
    #type: _f$type,
    #severity: _f$severity,
    #description: _f$description,
    #status: _f$status,
    #sessionId: _f$sessionId,
    #requestId: _f$requestId,
    #targetUserId: _f$targetUserId,
    #sessionEnded: _f$sessionEnded,
    #penalizesReporter: _f$penalizesReporter,
    #createdAt: _f$createdAt,
  };

  static ReportDto _instantiate(DecodingData data) {
    return ReportDto(
      id: data.dec(_f$id),
      type: data.dec(_f$type),
      severity: data.dec(_f$severity),
      description: data.dec(_f$description),
      status: data.dec(_f$status),
      sessionId: data.dec(_f$sessionId),
      requestId: data.dec(_f$requestId),
      targetUserId: data.dec(_f$targetUserId),
      sessionEnded: data.dec(_f$sessionEnded),
      penalizesReporter: data.dec(_f$penalizesReporter),
      createdAt: data.dec(_f$createdAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ReportDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ReportDto>(map);
  }

  static ReportDto fromJson(String json) {
    return ensureInitialized().decodeJson<ReportDto>(json);
  }
}

mixin ReportDtoMappable {
  String toJson() {
    return ReportDtoMapper.ensureInitialized().encodeJson<ReportDto>(
      this as ReportDto,
    );
  }

  Map<String, dynamic> toMap() {
    return ReportDtoMapper.ensureInitialized().encodeMap<ReportDto>(
      this as ReportDto,
    );
  }

  ReportDtoCopyWith<ReportDto, ReportDto, ReportDto> get copyWith =>
      _ReportDtoCopyWithImpl<ReportDto, ReportDto>(
        this as ReportDto,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ReportDtoMapper.ensureInitialized().stringifyValue(
      this as ReportDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return ReportDtoMapper.ensureInitialized().equalsValue(
      this as ReportDto,
      other,
    );
  }

  @override
  int get hashCode {
    return ReportDtoMapper.ensureInitialized().hashValue(this as ReportDto);
  }
}

extension ReportDtoValueCopy<$R, $Out> on ObjectCopyWith<$R, ReportDto, $Out> {
  ReportDtoCopyWith<$R, ReportDto, $Out> get $asReportDto =>
      $base.as((v, t, t2) => _ReportDtoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ReportDtoCopyWith<$R, $In extends ReportDto, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    ReportTypeDto? type,
    ReportSeverityDto? severity,
    String? description,
    ReportStatusDto? status,
    String? sessionId,
    String? requestId,
    String? targetUserId,
    bool? sessionEnded,
    bool? penalizesReporter,
    DateTime? createdAt,
  });
  ReportDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ReportDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ReportDto, $Out>
    implements ReportDtoCopyWith<$R, ReportDto, $Out> {
  _ReportDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ReportDto> $mapper =
      ReportDtoMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    ReportTypeDto? type,
    ReportSeverityDto? severity,
    String? description,
    ReportStatusDto? status,
    Object? sessionId = $none,
    Object? requestId = $none,
    Object? targetUserId = $none,
    bool? sessionEnded,
    bool? penalizesReporter,
    DateTime? createdAt,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (type != null) #type: type,
      if (severity != null) #severity: severity,
      if (description != null) #description: description,
      if (status != null) #status: status,
      if (sessionId != $none) #sessionId: sessionId,
      if (requestId != $none) #requestId: requestId,
      if (targetUserId != $none) #targetUserId: targetUserId,
      if (sessionEnded != null) #sessionEnded: sessionEnded,
      if (penalizesReporter != null) #penalizesReporter: penalizesReporter,
      if (createdAt != null) #createdAt: createdAt,
    }),
  );
  @override
  ReportDto $make(CopyWithData data) => ReportDto(
    id: data.get(#id, or: $value.id),
    type: data.get(#type, or: $value.type),
    severity: data.get(#severity, or: $value.severity),
    description: data.get(#description, or: $value.description),
    status: data.get(#status, or: $value.status),
    sessionId: data.get(#sessionId, or: $value.sessionId),
    requestId: data.get(#requestId, or: $value.requestId),
    targetUserId: data.get(#targetUserId, or: $value.targetUserId),
    sessionEnded: data.get(#sessionEnded, or: $value.sessionEnded),
    penalizesReporter: data.get(
      #penalizesReporter,
      or: $value.penalizesReporter,
    ),
    createdAt: data.get(#createdAt, or: $value.createdAt),
  );

  @override
  ReportDtoCopyWith<$R2, ReportDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ReportDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

