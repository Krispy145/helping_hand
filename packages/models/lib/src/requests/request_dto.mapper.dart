// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'request_dto.dart';

class RequestStatusDtoMapper extends EnumMapper<RequestStatusDto> {
  RequestStatusDtoMapper._();

  static RequestStatusDtoMapper? _instance;
  static RequestStatusDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RequestStatusDtoMapper._());
    }
    return _instance!;
  }

  static RequestStatusDto fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  RequestStatusDto decode(dynamic value) {
    switch (value) {
      case r'PENDING_VETTING':
        return RequestStatusDto.PENDING_VETTING;
      case r'APPROVED':
        return RequestStatusDto.APPROVED;
      case r'REJECTED':
        return RequestStatusDto.REJECTED;
      case r'IN_PROGRESS':
        return RequestStatusDto.IN_PROGRESS;
      case r'COMPLETED':
        return RequestStatusDto.COMPLETED;
      case r'CANCELLED':
        return RequestStatusDto.CANCELLED;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(RequestStatusDto self) {
    switch (self) {
      case RequestStatusDto.PENDING_VETTING:
        return r'PENDING_VETTING';
      case RequestStatusDto.APPROVED:
        return r'APPROVED';
      case RequestStatusDto.REJECTED:
        return r'REJECTED';
      case RequestStatusDto.IN_PROGRESS:
        return r'IN_PROGRESS';
      case RequestStatusDto.COMPLETED:
        return r'COMPLETED';
      case RequestStatusDto.CANCELLED:
        return r'CANCELLED';
    }
  }
}

extension RequestStatusDtoMapperExtension on RequestStatusDto {
  String toValue() {
    RequestStatusDtoMapper.ensureInitialized();
    return MapperContainer.globals.toValue<RequestStatusDto>(this) as String;
  }
}

class RequestUrgencyDtoMapper extends EnumMapper<RequestUrgencyDto> {
  RequestUrgencyDtoMapper._();

  static RequestUrgencyDtoMapper? _instance;
  static RequestUrgencyDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RequestUrgencyDtoMapper._());
    }
    return _instance!;
  }

  static RequestUrgencyDto fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  RequestUrgencyDto decode(dynamic value) {
    switch (value) {
      case r'LOW':
        return RequestUrgencyDto.LOW;
      case r'MEDIUM':
        return RequestUrgencyDto.MEDIUM;
      case r'HIGH':
        return RequestUrgencyDto.HIGH;
      case r'CRITICAL':
        return RequestUrgencyDto.CRITICAL;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(RequestUrgencyDto self) {
    switch (self) {
      case RequestUrgencyDto.LOW:
        return r'LOW';
      case RequestUrgencyDto.MEDIUM:
        return r'MEDIUM';
      case RequestUrgencyDto.HIGH:
        return r'HIGH';
      case RequestUrgencyDto.CRITICAL:
        return r'CRITICAL';
    }
  }
}

extension RequestUrgencyDtoMapperExtension on RequestUrgencyDto {
  String toValue() {
    RequestUrgencyDtoMapper.ensureInitialized();
    return MapperContainer.globals.toValue<RequestUrgencyDto>(this) as String;
  }
}

class RequestDtoMapper extends ClassMapperBase<RequestDto> {
  RequestDtoMapper._();

  static RequestDtoMapper? _instance;
  static RequestDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RequestDtoMapper._());
      RequestStatusDtoMapper.ensureInitialized();
      RequestUrgencyDtoMapper.ensureInitialized();
      UserDtoMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'RequestDto';

  static String _$id(RequestDto v) => v.id;
  static const Field<RequestDto, String> _f$id = Field('id', _$id);
  static String _$title(RequestDto v) => v.title;
  static const Field<RequestDto, String> _f$title = Field('title', _$title);
  static String _$description(RequestDto v) => v.description;
  static const Field<RequestDto, String> _f$description = Field(
    'description',
    _$description,
  );
  static String? _$category(RequestDto v) => v.category;
  static const Field<RequestDto, String> _f$category = Field(
    'category',
    _$category,
    opt: true,
  );
  static RequestStatusDto _$status(RequestDto v) => v.status;
  static const Field<RequestDto, RequestStatusDto> _f$status = Field(
    'status',
    _$status,
  );
  static RequestUrgencyDto _$urgency(RequestDto v) => v.urgency;
  static const Field<RequestDto, RequestUrgencyDto> _f$urgency = Field(
    'urgency',
    _$urgency,
  );
  static double? _$lat(RequestDto v) => v.lat;
  static const Field<RequestDto, double> _f$lat = Field(
    'lat',
    _$lat,
    opt: true,
  );
  static double? _$lng(RequestDto v) => v.lng;
  static const Field<RequestDto, double> _f$lng = Field(
    'lng',
    _$lng,
    opt: true,
  );
  static DateTime _$createdAt(RequestDto v) => v.createdAt;
  static const Field<RequestDto, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    key: r'created_at',
  );
  static DateTime _$updatedAt(RequestDto v) => v.updatedAt;
  static const Field<RequestDto, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    key: r'updated_at',
  );
  static UserDto? _$user(RequestDto v) => v.user;
  static const Field<RequestDto, UserDto> _f$user = Field(
    'user',
    _$user,
    opt: true,
  );

  @override
  final MappableFields<RequestDto> fields = const {
    #id: _f$id,
    #title: _f$title,
    #description: _f$description,
    #category: _f$category,
    #status: _f$status,
    #urgency: _f$urgency,
    #lat: _f$lat,
    #lng: _f$lng,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
    #user: _f$user,
  };

  static RequestDto _instantiate(DecodingData data) {
    return RequestDto(
      id: data.dec(_f$id),
      title: data.dec(_f$title),
      description: data.dec(_f$description),
      category: data.dec(_f$category),
      status: data.dec(_f$status),
      urgency: data.dec(_f$urgency),
      lat: data.dec(_f$lat),
      lng: data.dec(_f$lng),
      createdAt: data.dec(_f$createdAt),
      updatedAt: data.dec(_f$updatedAt),
      user: data.dec(_f$user),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static RequestDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RequestDto>(map);
  }

  static RequestDto fromJson(String json) {
    return ensureInitialized().decodeJson<RequestDto>(json);
  }
}

