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

