import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/auth/providers/auth_provider.dart';
import 'package:mobile/features/verification/data/verification_repository.dart';
import 'package:mobile/features/verification/presentation/verification_gate.dart';
import 'package:mobile/features/verification/presentation/verification_screen.dart';
import 'package:models/models.dart';
import 'package:ui/ui.dart';

UserDto _user({
  VerificationStatusDto status = VerificationStatusDto.UNVERIFIED,
  VerificationFailureReasonDto? reason,
}) {
  final now = DateTime.utc(2026, 8, 18);
  return UserDto(
    id: 'user-1',
    email: 'pat@example.com',
    name: 'Pat',
    role: UserRoleDto.USER,
    verificationStatus: status,
    verificationFailureReason: reason,
    ageThreshold: 18,
    createdAt: now,
    updatedAt: now,
    verifiedAt: status == VerificationStatusDto.VERIFIED ? now : null,
  );
}

VerificationStatusResponseDto _status({
  VerificationStatusDto status = VerificationStatusDto.UNVERIFIED,
  VerificationFailureReasonDto? reason,
  bool stub = true,
  String? launchUrl,
  String? documentLaunchUrl,
}) {
  final now = DateTime.utc(2026, 8, 18);
  return VerificationStatusResponseDto(
    id: 'user-1',
    email: 'pat@example.com',
    name: 'Pat',
    role: UserRoleDto.USER,
    verificationStatus: status,
    verificationFailureReason: reason,
    ageThreshold: 18,
    createdAt: now,
    updatedAt: now,
    verifiedAt: status == VerificationStatusDto.VERIFIED ? now : null,
    stub: stub,
    launchUrl: launchUrl,
    documentLaunchUrl: documentLaunchUrl,
  );
}

class _FakeAuthNotifier extends AuthNotifier {
  _FakeAuthNotifier(this.user);
  UserDto? user;

  @override
  Future<UserDto?> build() async => user;

  @override
  Future<void> refreshProfile() async {
    state = AsyncValue.data(user);
  }
}

class _FakeVerificationRepository extends VerificationRepository {
  _FakeVerificationRepository({
    required this.status,
    this.eligibility = const EligibilityResultDto(
      eligible: true,
      ageThreshold: 18,
    ),
    this.onStart,
    this.onDocument,
    this.onRefresh,
    this.onStub,
    this.statusError,
  }) : super(dio: Dio());

  VerificationStatusResponseDto status;
  EligibilityResultDto eligibility;
  Exception? statusError;
  VerificationStatusResponseDto Function()? onStart;
  VerificationStatusResponseDto Function()? onDocument;
  VerificationStatusResponseDto Function()? onRefresh;
  void Function(String outcome)? onStub;
  String? lastStubOutcome;

  @override
  Future<VerificationStatusResponseDto> getStatus() async {
    if (statusError != null) {
      throw statusError!;
    }
    return status;
  }

  @override
  Future<EligibilityResultDto> checkEligibility(DateTime dateOfBirth) async {
    return eligibility;
  }

  @override
  Future<VerificationStatusResponseDto> start() async {
    status = onStart?.call() ?? status;
    return status;
  }

  @override
  Future<VerificationStatusResponseDto> startDocument() async {
    status = onDocument?.call() ?? status;
    return status;
  }

  @override
  Future<VerificationStatusResponseDto> refresh() async {
    status = onRefresh?.call() ?? status;
    return status;
  }

  @override
  Future<void> completeStub(String outcome) async {
    lastStubOutcome = outcome;
    onStub?.call(outcome);
    if (outcome == 'verified') {
      status = _status(status: VerificationStatusDto.VERIFIED);
    } else if (outcome == 'underage') {
      status = _status(
        status: VerificationStatusDto.FAILED,
        reason: VerificationFailureReasonDto.UNDERAGE,
      );
    } else if (outcome == 'document') {
      status = _status(status: VerificationStatusDto.REQUIRES_DOCUMENT);
    } else {
      status = _status(
        status: VerificationStatusDto.FAILED,
        reason: VerificationFailureReasonDto.PROVIDER_REJECTED,
      );
    }
  }
}