mixin RequestDtoMappable {
  String toJson() {
    return RequestDtoMapper.ensureInitialized().encodeJson<RequestDto>(
      this as RequestDto,
    );
  }

  Map<String, dynamic> toMap() {
    return RequestDtoMapper.ensureInitialized().encodeMap<RequestDto>(
      this as RequestDto,
    );
  }

  RequestDtoCopyWith<RequestDto, RequestDto, RequestDto> get copyWith =>
      _RequestDtoCopyWithImpl<RequestDto, RequestDto>(
        this as RequestDto,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return RequestDtoMapper.ensureInitialized().stringifyValue(
      this as RequestDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return RequestDtoMapper.ensureInitialized().equalsValue(
      this as RequestDto,
      other,
    );
  }

  @override
  int get hashCode {
    return RequestDtoMapper.ensureInitialized().hashValue(this as RequestDto);
  }
}

extension RequestDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RequestDto, $Out> {
  RequestDtoCopyWith<$R, RequestDto, $Out> get $asRequestDto =>
      $base.as((v, t, t2) => _RequestDtoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class RequestDtoCopyWith<$R, $In extends RequestDto, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  UserDtoCopyWith<$R, UserDto, UserDto>? get user;
  $R call({
    String? id,
    String? title,
    String? description,
    String? category,
    RequestStatusDto? status,
    RequestUrgencyDto? urgency,
    double? lat,
    double? lng,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserDto? user,
  });
  RequestDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _RequestDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RequestDto, $Out>
    implements RequestDtoCopyWith<$R, RequestDto, $Out> {
  _RequestDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RequestDto> $mapper =
      RequestDtoMapper.ensureInitialized();
  @override
  UserDtoCopyWith<$R, UserDto, UserDto>? get user =>
      $value.user?.copyWith.$chain((v) => call(user: v));
  @override
  $R call({
    String? id,
    String? title,
    String? description,
    Object? category = $none,
    RequestStatusDto? status,
    RequestUrgencyDto? urgency,
    Object? lat = $none,
    Object? lng = $none,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? user = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (title != null) #title: title,
      if (description != null) #description: description,
      if (category != $none) #category: category,
      if (status != null) #status: status,
      if (urgency != null) #urgency: urgency,
      if (lat != $none) #lat: lat,
      if (lng != $none) #lng: lng,
      if (createdAt != null) #createdAt: createdAt,
      if (updatedAt != null) #updatedAt: updatedAt,
      if (user != $none) #user: user,
    }),
  );
  @override
  RequestDto $make(CopyWithData data) => RequestDto(
    id: data.get(#id, or: $value.id),
    title: data.get(#title, or: $value.title),
    description: data.get(#description, or: $value.description),
    category: data.get(#category, or: $value.category),
    status: data.get(#status, or: $value.status),
    urgency: data.get(#urgency, or: $value.urgency),
    lat: data.get(#lat, or: $value.lat),
    lng: data.get(#lng, or: $value.lng),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
    user: data.get(#user, or: $value.user),
  );

  @override
  RequestDtoCopyWith<$R2, RequestDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _RequestDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class CreateRequestDtoMapper extends ClassMapperBase<CreateRequestDto> {
  CreateRequestDtoMapper._();

  static CreateRequestDtoMapper? _instance;
  static CreateRequestDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CreateRequestDtoMapper._());
      RequestUrgencyDtoMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'CreateRequestDto';

  static String _$title(CreateRequestDto v) => v.title;
  static const Field<CreateRequestDto, String> _f$title = Field(
    'title',
    _$title,
  );
  static String _$description(CreateRequestDto v) => v.description;
  static const Field<CreateRequestDto, String> _f$description = Field(
    'description',
    _$description,
  );
  static String _$category(CreateRequestDto v) => v.category;
  static const Field<CreateRequestDto, String> _f$category = Field(
    'category',
    _$category,
  );
  static RequestUrgencyDto _$urgency(CreateRequestDto v) => v.urgency;
  static const Field<CreateRequestDto, RequestUrgencyDto> _f$urgency = Field(
    'urgency',
    _$urgency,
  );
  static double? _$lat(CreateRequestDto v) => v.lat;
  static const Field<CreateRequestDto, double> _f$lat = Field(
    'lat',
    _$lat,
    opt: true,
  );
  static double? _$lng(CreateRequestDto v) => v.lng;
  static const Field<CreateRequestDto, double> _f$lng = Field(
    'lng',
    _$lng,
    opt: true,
  );

  @override
  final MappableFields<CreateRequestDto> fields = const {
    #title: _f$title,
    #description: _f$description,
    #category: _f$category,
    #urgency: _f$urgency,
    #lat: _f$lat,
    #lng: _f$lng,
  };

  static CreateRequestDto _instantiate(DecodingData data) {
    return CreateRequestDto(
      title: data.dec(_f$title),
      description: data.dec(_f$description),
      category: data.dec(_f$category),
      urgency: data.dec(_f$urgency),
      lat: data.dec(_f$lat),
      lng: data.dec(_f$lng),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static CreateRequestDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CreateRequestDto>(map);
  }

  static CreateRequestDto fromJson(String json) {
    return ensureInitialized().decodeJson<CreateRequestDto>(json);
  }
}

mixin CreateRequestDtoMappable {
  String toJson() {
    return CreateRequestDtoMapper.ensureInitialized()
        .encodeJson<CreateRequestDto>(this as CreateRequestDto);
  }

  Map<String, dynamic> toMap() {
    return CreateRequestDtoMapper.ensureInitialized()
        .encodeMap<CreateRequestDto>(this as CreateRequestDto);
  }

  CreateRequestDtoCopyWith<CreateRequestDto, CreateRequestDto, CreateRequestDto>
  get copyWith =>
      _CreateRequestDtoCopyWithImpl<CreateRequestDto, CreateRequestDto>(
        this as CreateRequestDto,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return CreateRequestDtoMapper.ensureInitialized().stringifyValue(
      this as CreateRequestDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return CreateRequestDtoMapper.ensureInitialized().equalsValue(
      this as CreateRequestDto,
      other,
    );
  }

  @override
  int get hashCode {
    return CreateRequestDtoMapper.ensureInitialized().hashValue(
      this as CreateRequestDto,
    );
  }
}

extension CreateRequestDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CreateRequestDto, $Out> {
  CreateRequestDtoCopyWith<$R, CreateRequestDto, $Out>
  get $asCreateRequestDto =>
      $base.as((v, t, t2) => _CreateRequestDtoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class CreateRequestDtoCopyWith<$R, $In extends CreateRequestDto, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? title,
    String? description,
    String? category,
    RequestUrgencyDto? urgency,
    double? lat,
    double? lng,
  });
  CreateRequestDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _CreateRequestDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CreateRequestDto, $Out>
    implements CreateRequestDtoCopyWith<$R, CreateRequestDto, $Out> {
  _CreateRequestDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CreateRequestDto> $mapper =
      CreateRequestDtoMapper.ensureInitialized();
  @override
  $R call({
    String? title,
    String? description,
    String? category,
    RequestUrgencyDto? urgency,
    Object? lat = $none,
    Object? lng = $none,
  }) => $apply(
    FieldCopyWithData({
      if (title != null) #title: title,
      if (description != null) #description: description,
      if (category != null) #category: category,
      if (urgency != null) #urgency: urgency,
      if (lat != $none) #lat: lat,
      if (lng != $none) #lng: lng,
    }),
  );
  @override
  CreateRequestDto $make(CopyWithData data) => CreateRequestDto(
    title: data.get(#title, or: $value.title),
    description: data.get(#description, or: $value.description),
    category: data.get(#category, or: $value.category),
    urgency: data.get(#urgency, or: $value.urgency),
    lat: data.get(#lat, or: $value.lat),
    lng: data.get(#lng, or: $value.lng),
  );

  @override
  CreateRequestDtoCopyWith<$R2, CreateRequestDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _CreateRequestDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

