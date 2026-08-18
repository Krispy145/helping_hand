// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'auth_responses.dart';

class AuthResponseDtoMapper extends ClassMapperBase<AuthResponseDto> {
  AuthResponseDtoMapper._();

  static AuthResponseDtoMapper? _instance;
  static AuthResponseDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AuthResponseDtoMapper._());
      UserDtoMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AuthResponseDto';

  static String _$accessToken(AuthResponseDto v) => v.accessToken;
  static const Field<AuthResponseDto, String> _f$accessToken = Field(
    'accessToken',
    _$accessToken,
    key: r'access_token',
  );
  static UserDto _$user(AuthResponseDto v) => v.user;
  static const Field<AuthResponseDto, UserDto> _f$user = Field('user', _$user);

  @override
  final MappableFields<AuthResponseDto> fields = const {
    #accessToken: _f$accessToken,
    #user: _f$user,
  };

  static AuthResponseDto _instantiate(DecodingData data) {
    return AuthResponseDto(
      accessToken: data.dec(_f$accessToken),
      user: data.dec(_f$user),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AuthResponseDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AuthResponseDto>(map);
  }

  static AuthResponseDto fromJson(String json) {
    return ensureInitialized().decodeJson<AuthResponseDto>(json);
  }
}

mixin AuthResponseDtoMappable {
  String toJson() {
    return AuthResponseDtoMapper.ensureInitialized()
        .encodeJson<AuthResponseDto>(this as AuthResponseDto);
  }

  Map<String, dynamic> toMap() {
    return AuthResponseDtoMapper.ensureInitialized().encodeMap<AuthResponseDto>(
      this as AuthResponseDto,
    );
  }

  AuthResponseDtoCopyWith<AuthResponseDto, AuthResponseDto, AuthResponseDto>
  get copyWith =>
      _AuthResponseDtoCopyWithImpl<AuthResponseDto, AuthResponseDto>(
        this as AuthResponseDto,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AuthResponseDtoMapper.ensureInitialized().stringifyValue(
      this as AuthResponseDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return AuthResponseDtoMapper.ensureInitialized().equalsValue(
      this as AuthResponseDto,
      other,
    );
  }

  @override
  int get hashCode {
    return AuthResponseDtoMapper.ensureInitialized().hashValue(
      this as AuthResponseDto,
    );
  }
}

extension AuthResponseDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AuthResponseDto, $Out> {
  AuthResponseDtoCopyWith<$R, AuthResponseDto, $Out> get $asAuthResponseDto =>
      $base.as((v, t, t2) => _AuthResponseDtoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AuthResponseDtoCopyWith<$R, $In extends AuthResponseDto, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  UserDtoCopyWith<$R, UserDto, UserDto> get user;
  $R call({String? accessToken, UserDto? user});
  AuthResponseDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AuthResponseDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AuthResponseDto, $Out>
    implements AuthResponseDtoCopyWith<$R, AuthResponseDto, $Out> {
  _AuthResponseDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AuthResponseDto> $mapper =
      AuthResponseDtoMapper.ensureInitialized();
  @override
  UserDtoCopyWith<$R, UserDto, UserDto> get user =>
      $value.user.copyWith.$chain((v) => call(user: v));
  @override
  $R call({String? accessToken, UserDto? user}) => $apply(
    FieldCopyWithData({
      if (accessToken != null) #accessToken: accessToken,
      if (user != null) #user: user,
    }),
  );
  @override
  AuthResponseDto $make(CopyWithData data) => AuthResponseDto(
    accessToken: data.get(#accessToken, or: $value.accessToken),
    user: data.get(#user, or: $value.user),
  );

  @override
  AuthResponseDtoCopyWith<$R2, AuthResponseDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AuthResponseDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

