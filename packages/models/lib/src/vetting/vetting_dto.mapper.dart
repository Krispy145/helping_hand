// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'vetting_dto.dart';

class HelplineDtoMapper extends ClassMapperBase<HelplineDto> {
  HelplineDtoMapper._();

  static HelplineDtoMapper? _instance;
  static HelplineDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = HelplineDtoMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'HelplineDto';

  static String _$name(HelplineDto v) => v.name;
  static const Field<HelplineDto, String> _f$name = Field('name', _$name);
  static String _$phone(HelplineDto v) => v.phone;
  static const Field<HelplineDto, String> _f$phone = Field('phone', _$phone);
  static String? _$region(HelplineDto v) => v.region;
  static const Field<HelplineDto, String> _f$region = Field(
    'region',
    _$region,
    opt: true,
  );

  @override
  final MappableFields<HelplineDto> fields = const {
    #name: _f$name,
    #phone: _f$phone,
    #region: _f$region,
  };

  static HelplineDto _instantiate(DecodingData data) {
    return HelplineDto(
      name: data.dec(_f$name),
      phone: data.dec(_f$phone),
      region: data.dec(_f$region),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static HelplineDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<HelplineDto>(map);
  }

  static HelplineDto fromJson(String json) {
    return ensureInitialized().decodeJson<HelplineDto>(json);
  }
}

mixin HelplineDtoMappable {
  String toJson() {
    return HelplineDtoMapper.ensureInitialized().encodeJson<HelplineDto>(
      this as HelplineDto,
    );
  }

  Map<String, dynamic> toMap() {
    return HelplineDtoMapper.ensureInitialized().encodeMap<HelplineDto>(
      this as HelplineDto,
    );
  }

  HelplineDtoCopyWith<HelplineDto, HelplineDto, HelplineDto> get copyWith =>
      _HelplineDtoCopyWithImpl<HelplineDto, HelplineDto>(
        this as HelplineDto,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return HelplineDtoMapper.ensureInitialized().stringifyValue(
      this as HelplineDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return HelplineDtoMapper.ensureInitialized().equalsValue(
      this as HelplineDto,
      other,
    );
  }

  @override
  int get hashCode {
    return HelplineDtoMapper.ensureInitialized().hashValue(this as HelplineDto);
  }
}

extension HelplineDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, HelplineDto, $Out> {
  HelplineDtoCopyWith<$R, HelplineDto, $Out> get $asHelplineDto =>
      $base.as((v, t, t2) => _HelplineDtoCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class HelplineDtoCopyWith<$R, $In extends HelplineDto, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? name, String? phone, String? region});
  HelplineDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _HelplineDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, HelplineDto, $Out>
    implements HelplineDtoCopyWith<$R, HelplineDto, $Out> {
  _HelplineDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<HelplineDto> $mapper =
      HelplineDtoMapper.ensureInitialized();
  @override
  $R call({String? name, String? phone, Object? region = $none}) => $apply(
    FieldCopyWithData({
      if (name != null) #name: name,
      if (phone != null) #phone: phone,
      if (region != $none) #region: region,
    }),
  );
  @override
  HelplineDto $make(CopyWithData data) => HelplineDto(
    name: data.get(#name, or: $value.name),
    phone: data.get(#phone, or: $value.phone),
    region: data.get(#region, or: $value.region),
  );

  @override
  HelplineDtoCopyWith<$R2, HelplineDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _HelplineDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class VettingFeedbackDtoMapper extends ClassMapperBase<VettingFeedbackDto> {
  VettingFeedbackDtoMapper._();

  static VettingFeedbackDtoMapper? _instance;
  static VettingFeedbackDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = VettingFeedbackDtoMapper._());
      HelplineDtoMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'VettingFeedbackDto';

  static String? _$triggeredRule(VettingFeedbackDto v) => v.triggeredRule;
  static const Field<VettingFeedbackDto, String> _f$triggeredRule = Field(
    'triggeredRule',
    _$triggeredRule,
    key: r'triggered_rule',
    opt: true,
  );
  static String? _$reasonCode(VettingFeedbackDto v) => v.reasonCode;
  static const Field<VettingFeedbackDto, String> _f$reasonCode = Field(
    'reasonCode',
    _$reasonCode,
    key: r'reason_code',
    opt: true,
  );
  static String? _$userMessage(VettingFeedbackDto v) => v.userMessage;
  static const Field<VettingFeedbackDto, String> _f$userMessage = Field(
    'userMessage',
    _$userMessage,
    key: r'user_message',
    opt: true,
  );
  static bool _$showHelplines(VettingFeedbackDto v) => v.showHelplines;
  static const Field<VettingFeedbackDto, bool> _f$showHelplines = Field(
    'showHelplines',
    _$showHelplines,
    key: r'show_helplines',
    opt: true,
    def: false,
  );
  static List<HelplineDto> _$helplines(VettingFeedbackDto v) => v.helplines;
  static const Field<VettingFeedbackDto, List<HelplineDto>> _f$helplines =
      Field('helplines', _$helplines, opt: true, def: const []);

  @override
  final MappableFields<VettingFeedbackDto> fields = const {
    #triggeredRule: _f$triggeredRule,
    #reasonCode: _f$reasonCode,
    #userMessage: _f$userMessage,
    #showHelplines: _f$showHelplines,
    #helplines: _f$helplines,
  };

  static VettingFeedbackDto _instantiate(DecodingData data) {
    return VettingFeedbackDto(
      triggeredRule: data.dec(_f$triggeredRule),
      reasonCode: data.dec(_f$reasonCode),
      userMessage: data.dec(_f$userMessage),
      showHelplines: data.dec(_f$showHelplines),
      helplines: data.dec(_f$helplines),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static VettingFeedbackDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<VettingFeedbackDto>(map);
  }

  static VettingFeedbackDto fromJson(String json) {
    return ensureInitialized().decodeJson<VettingFeedbackDto>(json);
  }
}

mixin VettingFeedbackDtoMappable {
  String toJson() {
    return VettingFeedbackDtoMapper.ensureInitialized()
        .encodeJson<VettingFeedbackDto>(this as VettingFeedbackDto);
  }

  Map<String, dynamic> toMap() {
    return VettingFeedbackDtoMapper.ensureInitialized()
        .encodeMap<VettingFeedbackDto>(this as VettingFeedbackDto);
  }

  VettingFeedbackDtoCopyWith<
    VettingFeedbackDto,
    VettingFeedbackDto,
    VettingFeedbackDto
  >
  get copyWith =>
      _VettingFeedbackDtoCopyWithImpl<VettingFeedbackDto, VettingFeedbackDto>(
        this as VettingFeedbackDto,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return VettingFeedbackDtoMapper.ensureInitialized().stringifyValue(
      this as VettingFeedbackDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return VettingFeedbackDtoMapper.ensureInitialized().equalsValue(
      this as VettingFeedbackDto,
      other,
    );
  }

  @override
  int get hashCode {
    return VettingFeedbackDtoMapper.ensureInitialized().hashValue(
      this as VettingFeedbackDto,
    );
  }
}

extension VettingFeedbackDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, VettingFeedbackDto, $Out> {
  VettingFeedbackDtoCopyWith<$R, VettingFeedbackDto, $Out>
  get $asVettingFeedbackDto => $base.as(
    (v, t, t2) => _VettingFeedbackDtoCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class VettingFeedbackDtoCopyWith<
  $R,
  $In extends VettingFeedbackDto,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    HelplineDto,
    HelplineDtoCopyWith<$R, HelplineDto, HelplineDto>
  >
  get helplines;
  $R call({
    String? triggeredRule,
    String? reasonCode,
    String? userMessage,
    bool? showHelplines,
    List<HelplineDto>? helplines,
  });
  VettingFeedbackDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _VettingFeedbackDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, VettingFeedbackDto, $Out>
    implements VettingFeedbackDtoCopyWith<$R, VettingFeedbackDto, $Out> {
  _VettingFeedbackDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<VettingFeedbackDto> $mapper =
      VettingFeedbackDtoMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    HelplineDto,
    HelplineDtoCopyWith<$R, HelplineDto, HelplineDto>
  >
  get helplines => ListCopyWith(
    $value.helplines,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(helplines: v),
  );
  @override
  $R call({
    Object? triggeredRule = $none,
    Object? reasonCode = $none,
    Object? userMessage = $none,
    bool? showHelplines,
    List<HelplineDto>? helplines,
  }) => $apply(
    FieldCopyWithData({
      if (triggeredRule != $none) #triggeredRule: triggeredRule,
      if (reasonCode != $none) #reasonCode: reasonCode,
      if (userMessage != $none) #userMessage: userMessage,
      if (showHelplines != null) #showHelplines: showHelplines,
      if (helplines != null) #helplines: helplines,
    }),
  );
  @override
  VettingFeedbackDto $make(CopyWithData data) => VettingFeedbackDto(
    triggeredRule: data.get(#triggeredRule, or: $value.triggeredRule),
    reasonCode: data.get(#reasonCode, or: $value.reasonCode),
    userMessage: data.get(#userMessage, or: $value.userMessage),
    showHelplines: data.get(#showHelplines, or: $value.showHelplines),
    helplines: data.get(#helplines, or: $value.helplines),
  );

  @override
  VettingFeedbackDtoCopyWith<$R2, VettingFeedbackDto, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _VettingFeedbackDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

