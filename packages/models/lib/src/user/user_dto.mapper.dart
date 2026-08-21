// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'user_dto.dart';

class UserRoleDtoMapper extends EnumMapper<UserRoleDto> {
  UserRoleDtoMapper._();

  static UserRoleDtoMapper? _instance;
  static UserRoleDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserRoleDtoMapper._());
    }
    return _instance!;
  }

  static UserRoleDto fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  UserRoleDto decode(dynamic value) {
    switch (value) {
      case r'USER':
        return UserRoleDto.USER;
      case r'ADMIN':
        return UserRoleDto.ADMIN;
      case r'MODERATOR':
        return UserRoleDto.MODERATOR;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(UserRoleDto self) {
    switch (self) {
      case UserRoleDto.USER:
        return r'USER';
      case UserRoleDto.ADMIN:
        return r'ADMIN';
      case UserRoleDto.MODERATOR:
        return r'MODERATOR';
    }
  }
}

extension UserRoleDtoMapperExtension on UserRoleDto {
  String toValue() {
    UserRoleDtoMapper.ensureInitialized();
    return MapperContainer.globals.toValue<UserRoleDto>(this) as String;
  }
}

class VerificationStatusDtoMapper extends EnumMapper<VerificationStatusDto> {
  VerificationStatusDtoMapper._();

  static VerificationStatusDtoMapper? _instance;
  static VerificationStatusDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = VerificationStatusDtoMapper._());
    }
    return _instance!;
  }

  static VerificationStatusDto fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  VerificationStatusDto decode(dynamic value) {
    switch (value) {
      case r'UNVERIFIED':
        return VerificationStatusDto.UNVERIFIED;
      case r'PENDING':
        return VerificationStatusDto.PENDING;
      case r'VERIFIED':
        return VerificationStatusDto.VERIFIED;
      case r'FAILED':
        return VerificationStatusDto.FAILED;
      case r'REQUIRES_DOCUMENT':
        return VerificationStatusDto.REQUIRES_DOCUMENT;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(VerificationStatusDto self) {
    switch (self) {
      case VerificationStatusDto.UNVERIFIED:
        return r'UNVERIFIED';
      case VerificationStatusDto.PENDING:
        return r'PENDING';
      case VerificationStatusDto.VERIFIED:
        return r'VERIFIED';
      case VerificationStatusDto.FAILED:
        return r'FAILED';
      case VerificationStatusDto.REQUIRES_DOCUMENT:
        return r'REQUIRES_DOCUMENT';
    }
  }
}

extension VerificationStatusDtoMapperExtension on VerificationStatusDto {
  String toValue() {
    VerificationStatusDtoMapper.ensureInitialized();
    return MapperContainer.globals.toValue<VerificationStatusDto>(this)
        as String;
  }
}

class VerificationFailureReasonDtoMapper
    extends EnumMapper<VerificationFailureReasonDto> {
  VerificationFailureReasonDtoMapper._();

  static VerificationFailureReasonDtoMapper? _instance;
  static VerificationFailureReasonDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = VerificationFailureReasonDtoMapper._(),
      );
    }
    return _instance!;
  }

  static VerificationFailureReasonDto fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  VerificationFailureReasonDto decode(dynamic value) {
    switch (value) {
      case r'UNDERAGE':
        return VerificationFailureReasonDto.UNDERAGE;
      case r'PROVIDER_REJECTED':
        return VerificationFailureReasonDto.PROVIDER_REJECTED;
      case r'EXPIRED':
        return VerificationFailureReasonDto.EXPIRED;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(VerificationFailureReasonDto self) {
    switch (self) {
      case VerificationFailureReasonDto.UNDERAGE:
        return r'UNDERAGE';
      case VerificationFailureReasonDto.PROVIDER_REJECTED:
        return r'PROVIDER_REJECTED';
      case VerificationFailureReasonDto.EXPIRED:
        return r'EXPIRED';
    }
  }
}

extension VerificationFailureReasonDtoMapperExtension
    on VerificationFailureReasonDto {
  String toValue() {
    VerificationFailureReasonDtoMapper.ensureInitialized();
    return MapperContainer.globals.toValue<VerificationFailureReasonDto>(this)
        as String;
  }
}

class UserDtoMapper extends ClassMapperBase<UserDto> {
  UserDtoMapper._();

  static UserDtoMapper? _instance;
  static UserDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserDtoMapper._());
      UserRoleDtoMapper.ensureInitialized();
      VerificationStatusDtoMapper.ensureInitialized();
      VerificationFailureReasonDtoMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'UserDto';

  static String _$id(UserDto v) => v.id;
  static const Field<UserDto, String> _f$id = Field('id', _$id);
  static String _$email(UserDto v) => v.email;
  static const Field<UserDto, String> _f$email = Field('email', _$email);
  static String? _$name(UserDto v) => v.name;
  static const Field<UserDto, String> _f$name = Field(
    'name',
    _$name,
    opt: true,
  );
  static UserRoleDto _$role(UserDto v) => v.role;
  static const Field<UserDto, UserRoleDto> _f$role = Field('role', _$role);
  static VerificationStatusDto _$verificationStatus(UserDto v) =>
      v.verificationStatus;
  static const Field<UserDto, VerificationStatusDto> _f$verificationStatus =
      Field(
        'verificationStatus',
        _$verificationStatus,
        key: r'verification_status',
        opt: true,
        def: VerificationStatusDto.UNVERIFIED,
      );
  static DateTime? _$verifiedAt(UserDto v) => v.verifiedAt;
  static const Field<UserDto, DateTime> _f$verifiedAt = Field(
    'verifiedAt',
    _$verifiedAt,
    key: r'verified_at',
    opt: true,
  );
  static VerificationFailureReasonDto? _$verificationFailureReason(UserDto v) =>
      v.verificationFailureReason;
  static const Field<UserDto, VerificationFailureReasonDto>
  _f$verificationFailureReason = Field(
    'verificationFailureReason',
    _$verificationFailureReason,
    key: r'verification_failure_reason',
    opt: true,
  );
  static int? _$ageThreshold(UserDto v) => v.ageThreshold;
  static const Field<UserDto, int> _f$ageThreshold = Field(
    'ageThreshold',
    _$ageThreshold,
    key: r'age_threshold',
    opt: true,
  );
  static DateTime _$createdAt(UserDto v) => v.createdAt;
  static const Field<UserDto, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    key: r'created_at',
  );
  static DateTime _$updatedAt(UserDto v) => v.updatedAt;
  static const Field<UserDto, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    key: r'updated_at',
  );

  @override
  final MappableFields<UserDto> fields = const {
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
  };

  static UserDto _instantiate(DecodingData data) {
    return UserDto(
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
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UserDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserDto>(map);
  }

  static UserDto fromJson(String json) {
    return ensureInitialized().decodeJson<UserDto>(json);
  }
}