Future<void> _pump(
  WidgetTester tester, {
  required UserDto user,
  required _FakeVerificationRepository repository,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authProvider.overrideWith(() => _FakeAuthNotifier(user)),
        verificationRepositoryProvider.overrideWithValue(repository),
      ],
      child: MaterialApp(
        theme: AppTheme.build(
          style: AppThemeStyle.primary,
          brightness: Brightness.light,
        ),
        home: const VerificationScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  test('isVerifiedAdult only accepts independently verified users', () {
    expect(isVerifiedAdult(_user()), isFalse);
    expect(
      isVerifiedAdult(_user(status: VerificationStatusDto.PENDING)),
      isFalse,
    );
    expect(
      isVerifiedAdult(_user(status: VerificationStatusDto.REQUIRES_DOCUMENT)),
      isFalse,
    );
    expect(
      isVerifiedAdult(_user(status: VerificationStatusDto.VERIFIED)),
      isTrue,
    );
  });

  testWidgets('shows the not-verified state', (tester) async {
    await _pump(
      tester,
      user: _user(),
      repository: _FakeVerificationRepository(status: _status()),
    );

    expect(find.text('Verify your age'), findsOneWidget);
    expect(find.text('Verify my age'), findsOneWidget);
    expect(find.textContaining('at least 18 years old'), findsOneWidget);
    expect(find.text('Not verified yet'), findsOneWidget);
    expect(find.text('Why do I need to verify?'), findsOneWidget);
  });

  testWidgets('shows the pending state', (tester) async {
    await _pump(
      tester,
      user: _user(status: VerificationStatusDto.PENDING),
      repository: _FakeVerificationRepository(
        status: _status(status: VerificationStatusDto.PENDING),
      ),
    );

    expect(find.text('Verification in progress'), findsOneWidget);
    expect(find.text('I have finished the check'), findsOneWidget);
    expect(find.text('Verify my age'), findsNothing);
  });

  testWidgets('shows the verified state without asking again', (tester) async {
    await _pump(
      tester,
      user: _user(status: VerificationStatusDto.VERIFIED),
      repository: _FakeVerificationRepository(
        status: _status(status: VerificationStatusDto.VERIFIED),
      ),
    );

    expect(find.text('Verified'), findsOneWidget);
    expect(find.text('Verify my age'), findsNothing);
    expect(find.text('I am old enough (dev stub)'), findsNothing);
  });

  testWidgets('shows the failed underage state', (tester) async {
    await _pump(
      tester,
      user: _user(
        status: VerificationStatusDto.FAILED,
        reason: VerificationFailureReasonDto.UNDERAGE,
      ),
      repository: _FakeVerificationRepository(
        status: _status(
          status: VerificationStatusDto.FAILED,
          reason: VerificationFailureReasonDto.UNDERAGE,
        ),
      ),
    );

    expect(find.textContaining('This account cannot be used'), findsOneWidget);
    expect(find.text('Verify my age'), findsNothing);
  });

  testWidgets(
    'offers document verification when the face scan is inconclusive',
    (tester) async {
      await _pump(
        tester,
        user: _user(status: VerificationStatusDto.REQUIRES_DOCUMENT),
        repository: _FakeVerificationRepository(
          status: _status(status: VerificationStatusDto.REQUIRES_DOCUMENT),
        ),
      );

      expect(find.text('Document verification required'), findsOneWidget);
      expect(find.text('Verify with government ID'), findsOneWidget);
    },
  );

  testWidgets('shows a network error when status cannot be loaded', (
    tester,
  ) async {
    await _pump(
      tester,
      user: _user(),
      repository: _FakeVerificationRepository(
        status: _status(),
        statusError: DioException(
          requestOptions: RequestOptions(path: '/verification/status'),
          type: DioExceptionType.connectionError,
        ),
      ),
    );

    expect(find.textContaining('Network error'), findsOneWidget);
  });

  testWidgets('allows a retry after an expired session', (tester) async {
    await _pump(
      tester,
      user: _user(
        status: VerificationStatusDto.FAILED,
        reason: VerificationFailureReasonDto.EXPIRED,
      ),
      repository: _FakeVerificationRepository(
        status: _status(
          status: VerificationStatusDto.FAILED,
          reason: VerificationFailureReasonDto.EXPIRED,
        ),
      ),
    );

    expect(find.textContaining('session expired'), findsOneWidget);
    expect(find.text('Verify my age'), findsOneWidget);
  });

  testWidgets('completing the stub flow navigates back after success', (
    tester,
  ) async {
    final auth = _FakeAuthNotifier(_user());
    final repository = _FakeVerificationRepository(status: _status());
    repository.onStub = (_) {
      auth.user = _user(status: VerificationStatusDto.VERIFIED);
    };

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith(() => auth),
          verificationRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp(
          theme: AppTheme.build(
            style: AppThemeStyle.primary,
            brightness: Brightness.light,
          ),
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<bool>(
                  builder: (_) => const VerificationScreen(),
                ),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('I am old enough (dev stub)'));
    await tester.tap(find.text('I am old enough (dev stub)'));
    await tester.pumpAndSettle();

    expect(repository.lastStubOutcome, 'verified');
    expect(find.text('I am old enough (dev stub)'), findsNothing);
    expect(find.textContaining('This account cannot be used'), findsNothing);
  });
}
