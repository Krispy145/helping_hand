// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'auth_requests.dart';

class LoginRequestDtoMapper extends ClassMapperBase<LoginRequestDto> {
  LoginRequestDtoMapper._();

  static LoginRequestDtoMapper? _instance;
  static LoginRequestDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LoginRequestDtoMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'LoginRequestDto';

  static String _$email(LoginRequestDto v) => v.email;
  static const Field<LoginRequestDto, String> _f$email = Field(
    'email',
    _$email,
  );
  static String _$password(LoginRequestDto v) => v.password;
  static const Field<LoginRequestDto, String> _f$password = Field(
    'password',
    _$password,
  );

  @override
  final MappableFields<LoginRequestDto> fields = const {
    #email: _f$email,
    #password: _f$password,
  };

  static LoginRequestDto _instantiate(DecodingData data) {
    return LoginRequestDto(
      email: data.dec(_f$email),
      password: data.dec(_f$password),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static LoginRequestDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<LoginRequestDto>(map);
  }

  static LoginRequestDto fromJson(String json) {
    return ensureInitialized().decodeJson<LoginRequestDto>(json);
  }
}

mixin LoginRequestDtoMappable {
  String toJson() {
    return LoginRequestDtoMapper.ensureInitialized()
        .encodeJson<LoginRequestDto>(this as LoginRequestDto);
  }

  Map<String, dynamic> toMap() {
    return LoginRequestDtoMapper.ensureInitialized().encodeMap<LoginRequestDto>(
      this as LoginRequestDto,
    );
  }

  LoginRequestDtoCopyWith<LoginRequestDto, LoginRequestDto, LoginRequestDto>
  get copyWith =>
      _LoginRequestDtoCopyWithImpl<LoginRequestDto, LoginRequestDto>(
        this as LoginRequestDto,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return LoginRequestDtoMapper.ensureInitialized().stringifyValue(
      this as LoginRequestDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return LoginRequestDtoMapper.ensureInitialized().equalsValue(
      this as LoginRequestDto,
      other,
    );
  }

  @override
  int get hashCode {
    return LoginRequestDtoMapper.ensureInitialized().hashValue(
      this as LoginRequestDto,
    );
  }
}

extension LoginRequestDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, LoginRequestDto, $Out> {
  LoginRequestDtoCopyWith<$R, LoginRequestDto, $Out> get $asLoginRequestDto =>
      $base.as((v, t, t2) => _LoginRequestDtoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class LoginRequestDtoCopyWith<$R, $In extends LoginRequestDto, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? email, String? password});
  LoginRequestDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _LoginRequestDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, LoginRequestDto, $Out>
    implements LoginRequestDtoCopyWith<$R, LoginRequestDto, $Out> {
  _LoginRequestDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<LoginRequestDto> $mapper =
      LoginRequestDtoMapper.ensureInitialized();
  @override
  $R call({String? email, String? password}) => $apply(
    FieldCopyWithData({
      if (email != null) #email: email,
      if (password != null) #password: password,
    }),
  );
  @override
  LoginRequestDto $make(CopyWithData data) => LoginRequestDto(
    email: data.get(#email, or: $value.email),
    password: data.get(#password, or: $value.password),
  );

  @override
  LoginRequestDtoCopyWith<$R2, LoginRequestDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _LoginRequestDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class RegisterRequestDtoMapper extends ClassMapperBase<RegisterRequestDto> {
  RegisterRequestDtoMapper._();

  static RegisterRequestDtoMapper? _instance;
  static RegisterRequestDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RegisterRequestDtoMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'RegisterRequestDto';

  static String _$email(RegisterRequestDto v) => v.email;
  static const Field<RegisterRequestDto, String> _f$email = Field(
    'email',
    _$email,
  );
  static String _$password(RegisterRequestDto v) => v.password;
  static const Field<RegisterRequestDto, String> _f$password = Field(
    'password',
    _$password,
  );
  static String _$name(RegisterRequestDto v) => v.name;
  static const Field<RegisterRequestDto, String> _f$name = Field(
    'name',
    _$name,
  );

  @override
  final MappableFields<RegisterRequestDto> fields = const {
    #email: _f$email,
    #password: _f$password,
    #name: _f$name,
  };

  static RegisterRequestDto _instantiate(DecodingData data) {
    return RegisterRequestDto(
      email: data.dec(_f$email),
      password: data.dec(_f$password),
      name: data.dec(_f$name),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static RegisterRequestDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RegisterRequestDto>(map);
  }

  static RegisterRequestDto fromJson(String json) {
    return ensureInitialized().decodeJson<RegisterRequestDto>(json);
  }
}

mixin RegisterRequestDtoMappable {
  String toJson() {
    return RegisterRequestDtoMapper.ensureInitialized()
        .encodeJson<RegisterRequestDto>(this as RegisterRequestDto);
  }

  Map<String, dynamic> toMap() {
    return RegisterRequestDtoMapper.ensureInitialized()
        .encodeMap<RegisterRequestDto>(this as RegisterRequestDto);
  }

  RegisterRequestDtoCopyWith<
    RegisterRequestDto,
    RegisterRequestDto,
    RegisterRequestDto
  >
  get copyWith =>
      _RegisterRequestDtoCopyWithImpl<RegisterRequestDto, RegisterRequestDto>(
        this as RegisterRequestDto,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return RegisterRequestDtoMapper.ensureInitialized().stringifyValue(
      this as RegisterRequestDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return RegisterRequestDtoMapper.ensureInitialized().equalsValue(
      this as RegisterRequestDto,
      other,
    );
  }

  @override
  int get hashCode {
    return RegisterRequestDtoMapper.ensureInitialized().hashValue(
      this as RegisterRequestDto,
    );
  }
}

extension RegisterRequestDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RegisterRequestDto, $Out> {
  RegisterRequestDtoCopyWith<$R, RegisterRequestDto, $Out>
  get $asRegisterRequestDto => $base.as(
    (v, t, t2) => _RegisterRequestDtoCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class RegisterRequestDtoCopyWith<
  $R,
  $In extends RegisterRequestDto,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? email, String? password, String? name});
  RegisterRequestDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _RegisterRequestDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RegisterRequestDto, $Out>
    implements RegisterRequestDtoCopyWith<$R, RegisterRequestDto, $Out> {
  _RegisterRequestDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RegisterRequestDto> $mapper =
      RegisterRequestDtoMapper.ensureInitialized();
  @override
  $R call({String? email, String? password, String? name}) => $apply(
    FieldCopyWithData({
      if (email != null) #email: email,
      if (password != null) #password: password,
      if (name != null) #name: name,
    }),
  );
  @override
  RegisterRequestDto $make(CopyWithData data) => RegisterRequestDto(
    email: data.get(#email, or: $value.email),
    password: data.get(#password, or: $value.password),
    name: data.get(#name, or: $value.name),
  );

  @override
  RegisterRequestDtoCopyWith<$R2, RegisterRequestDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _RegisterRequestDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

