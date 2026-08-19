enum UrgentRouteKind { emergency, crisis, police, fraud }

class UrgentRoute {
  const UrgentRoute({
    required this.kind,
    required this.title,
    required this.subtitle,
    this.phone,
    this.sms,
    this.url,
  });

  final UrgentRouteKind kind;
  final String title;
  final String subtitle;
  final String? phone;
  final String? sms;
  final String? url;

  String get actionLabel {
    if (phone != null) return 'Call $phone';
    if (sms != null) return 'SMS $sms';
    return 'Open official site';
  }

  Uri get launchUri {
    if (phone != null) {
      return Uri(scheme: 'tel', path: phone!.replaceAll(RegExp(r'\s+'), ''));
    }
    if (sms != null) {
      return Uri(scheme: 'sms', path: sms!.replaceAll(RegExp(r'\s+'), ''));
    }
    return Uri.parse(url!);
  }
}

const zaUrgentRoutes = <UrgentRoute>[
  UrgentRoute(
    kind: UrgentRouteKind.emergency,
    title: 'Emergency services',
    subtitle: 'Police, ambulance, or fire. Helping Hand cannot replace this.',
    phone: '112',
  ),
  UrgentRoute(
    kind: UrgentRouteKind.police,
    title: 'SAPS police',
    subtitle: 'Non-emergency crime reporting in South Africa.',
    phone: '10111',
  ),
  UrgentRoute(
    kind: UrgentRouteKind.crisis,
    title: 'SADAG suicide crisis line',
    subtitle: '24-hour mental health support.',
    phone: '0800 567 567',
  ),
  UrgentRoute(
    kind: UrgentRouteKind.crisis,
    title: 'SADAG SMS',
    subtitle: 'Text a counsellor if calling is hard.',
    sms: '31393',
  ),
  UrgentRoute(
    kind: UrgentRouteKind.crisis,
    title: 'GBV Command Centre',
    subtitle: 'Gender-based violence support line.',
    phone: '0800 428 428',
  ),
  UrgentRoute(
    kind: UrgentRouteKind.fraud,
    title: 'Report fraud or cybercrime',
    subtitle: 'Official SAPS crime-stop information. Do not share OTPs or send money.',
    url: 'https://www.saps.gov.za',
  ),
];
