// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'verification_dto.dart';

class VerificationStubCompleteDtoMapper
    extends ClassMapperBase<VerificationStubCompleteDto> {
  VerificationStubCompleteDtoMapper._();

  static VerificationStubCompleteDtoMapper? _instance;
  static VerificationStubCompleteDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = VerificationStubCompleteDtoMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'VerificationStubCompleteDto';

  static String _$outcome(VerificationStubCompleteDto v) => v.outcome;
  static const Field<VerificationStubCompleteDto, String> _f$outcome = Field(
    'outcome',
    _$outcome,
  );

  @override
  final MappableFields<VerificationStubCompleteDto> fields = const {
    #outcome: _f$outcome,
  };

  static VerificationStubCompleteDto _instantiate(DecodingData data) {
    return VerificationStubCompleteDto(outcome: data.dec(_f$outcome));
  }

  @override
  final Function instantiate = _instantiate;

  static VerificationStubCompleteDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<VerificationStubCompleteDto>(map);
  }

  static VerificationStubCompleteDto fromJson(String json) {
    return ensureInitialized().decodeJson<VerificationStubCompleteDto>(json);
  }
}

mixin VerificationStubCompleteDtoMappable {
  String toJson() {
    return VerificationStubCompleteDtoMapper.ensureInitialized()
        .encodeJson<VerificationStubCompleteDto>(
          this as VerificationStubCompleteDto,
        );
  }

  Map<String, dynamic> toMap() {
    return VerificationStubCompleteDtoMapper.ensureInitialized()
        .encodeMap<VerificationStubCompleteDto>(
          this as VerificationStubCompleteDto,
        );
  }

  VerificationStubCompleteDtoCopyWith<
    VerificationStubCompleteDto,
    VerificationStubCompleteDto,
    VerificationStubCompleteDto
  >
  get copyWith =>
      _VerificationStubCompleteDtoCopyWithImpl<
        VerificationStubCompleteDto,
        VerificationStubCompleteDto
      >(this as VerificationStubCompleteDto, $identity, $identity);
  @override
  String toString() {
    return VerificationStubCompleteDtoMapper.ensureInitialized().stringifyValue(
      this as VerificationStubCompleteDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return VerificationStubCompleteDtoMapper.ensureInitialized().equalsValue(
      this as VerificationStubCompleteDto,
      other,
    );
  }

  @override
  int get hashCode {
    return VerificationStubCompleteDtoMapper.ensureInitialized().hashValue(
      this as VerificationStubCompleteDto,
    );
  }
}

extension VerificationStubCompleteDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, VerificationStubCompleteDto, $Out> {
  VerificationStubCompleteDtoCopyWith<$R, VerificationStubCompleteDto, $Out>
  get $asVerificationStubCompleteDto => $base.as(
    (v, t, t2) => _VerificationStubCompleteDtoCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class VerificationStubCompleteDtoCopyWith<
  $R,
  $In extends VerificationStubCompleteDto,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? outcome});
  VerificationStubCompleteDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _VerificationStubCompleteDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, VerificationStubCompleteDto, $Out>
    implements
        VerificationStubCompleteDtoCopyWith<
          $R,
          VerificationStubCompleteDto,
          $Out
        > {
  _VerificationStubCompleteDtoCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<VerificationStubCompleteDto> $mapper =
      VerificationStubCompleteDtoMapper.ensureInitialized();
  @override
  $R call({String? outcome}) =>
      $apply(FieldCopyWithData({if (outcome != null) #outcome: outcome}));
  @override
  VerificationStubCompleteDto $make(CopyWithData data) =>
      VerificationStubCompleteDto(
        outcome: data.get(#outcome, or: $value.outcome),
      );

  @override
  VerificationStubCompleteDtoCopyWith<$R2, VerificationStubCompleteDto, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _VerificationStubCompleteDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class EligibilityCheckDtoMapper extends ClassMapperBase<EligibilityCheckDto> {
  EligibilityCheckDtoMapper._();

  static EligibilityCheckDtoMapper? _instance;
  static EligibilityCheckDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EligibilityCheckDtoMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'EligibilityCheckDto';

  static String _$dateOfBirth(EligibilityCheckDto v) => v.dateOfBirth;
  static const Field<EligibilityCheckDto, String> _f$dateOfBirth = Field(
    'dateOfBirth',
    _$dateOfBirth,
  );

  @override
  final MappableFields<EligibilityCheckDto> fields = const {
    #dateOfBirth: _f$dateOfBirth,
  };

  static EligibilityCheckDto _instantiate(DecodingData data) {
    return EligibilityCheckDto(dateOfBirth: data.dec(_f$dateOfBirth));
  }

  @override
  final Function instantiate = _instantiate;

  static EligibilityCheckDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EligibilityCheckDto>(map);
  }

  static EligibilityCheckDto fromJson(String json) {
    return ensureInitialized().decodeJson<EligibilityCheckDto>(json);
  }
}

mixin EligibilityCheckDtoMappable {
  String toJson() {
    return EligibilityCheckDtoMapper.ensureInitialized()
        .encodeJson<EligibilityCheckDto>(this as EligibilityCheckDto);
  }

  Map<String, dynamic> toMap() {
    return EligibilityCheckDtoMapper.ensureInitialized()
        .encodeMap<EligibilityCheckDto>(this as EligibilityCheckDto);
  }

  EligibilityCheckDtoCopyWith<
    EligibilityCheckDto,
    EligibilityCheckDto,
    EligibilityCheckDto
  >
  get copyWith =>
      _EligibilityCheckDtoCopyWithImpl<
        EligibilityCheckDto,
        EligibilityCheckDto
      >(this as EligibilityCheckDto, $identity, $identity);
  @override
  String toString() {
    return EligibilityCheckDtoMapper.ensureInitialized().stringifyValue(
      this as EligibilityCheckDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return EligibilityCheckDtoMapper.ensureInitialized().equalsValue(
      this as EligibilityCheckDto,
      other,
    );
  }

  @override
  int get hashCode {
    return EligibilityCheckDtoMapper.ensureInitialized().hashValue(
      this as EligibilityCheckDto,
    );
  }
}

extension EligibilityCheckDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, EligibilityCheckDto, $Out> {
  EligibilityCheckDtoCopyWith<$R, EligibilityCheckDto, $Out>
  get $asEligibilityCheckDto => $base.as(
    (v, t, t2) => _EligibilityCheckDtoCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class EligibilityCheckDtoCopyWith<
  $R,
  $In extends EligibilityCheckDto,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? dateOfBirth});
  EligibilityCheckDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _EligibilityCheckDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, EligibilityCheckDto, $Out>
    implements EligibilityCheckDtoCopyWith<$R, EligibilityCheckDto, $Out> {
  _EligibilityCheckDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<EligibilityCheckDto> $mapper =
      EligibilityCheckDtoMapper.ensureInitialized();
  @override
  $R call({String? dateOfBirth}) => $apply(
    FieldCopyWithData({if (dateOfBirth != null) #dateOfBirth: dateOfBirth}),
  );
  @override
  EligibilityCheckDto $make(CopyWithData data) => EligibilityCheckDto(
    dateOfBirth: data.get(#dateOfBirth, or: $value.dateOfBirth),
  );

  @override
  EligibilityCheckDtoCopyWith<$R2, EligibilityCheckDto, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _EligibilityCheckDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class EligibilityResultDtoMapper extends ClassMapperBase<EligibilityResultDto> {
  EligibilityResultDtoMapper._();

  static EligibilityResultDtoMapper? _instance;
  static EligibilityResultDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EligibilityResultDtoMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'EligibilityResultDto';

  static bool _$eligible(EligibilityResultDto v) => v.eligible;
  static const Field<EligibilityResultDto, bool> _f$eligible = Field(
    'eligible',
    _$eligible,
  );
  static int _$ageThreshold(EligibilityResultDto v) => v.ageThreshold;
  static const Field<EligibilityResultDto, int> _f$ageThreshold = Field(
    'ageThreshold',
    _$ageThreshold,
    key: r'age_threshold',
  );

  @override
  final MappableFields<EligibilityResultDto> fields = const {
    #eligible: _f$eligible,
    #ageThreshold: _f$ageThreshold,
  };

  static EligibilityResultDto _instantiate(DecodingData data) {
    return EligibilityResultDto(
      eligible: data.dec(_f$eligible),
      ageThreshold: data.dec(_f$ageThreshold),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static EligibilityResultDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EligibilityResultDto>(map);
  }

  static EligibilityResultDto fromJson(String json) {
    return ensureInitialized().decodeJson<EligibilityResultDto>(json);
  }
}

mixin EligibilityResultDtoMappable {
  String toJson() {
    return EligibilityResultDtoMapper.ensureInitialized()
        .encodeJson<EligibilityResultDto>(this as EligibilityResultDto);
  }

  Map<String, dynamic> toMap() {
    return EligibilityResultDtoMapper.ensureInitialized()
        .encodeMap<EligibilityResultDto>(this as EligibilityResultDto);
  }

  EligibilityResultDtoCopyWith<
    EligibilityResultDto,
    EligibilityResultDto,
    EligibilityResultDto
  >
  get copyWith =>
      _EligibilityResultDtoCopyWithImpl<
        EligibilityResultDto,
        EligibilityResultDto
      >(this as EligibilityResultDto, $identity, $identity);
  @override
  String toString() {
    return EligibilityResultDtoMapper.ensureInitialized().stringifyValue(
      this as EligibilityResultDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return EligibilityResultDtoMapper.ensureInitialized().equalsValue(
      this as EligibilityResultDto,
      other,
    );
  }

  @override
  int get hashCode {
    return EligibilityResultDtoMapper.ensureInitialized().hashValue(
      this as EligibilityResultDto,
    );
  }
}

extension EligibilityResultDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, EligibilityResultDto, $Out> {
  EligibilityResultDtoCopyWith<$R, EligibilityResultDto, $Out>
  get $asEligibilityResultDto => $base.as(
    (v, t, t2) => _EligibilityResultDtoCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class EligibilityResultDtoCopyWith<
  $R,
  $In extends EligibilityResultDto,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({bool? eligible, int? ageThreshold});
  EligibilityResultDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _EligibilityResultDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, EligibilityResultDto, $Out>
    implements EligibilityResultDtoCopyWith<$R, EligibilityResultDto, $Out> {
  _EligibilityResultDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<EligibilityResultDto> $mapper =
      EligibilityResultDtoMapper.ensureInitialized();
  @override
  $R call({bool? eligible, int? ageThreshold}) => $apply(
    FieldCopyWithData({
      if (eligible != null) #eligible: eligible,
      if (ageThreshold != null) #ageThreshold: ageThreshold,
    }),
  );
  @override
  EligibilityResultDto $make(CopyWithData data) => EligibilityResultDto(
    eligible: data.get(#eligible, or: $value.eligible),
    ageThreshold: data.get(#ageThreshold, or: $value.ageThreshold),
  );

  @override
  EligibilityResultDtoCopyWith<$R2, EligibilityResultDto, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _EligibilityResultDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class VerificationStatusResponseDtoMapper
    extends ClassMapperBase<VerificationStatusResponseDto> {
  VerificationStatusResponseDtoMapper._();

  static VerificationStatusResponseDtoMapper? _instance;
  static VerificationStatusResponseDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = VerificationStatusResponseDtoMapper._(),
      );
      UserRoleDtoMapper.ensureInitialized();
      VerificationStatusDtoMapper.ensureInitialized();
      VerificationFailureReasonDtoMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'VerificationStatusResponseDto';

  static String _$id(VerificationStatusResponseDto v) => v.id;
  static const Field<VerificationStatusResponseDto, String> _f$id = Field(
    'id',
    _$id,
  );
  static String _$email(VerificationStatusResponseDto v) => v.email;
  static const Field<VerificationStatusResponseDto, String> _f$email = Field(
    'email',
    _$email,
  );
  static String? _$name(VerificationStatusResponseDto v) => v.name;
  static const Field<VerificationStatusResponseDto, String> _f$name = Field(
    'name',
    _$name,
    opt: true,
  );
  static UserRoleDto _$role(VerificationStatusResponseDto v) => v.role;
  static const Field<VerificationStatusResponseDto, UserRoleDto> _f$role =
      Field('role', _$role);
  static VerificationStatusDto _$verificationStatus(
    VerificationStatusResponseDto v,
  ) => v.verificationStatus;
  static const Field<VerificationStatusResponseDto, VerificationStatusDto>
  _f$verificationStatus = Field(
    'verificationStatus',
    _$verificationStatus,
    key: r'verification_status',
    opt: true,
    def: VerificationStatusDto.UNVERIFIED,
  );
  static DateTime? _$verifiedAt(VerificationStatusResponseDto v) =>
      v.verifiedAt;
  static const Field<VerificationStatusResponseDto, DateTime> _f$verifiedAt =
      Field('verifiedAt', _$verifiedAt, key: r'verified_at', opt: true);
  static VerificationFailureReasonDto? _$verificationFailureReason(
    VerificationStatusResponseDto v,
  ) => v.verificationFailureReason;
  static const Field<
    VerificationStatusResponseDto,
    VerificationFailureReasonDto
  >
  _f$verificationFailureReason = Field(
    'verificationFailureReason',
    _$verificationFailureReason,
    key: r'verification_failure_reason',
    opt: true,
  );
  static int? _$ageThreshold(VerificationStatusResponseDto v) => v.ageThreshold;
  static const Field<VerificationStatusResponseDto, int> _f$ageThreshold =
      Field('ageThreshold', _$ageThreshold, key: r'age_threshold', opt: true);
  static DateTime _$createdAt(VerificationStatusResponseDto v) => v.createdAt;
  static const Field<VerificationStatusResponseDto, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');
  static DateTime _$updatedAt(VerificationStatusResponseDto v) => v.updatedAt;
  static const Field<VerificationStatusResponseDto, DateTime> _f$updatedAt =
      Field('updatedAt', _$updatedAt, key: r'updated_at');
  static String? _$provider(VerificationStatusResponseDto v) => v.provider;
  static const Field<VerificationStatusResponseDto, String> _f$provider = Field(
    'provider',
    _$provider,
    opt: true,
  );
  static String? _$referenceId(VerificationStatusResponseDto v) =>
      v.referenceId;
  static const Field<VerificationStatusResponseDto, String> _f$referenceId =
      Field('referenceId', _$referenceId, key: r'reference_id', opt: true);
  static bool _$stub(VerificationStatusResponseDto v) => v.stub;
  static const Field<VerificationStatusResponseDto, bool> _f$stub = Field(
    'stub',
    _$stub,
    opt: true,
    def: false,
  );
  static String? _$launchUrl(VerificationStatusResponseDto v) => v.launchUrl;
  static const Field<VerificationStatusResponseDto, String> _f$launchUrl =
      Field('launchUrl', _$launchUrl, key: r'launch_url', opt: true);
  static String? _$documentLaunchUrl(VerificationStatusResponseDto v) =>
      v.documentLaunchUrl;
  static const Field<VerificationStatusResponseDto, String>
  _f$documentLaunchUrl = Field(
    'documentLaunchUrl',
    _$documentLaunchUrl,
    key: r'document_launch_url',
    opt: true,
  );
  static DateTime? _$expiresAt(VerificationStatusResponseDto v) => v.expiresAt;
  static const Field<VerificationStatusResponseDto, DateTime> _f$expiresAt =
      Field('expiresAt', _$expiresAt, key: r'expires_at', opt: true);

  @override
  final MappableFields<VerificationStatusResponseDto> fields = const {
    #id: _f$id,
    #email: _f$email,
    #name: _f$name,
    #role: _f$role,
    #verificationStatus: _f$verificationStatus,
    #verifiedAt: _f$verifiedAt,
    #verificationFailureReason: _f$verificationFailureReason,
    #ageThreshold: _f$ageThreshold,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
    #provider: _f$provider,
    #referenceId: _f$referenceId,
    #stub: _f$stub,
    #launchUrl: _f$launchUrl,
    #documentLaunchUrl: _f$documentLaunchUrl,
    #expiresAt: _f$expiresAt,
  };

  static VerificationStatusResponseDto _instantiate(DecodingData data) {
    return VerificationStatusResponseDto(
      id: data.dec(_f$id),
      email: data.dec(_f$email),
      name: data.dec(_f$name),
      role: data.dec(_f$role),
      verificationStatus: data.dec(_f$verificationStatus),
      verifiedAt: data.dec(_f$verifiedAt),
      verificationFailureReason: data.dec(_f$verificationFailureReason),
      ageThreshold: data.dec(_f$ageThreshold),
      createdAt: data.dec(_f$createdAt),
      updatedAt: data.dec(_f$updatedAt),
      provider: data.dec(_f$provider),
      referenceId: data.dec(_f$referenceId),
      stub: data.dec(_f$stub),
      launchUrl: data.dec(_f$launchUrl),
      documentLaunchUrl: data.dec(_f$documentLaunchUrl),
      expiresAt: data.dec(_f$expiresAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static VerificationStatusResponseDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<VerificationStatusResponseDto>(map);
  }

  static VerificationStatusResponseDto fromJson(String json) {
    return ensureInitialized().decodeJson<VerificationStatusResponseDto>(json);
  }
}

mixin VerificationStatusResponseDtoMappable {
  String toJson() {
    return VerificationStatusResponseDtoMapper.ensureInitialized()
        .encodeJson<VerificationStatusResponseDto>(
          this as VerificationStatusResponseDto,
        );
  }

  Map<String, dynamic> toMap() {
    return VerificationStatusResponseDtoMapper.ensureInitialized()
        .encodeMap<VerificationStatusResponseDto>(
          this as VerificationStatusResponseDto,
        );
  }

  VerificationStatusResponseDtoCopyWith<
    VerificationStatusResponseDto,
    VerificationStatusResponseDto,
    VerificationStatusResponseDto
  >
  get copyWith =>
      _VerificationStatusResponseDtoCopyWithImpl<
        VerificationStatusResponseDto,
        VerificationStatusResponseDto
      >(this as VerificationStatusResponseDto, $identity, $identity);
  @override
  String toString() {
    return VerificationStatusResponseDtoMapper.ensureInitialized()
        .stringifyValue(this as VerificationStatusResponseDto);
  }

  @override
  bool operator ==(Object other) {
    return VerificationStatusResponseDtoMapper.ensureInitialized().equalsValue(
      this as VerificationStatusResponseDto,
      other,
    );
  }

  @override
  int get hashCode {
    return VerificationStatusResponseDtoMapper.ensureInitialized().hashValue(
      this as VerificationStatusResponseDto,
    );
  }
}

extension VerificationStatusResponseDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, VerificationStatusResponseDto, $Out> {
  VerificationStatusResponseDtoCopyWith<$R, VerificationStatusResponseDto, $Out>
  get $asVerificationStatusResponseDto => $base.as(
    (v, t, t2) =>
        _VerificationStatusResponseDtoCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class VerificationStatusResponseDtoCopyWith<
  $R,
  $In extends VerificationStatusResponseDto,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? email,
    String? name,
    UserRoleDto? role,
    VerificationStatusDto? verificationStatus,
    DateTime? verifiedAt,
    VerificationFailureReasonDto? verificationFailureReason,
    int? ageThreshold,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? provider,
    String? referenceId,
    bool? stub,
    String? launchUrl,
    String? documentLaunchUrl,
    DateTime? expiresAt,
  });
  VerificationStatusResponseDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _VerificationStatusResponseDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, VerificationStatusResponseDto, $Out>
    implements
        VerificationStatusResponseDtoCopyWith<
          $R,
          VerificationStatusResponseDto,
          $Out
        > {
  _VerificationStatusResponseDtoCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<VerificationStatusResponseDto> $mapper =
      VerificationStatusResponseDtoMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? email,
    Object? name = $none,
    UserRoleDto? role,
    VerificationStatusDto? verificationStatus,
    Object? verifiedAt = $none,
    Object? verificationFailureReason = $none,
    Object? ageThreshold = $none,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? provider = $none,
    Object? referenceId = $none,
    bool? stub,
    Object? launchUrl = $none,
    Object? documentLaunchUrl = $none,
    Object? expiresAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (email != null) #email: email,
      if (name != $none) #name: name,
      if (role != null) #role: role,
      if (verificationStatus != null) #verificationStatus: verificationStatus,
      if (verifiedAt != $none) #verifiedAt: verifiedAt,
      if (verificationFailureReason != $none)
        #verificationFailureReason: verificationFailureReason,
      if (ageThreshold != $none) #ageThreshold: ageThreshold,
      if (createdAt != null) #createdAt: createdAt,
      if (updatedAt != null) #updatedAt: updatedAt,
      if (provider != $none) #provider: provider,
      if (referenceId != $none) #referenceId: referenceId,
      if (stub != null) #stub: stub,
      if (launchUrl != $none) #launchUrl: launchUrl,
      if (documentLaunchUrl != $none) #documentLaunchUrl: documentLaunchUrl,
      if (expiresAt != $none) #expiresAt: expiresAt,
    }),
  );
  @override
  VerificationStatusResponseDto $make(CopyWithData data) =>
      VerificationStatusResponseDto(
        id: data.get(#id, or: $value.id),
        email: data.get(#email, or: $value.email),
        name: data.get(#name, or: $value.name),
        role: data.get(#role, or: $value.role),
        verificationStatus: data.get(
          #verificationStatus,
          or: $value.verificationStatus,
        ),
        verifiedAt: data.get(#verifiedAt, or: $value.verifiedAt),
        verificationFailureReason: data.get(
          #verificationFailureReason,
          or: $value.verificationFailureReason,
        ),
        ageThreshold: data.get(#ageThreshold, or: $value.ageThreshold),
        createdAt: data.get(#createdAt, or: $value.createdAt),
        updatedAt: data.get(#updatedAt, or: $value.updatedAt),
        provider: data.get(#provider, or: $value.provider),
        referenceId: data.get(#referenceId, or: $value.referenceId),
        stub: data.get(#stub, or: $value.stub),
        launchUrl: data.get(#launchUrl, or: $value.launchUrl),
        documentLaunchUrl: data.get(
          #documentLaunchUrl,
          or: $value.documentLaunchUrl,
        ),
        expiresAt: data.get(#expiresAt, or: $value.expiresAt),
      );

  @override
  VerificationStatusResponseDtoCopyWith<
    $R2,
    VerificationStatusResponseDto,
    $Out2
  >
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _VerificationStatusResponseDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