mixin UserDtoMappable {
  String toJson() {
    return UserDtoMapper.ensureInitialized().encodeJson<UserDto>(
      this as UserDto,
    );
  }

  Map<String, dynamic> toMap() {
    return UserDtoMapper.ensureInitialized().encodeMap<UserDto>(
      this as UserDto,
    );
  }

  UserDtoCopyWith<UserDto, UserDto, UserDto> get copyWith =>
      _UserDtoCopyWithImpl<UserDto, UserDto>(
        this as UserDto,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return UserDtoMapper.ensureInitialized().stringifyValue(this as UserDto);
  }

  @override
  bool operator ==(Object other) {
    return UserDtoMapper.ensureInitialized().equalsValue(
      this as UserDto,
      other,
    );
  }

  @override
  int get hashCode {
    return UserDtoMapper.ensureInitialized().hashValue(this as UserDto);
  }
}

extension UserDtoValueCopy<$R, $Out> on ObjectCopyWith<$R, UserDto, $Out> {
  UserDtoCopyWith<$R, UserDto, $Out> get $asUserDto =>
      $base.as((v, t, t2) => _UserDtoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UserDtoCopyWith<$R, $In extends UserDto, $Out>
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
  });
  UserDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _UserDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserDto, $Out>
    implements UserDtoCopyWith<$R, UserDto, $Out> {
  _UserDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UserDto> $mapper =
      UserDtoMapper.ensureInitialized();
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
    }),
  );
  @override
  UserDto $make(CopyWithData data) => UserDto(
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
  );

  @override
  UserDtoCopyWith<$R2, UserDto, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _UserDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

