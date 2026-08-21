import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  test('parses a verification status payload without estimated age', () {
    final status = VerificationStatusResponseDtoMapper.fromMap({
      'id': 'user-1',
      'email': 'pat@example.com',
      'name': 'Pat',
      'role': 'USER',
      'verification_status': 'REQUIRES_DOCUMENT',
      'age_threshold': 18,
      'created_at': '2026-08-18T10:00:00.000Z',
      'updated_at': '2026-08-18T10:00:00.000Z',
      'provider': 'YOTI',
      'stub': false,
      'launch_url':
          'https://age.yoti.com/age-estimation?sessionId=abc&sdkId=sdk',
      'document_launch_url':
          'https://age.yoti.com/doc-scan?sessionId=abc&sdkId=sdk',
    });

    expect(status.needsDocument, isTrue);
    expect(status.ageThreshold, 18);
    expect(status.toMap().containsKey('age'), isFalse);
  });
}
