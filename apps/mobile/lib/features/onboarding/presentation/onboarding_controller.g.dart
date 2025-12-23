// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OnboardingController)
const onboardingControllerProvider = OnboardingControllerProvider._();

final class OnboardingControllerProvider
    extends
        $AsyncNotifierProvider<OnboardingController, List<OnboardingStepType>> {
  const OnboardingControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingControllerHash();

  @$internal
  @override
  OnboardingController create() => OnboardingController();
}

String _$onboardingControllerHash() =>
    r'e758fafd63c0d6405fa4b8f8b19e6858490c6def';

abstract class _$OnboardingController
    extends $AsyncNotifier<List<OnboardingStepType>> {
  FutureOr<List<OnboardingStepType>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<OnboardingStepType>>,
              List<OnboardingStepType>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<OnboardingStepType>>,
                List<OnboardingStepType>
              >,
              AsyncValue<List<OnboardingStepType>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
