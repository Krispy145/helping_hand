// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'pulse_dto.dart';

class AppealStatusDtoMapper extends EnumMapper<AppealStatusDto> {
  AppealStatusDtoMapper._();

  static AppealStatusDtoMapper? _instance;
  static AppealStatusDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AppealStatusDtoMapper._());
    }
    return _instance!;
  }

  static AppealStatusDto fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  AppealStatusDto decode(dynamic value) {
    switch (value) {
      case r'OPEN':
        return AppealStatusDto.OPEN;
      case r'UPHELD':
        return AppealStatusDto.UPHELD;
      case r'OVERTURNED':
        return AppealStatusDto.OVERTURNED;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(AppealStatusDto self) {
    switch (self) {
      case AppealStatusDto.OPEN:
        return r'OPEN';
      case AppealStatusDto.UPHELD:
        return r'UPHELD';
      case AppealStatusDto.OVERTURNED:
        return r'OVERTURNED';
    }
  }
}

extension AppealStatusDtoMapperExtension on AppealStatusDto {
  String toValue() {
    AppealStatusDtoMapper.ensureInitialized();
    return MapperContainer.globals.toValue<AppealStatusDto>(this) as String;
  }
}

class PulseSummaryDtoMapper extends ClassMapperBase<PulseSummaryDto> {
  PulseSummaryDtoMapper._();

  static PulseSummaryDtoMapper? _instance;
  static PulseSummaryDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PulseSummaryDtoMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PulseSummaryDto';

  static int _$sessionsCompleted(PulseSummaryDto v) => v.sessionsCompleted;
  static const Field<PulseSummaryDto, int> _f$sessionsCompleted = Field(
    'sessionsCompleted',
    _$sessionsCompleted,
    key: r'sessions_completed',
  );
  static int _$requestsHelped(PulseSummaryDto v) => v.requestsHelped;
  static const Field<PulseSummaryDto, int> _f$requestsHelped = Field(
    'requestsHelped',
    _$requestsHelped,
    key: r'requests_helped',
  );
  static int _$requestsRejected(PulseSummaryDto v) => v.requestsRejected;
  static const Field<PulseSummaryDto, int> _f$requestsRejected = Field(
    'requestsRejected',
    _$requestsRejected,
    key: r'requests_rejected',
  );
  static int _$reportsFiled(PulseSummaryDto v) => v.reportsFiled;
  static const Field<PulseSummaryDto, int> _f$reportsFiled = Field(
    'reportsFiled',
    _$reportsFiled,
    key: r'reports_filed',
  );
  static int _$crisisSupportRoutes(PulseSummaryDto v) => v.crisisSupportRoutes;
  static const Field<PulseSummaryDto, int> _f$crisisSupportRoutes = Field(
    'crisisSupportRoutes',
    _$crisisSupportRoutes,
    key: r'crisis_support_routes',
  );
  static int _$harmReports(PulseSummaryDto v) => v.harmReports;
  static const Field<PulseSummaryDto, int> _f$harmReports = Field(
    'harmReports',
    _$harmReports,
    key: r'harm_reports',
  );
  static int _$minCount(PulseSummaryDto v) => v.minCount;
  static const Field<PulseSummaryDto, int> _f$minCount = Field(
    'minCount',
    _$minCount,
    key: r'min_count',
    opt: true,
    def: 5,
  );

  @override
  final MappableFields<PulseSummaryDto> fields = const {
    #sessionsCompleted: _f$sessionsCompleted,
    #requestsHelped: _f$requestsHelped,
    #requestsRejected: _f$requestsRejected,
    #reportsFiled: _f$reportsFiled,
    #crisisSupportRoutes: _f$crisisSupportRoutes,
    #harmReports: _f$harmReports,
    #minCount: _f$minCount,
  };

  static PulseSummaryDto _instantiate(DecodingData data) {
    return PulseSummaryDto(
      sessionsCompleted: data.dec(_f$sessionsCompleted),
      requestsHelped: data.dec(_f$requestsHelped),
      requestsRejected: data.dec(_f$requestsRejected),
      reportsFiled: data.dec(_f$reportsFiled),
      crisisSupportRoutes: data.dec(_f$crisisSupportRoutes),
      harmReports: data.dec(_f$harmReports),
      minCount: data.dec(_f$minCount),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PulseSummaryDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PulseSummaryDto>(map);
  }

  static PulseSummaryDto fromJson(String json) {
    return ensureInitialized().decodeJson<PulseSummaryDto>(json);
  }
}

mixin PulseSummaryDtoMappable {
  String toJson() {
    return PulseSummaryDtoMapper.ensureInitialized()
        .encodeJson<PulseSummaryDto>(this as PulseSummaryDto);
  }

  Map<String, dynamic> toMap() {
    return PulseSummaryDtoMapper.ensureInitialized().encodeMap<PulseSummaryDto>(
      this as PulseSummaryDto,
    );
  }

  PulseSummaryDtoCopyWith<PulseSummaryDto, PulseSummaryDto, PulseSummaryDto>
  get copyWith =>
      _PulseSummaryDtoCopyWithImpl<PulseSummaryDto, PulseSummaryDto>(
        this as PulseSummaryDto,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return PulseSummaryDtoMapper.ensureInitialized().stringifyValue(
      this as PulseSummaryDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return PulseSummaryDtoMapper.ensureInitialized().equalsValue(
      this as PulseSummaryDto,
      other,
    );
  }

  @override
  int get hashCode {
    return PulseSummaryDtoMapper.ensureInitialized().hashValue(
      this as PulseSummaryDto,
    );
  }
}

extension PulseSummaryDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PulseSummaryDto, $Out> {
  PulseSummaryDtoCopyWith<$R, PulseSummaryDto, $Out> get $asPulseSummaryDto =>
      $base.as((v, t, t2) => _PulseSummaryDtoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PulseSummaryDtoCopyWith<$R, $In extends PulseSummaryDto, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    int? sessionsCompleted,
    int? requestsHelped,
    int? requestsRejected,
    int? reportsFiled,
    int? crisisSupportRoutes,
    int? harmReports,
    int? minCount,
  });
  PulseSummaryDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PulseSummaryDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PulseSummaryDto, $Out>
    implements PulseSummaryDtoCopyWith<$R, PulseSummaryDto, $Out> {
  _PulseSummaryDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PulseSummaryDto> $mapper =
      PulseSummaryDtoMapper.ensureInitialized();
  @override
  $R call({
    int? sessionsCompleted,
    int? requestsHelped,
    int? requestsRejected,
    int? reportsFiled,
    int? crisisSupportRoutes,
    int? harmReports,
    int? minCount,
  }) => $apply(
    FieldCopyWithData({
      if (sessionsCompleted != null) #sessionsCompleted: sessionsCompleted,
      if (requestsHelped != null) #requestsHelped: requestsHelped,
      if (requestsRejected != null) #requestsRejected: requestsRejected,
      if (reportsFiled != null) #reportsFiled: reportsFiled,
      if (crisisSupportRoutes != null)
        #crisisSupportRoutes: crisisSupportRoutes,
      if (harmReports != null) #harmReports: harmReports,
      if (minCount != null) #minCount: minCount,
    }),
  );
  @override
  PulseSummaryDto $make(CopyWithData data) => PulseSummaryDto(
    sessionsCompleted: data.get(
      #sessionsCompleted,
      or: $value.sessionsCompleted,
    ),
    requestsHelped: data.get(#requestsHelped, or: $value.requestsHelped),
    requestsRejected: data.get(#requestsRejected, or: $value.requestsRejected),
    reportsFiled: data.get(#reportsFiled, or: $value.reportsFiled),
    crisisSupportRoutes: data.get(
      #crisisSupportRoutes,
      or: $value.crisisSupportRoutes,
    ),
    harmReports: data.get(#harmReports, or: $value.harmReports),
    minCount: data.get(#minCount, or: $value.minCount),
  );

  @override
  PulseSummaryDtoCopyWith<$R2, PulseSummaryDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PulseSummaryDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class PulseQueueItemDtoMapper extends ClassMapperBase<PulseQueueItemDto> {
  PulseQueueItemDtoMapper._();

  static PulseQueueItemDtoMapper? _instance;
  static PulseQueueItemDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PulseQueueItemDtoMapper._());
      AppealStatusDtoMapper.ensureInitialized();
      RequestDtoMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PulseQueueItemDto';

  static String _$appealId(PulseQueueItemDto v) => v.appealId;
  static const Field<PulseQueueItemDto, String> _f$appealId = Field(
    'appealId',
    _$appealId,
    key: r'appeal_id',
  );
  static AppealStatusDto _$status(PulseQueueItemDto v) => v.status;
  static const Field<PulseQueueItemDto, AppealStatusDto> _f$status = Field(
    'status',
    _$status,
  );
  static String _$reason(PulseQueueItemDto v) => v.reason;
  static const Field<PulseQueueItemDto, String> _f$reason = Field(
    'reason',
    _$reason,
  );
  static DateTime _$createdAt(PulseQueueItemDto v) => v.createdAt;
  static const Field<PulseQueueItemDto, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    key: r'created_at',
  );
  static RequestDto _$request(PulseQueueItemDto v) => v.request;
  static const Field<PulseQueueItemDto, RequestDto> _f$request = Field(
    'request',
    _$request,
  );
  static String? _$triggeredRule(PulseQueueItemDto v) => v.triggeredRule;
  static const Field<PulseQueueItemDto, String> _f$triggeredRule = Field(
    'triggeredRule',
    _$triggeredRule,
    key: r'triggered_rule',
    opt: true,
  );
  static String? _$reasonCode(PulseQueueItemDto v) => v.reasonCode;
  static const Field<PulseQueueItemDto, String> _f$reasonCode = Field(
    'reasonCode',
    _$reasonCode,
    key: r'reason_code',
    opt: true,
  );

  @override
  final MappableFields<PulseQueueItemDto> fields = const {
    #appealId: _f$appealId,
    #status: _f$status,
    #reason: _f$reason,
    #createdAt: _f$createdAt,
    #request: _f$request,
    #triggeredRule: _f$triggeredRule,
    #reasonCode: _f$reasonCode,
  };

  static PulseQueueItemDto _instantiate(DecodingData data) {
    return PulseQueueItemDto(
      appealId: data.dec(_f$appealId),
      status: data.dec(_f$status),
      reason: data.dec(_f$reason),
      createdAt: data.dec(_f$createdAt),
      request: data.dec(_f$request),
      triggeredRule: data.dec(_f$triggeredRule),
      reasonCode: data.dec(_f$reasonCode),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PulseQueueItemDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PulseQueueItemDto>(map);
  }

  static PulseQueueItemDto fromJson(String json) {
    return ensureInitialized().decodeJson<PulseQueueItemDto>(json);
  }
}

mixin PulseQueueItemDtoMappable {
  String toJson() {
    return PulseQueueItemDtoMapper.ensureInitialized()
        .encodeJson<PulseQueueItemDto>(this as PulseQueueItemDto);
  }

  Map<String, dynamic> toMap() {
    return PulseQueueItemDtoMapper.ensureInitialized()
        .encodeMap<PulseQueueItemDto>(this as PulseQueueItemDto);
  }

  PulseQueueItemDtoCopyWith<
    PulseQueueItemDto,
    PulseQueueItemDto,
    PulseQueueItemDto
  >
  get copyWith =>
      _PulseQueueItemDtoCopyWithImpl<PulseQueueItemDto, PulseQueueItemDto>(
        this as PulseQueueItemDto,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return PulseQueueItemDtoMapper.ensureInitialized().stringifyValue(
      this as PulseQueueItemDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return PulseQueueItemDtoMapper.ensureInitialized().equalsValue(
      this as PulseQueueItemDto,
      other,
    );
  }

  @override
  int get hashCode {
    return PulseQueueItemDtoMapper.ensureInitialized().hashValue(
      this as PulseQueueItemDto,
    );
  }
}

extension PulseQueueItemDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PulseQueueItemDto, $Out> {
  PulseQueueItemDtoCopyWith<$R, PulseQueueItemDto, $Out>
  get $asPulseQueueItemDto => $base.as(
    (v, t, t2) => _PulseQueueItemDtoCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PulseQueueItemDtoCopyWith<
  $R,
  $In extends PulseQueueItemDto,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  RequestDtoCopyWith<$R, RequestDto, RequestDto> get request;
  $R call({
    String? appealId,
    AppealStatusDto? status,
    String? reason,
    DateTime? createdAt,
    RequestDto? request,
    String? triggeredRule,
    String? reasonCode,
  });
  PulseQueueItemDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PulseQueueItemDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PulseQueueItemDto, $Out>
    implements PulseQueueItemDtoCopyWith<$R, PulseQueueItemDto, $Out> {
  _PulseQueueItemDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PulseQueueItemDto> $mapper =
      PulseQueueItemDtoMapper.ensureInitialized();
  @override
  RequestDtoCopyWith<$R, RequestDto, RequestDto> get request =>
      $value.request.copyWith.$chain((v) => call(request: v));
  @override
  $R call({
    String? appealId,
    AppealStatusDto? status,
    String? reason,
    DateTime? createdAt,
    RequestDto? request,
    Object? triggeredRule = $none,
    Object? reasonCode = $none,
  }) => $apply(
    FieldCopyWithData({
      if (appealId != null) #appealId: appealId,
      if (status != null) #status: status,
      if (reason != null) #reason: reason,
      if (createdAt != null) #createdAt: createdAt,
      if (request != null) #request: request,
      if (triggeredRule != $none) #triggeredRule: triggeredRule,
      if (reasonCode != $none) #reasonCode: reasonCode,
    }),
  );
  @override
  PulseQueueItemDto $make(CopyWithData data) => PulseQueueItemDto(
    appealId: data.get(#appealId, or: $value.appealId),
    status: data.get(#status, or: $value.status),
    reason: data.get(#reason, or: $value.reason),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    request: data.get(#request, or: $value.request),
    triggeredRule: data.get(#triggeredRule, or: $value.triggeredRule),
    reasonCode: data.get(#reasonCode, or: $value.reasonCode),
  );

  @override
  PulseQueueItemDtoCopyWith<$R2, PulseQueueItemDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PulseQueueItemDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class CreateAppealDtoMapper extends ClassMapperBase<CreateAppealDto> {
  CreateAppealDtoMapper._();

  static CreateAppealDtoMapper? _instance;
  static CreateAppealDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CreateAppealDtoMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'CreateAppealDto';

  static String? _$reason(CreateAppealDto v) => v.reason;
  static const Field<CreateAppealDto, String> _f$reason = Field(
    'reason',
    _$reason,
    opt: true,
  );

  @override
  final MappableFields<CreateAppealDto> fields = const {#reason: _f$reason};

  static CreateAppealDto _instantiate(DecodingData data) {
    return CreateAppealDto(reason: data.dec(_f$reason));
  }

  @override
  final Function instantiate = _instantiate;

  static CreateAppealDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CreateAppealDto>(map);
  }

  static CreateAppealDto fromJson(String json) {
    return ensureInitialized().decodeJson<CreateAppealDto>(json);
  }
}

mixin CreateAppealDtoMappable {
  String toJson() {
    return CreateAppealDtoMapper.ensureInitialized()
        .encodeJson<CreateAppealDto>(this as CreateAppealDto);
  }

  Map<String, dynamic> toMap() {
    return CreateAppealDtoMapper.ensureInitialized().encodeMap<CreateAppealDto>(
      this as CreateAppealDto,
    );
  }

  CreateAppealDtoCopyWith<CreateAppealDto, CreateAppealDto, CreateAppealDto>
  get copyWith =>
      _CreateAppealDtoCopyWithImpl<CreateAppealDto, CreateAppealDto>(
        this as CreateAppealDto,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return CreateAppealDtoMapper.ensureInitialized().stringifyValue(
      this as CreateAppealDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return CreateAppealDtoMapper.ensureInitialized().equalsValue(
      this as CreateAppealDto,
      other,
    );
  }

  @override
  int get hashCode {
    return CreateAppealDtoMapper.ensureInitialized().hashValue(
      this as CreateAppealDto,
    );
  }
}

extension CreateAppealDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CreateAppealDto, $Out> {
  CreateAppealDtoCopyWith<$R, CreateAppealDto, $Out> get $asCreateAppealDto =>
      $base.as((v, t, t2) => _CreateAppealDtoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class CreateAppealDtoCopyWith<$R, $In extends CreateAppealDto, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? reason});
  CreateAppealDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _CreateAppealDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CreateAppealDto, $Out>
    implements CreateAppealDtoCopyWith<$R, CreateAppealDto, $Out> {
  _CreateAppealDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CreateAppealDto> $mapper =
      CreateAppealDtoMapper.ensureInitialized();
  @override
  $R call({Object? reason = $none}) =>
      $apply(FieldCopyWithData({if (reason != $none) #reason: reason}));
  @override
  CreateAppealDto $make(CopyWithData data) =>
      CreateAppealDto(reason: data.get(#reason, or: $value.reason));

  @override
  CreateAppealDtoCopyWith<$R2, CreateAppealDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _CreateAppealDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

