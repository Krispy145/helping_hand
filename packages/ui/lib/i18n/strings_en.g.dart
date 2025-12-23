///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final TranslationsStringsEn strings = TranslationsStringsEn._(_root);
}

// Path: strings
class TranslationsStringsEn {
	TranslationsStringsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsStringsCommonEn common = TranslationsStringsCommonEn._(_root);
	late final TranslationsStringsAuthEn auth = TranslationsStringsAuthEn._(_root);
	late final TranslationsStringsOnboardingEn onboarding = TranslationsStringsOnboardingEn._(_root);
	late final TranslationsStringsSettingsEn settings = TranslationsStringsSettingsEn._(_root);
}

// Path: strings.common
class TranslationsStringsCommonEn {
	TranslationsStringsCommonEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'OK'
	String get ok => 'OK';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Error'
	String get error => 'Error';

	/// en: 'Loading...'
	String get loading => 'Loading...';
}

// Path: strings.auth
class TranslationsStringsAuthEn {
	TranslationsStringsAuthEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Login'
	String get login => 'Login';

	/// en: 'Register'
	String get register => 'Register';
}

// Path: strings.onboarding
class TranslationsStringsOnboardingEn {
	TranslationsStringsOnboardingEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsStringsOnboardingWelcomeEn welcome = TranslationsStringsOnboardingWelcomeEn._(_root);
	late final TranslationsStringsOnboardingCommunityEn community = TranslationsStringsOnboardingCommunityEn._(_root);
	late final TranslationsStringsOnboardingLocationEn location = TranslationsStringsOnboardingLocationEn._(_root);
	late final TranslationsStringsOnboardingNotificationsEn notifications = TranslationsStringsOnboardingNotificationsEn._(_root);

	/// en: 'Get Started'
	String get getStarted => 'Get Started';

	/// en: 'Next'
	String get next => 'Next';
}

// Path: strings.settings
class TranslationsStringsSettingsEn {
	TranslationsStringsSettingsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get title => 'Settings';

	late final TranslationsStringsSettingsThemeEn theme = TranslationsStringsSettingsThemeEn._(_root);
	late final TranslationsStringsSettingsPermissionsEn permissions = TranslationsStringsSettingsPermissionsEn._(_root);

	/// en: 'Logout'
	String get logout => 'Logout';
}

// Path: strings.onboarding.welcome
class TranslationsStringsOnboardingWelcomeEn {
	TranslationsStringsOnboardingWelcomeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Welcome to Helping Hand'
	String get title => 'Welcome to Helping Hand';

	/// en: 'A place to ask for help with dignity, and offer help with kindness.'
	String get description => 'A place to ask for help with dignity, and offer help with kindness.';
}

// Path: strings.onboarding.community
class TranslationsStringsOnboardingCommunityEn {
	TranslationsStringsOnboardingCommunityEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Calm & Connected'
	String get title => 'Calm & Connected';

	/// en: 'Connect with your community in a safe, stress-free environment.'
	String get description => 'Connect with your community in a safe, stress-free environment.';
}

// Path: strings.onboarding.location
class TranslationsStringsOnboardingLocationEn {
	TranslationsStringsOnboardingLocationEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Nearby Requests'
	String get title => 'Nearby Requests';

	/// en: 'We need your location to show you requests for help happening right around you.'
	String get description => 'We need your location to show you requests for help happening right around you.';

	/// en: 'Enable Location'
	String get button => 'Enable Location';
}

// Path: strings.onboarding.notifications
class TranslationsStringsOnboardingNotificationsEn {
	TranslationsStringsOnboardingNotificationsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Stay Updated'
	String get title => 'Stay Updated';

	/// en: 'Get notified when someone offers help or accepts your request.'
	String get description => 'Get notified when someone offers help or accepts your request.';

	/// en: 'Enable Notifications'
	String get button => 'Enable Notifications';
}

// Path: strings.settings.theme
class TranslationsStringsSettingsThemeEn {
	TranslationsStringsSettingsThemeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Theme'
	String get title => 'Theme';

	/// en: 'Light'
	String get light => 'Light';

	/// en: 'Dark'
	String get dark => 'Dark';

	/// en: 'System'
	String get system => 'System';
}

// Path: strings.settings.permissions
class TranslationsStringsSettingsPermissionsEn {
	TranslationsStringsSettingsPermissionsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Permissions'
	String get title => 'Permissions';

	/// en: 'Location'
	String get location => 'Location';

	/// en: 'Notifications'
	String get notifications => 'Notifications';

	/// en: 'Camera'
	String get camera => 'Camera';

	/// en: 'Allowed'
	String get allowed => 'Allowed';

	/// en: 'Denied'
	String get denied => 'Denied';

	/// en: 'Permission Required'
	String get required => 'Permission Required';

	/// en: 'Open Settings'
	String get openSettings => 'Open Settings';

	/// en: 'This feature requires permission. Please enable it in system settings.'
	String get description => 'This feature requires permission. Please enable it in system settings.';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'strings.common.ok' => 'OK',
			'strings.common.cancel' => 'Cancel',
			'strings.common.error' => 'Error',
			'strings.common.loading' => 'Loading...',
			'strings.auth.login' => 'Login',
			'strings.auth.register' => 'Register',
			'strings.onboarding.welcome.title' => 'Welcome to Helping Hand',
			'strings.onboarding.welcome.description' => 'A place to ask for help with dignity, and offer help with kindness.',
			'strings.onboarding.community.title' => 'Calm & Connected',
			'strings.onboarding.community.description' => 'Connect with your community in a safe, stress-free environment.',
			'strings.onboarding.location.title' => 'Nearby Requests',
			'strings.onboarding.location.description' => 'We need your location to show you requests for help happening right around you.',
			'strings.onboarding.location.button' => 'Enable Location',
			'strings.onboarding.notifications.title' => 'Stay Updated',
			'strings.onboarding.notifications.description' => 'Get notified when someone offers help or accepts your request.',
			'strings.onboarding.notifications.button' => 'Enable Notifications',
			'strings.onboarding.getStarted' => 'Get Started',
			'strings.onboarding.next' => 'Next',
			'strings.settings.title' => 'Settings',
			'strings.settings.theme.title' => 'Theme',
			'strings.settings.theme.light' => 'Light',
			'strings.settings.theme.dark' => 'Dark',
			'strings.settings.theme.system' => 'System',
			'strings.settings.permissions.title' => 'Permissions',
			'strings.settings.permissions.location' => 'Location',
			'strings.settings.permissions.notifications' => 'Notifications',
			'strings.settings.permissions.camera' => 'Camera',
			'strings.settings.permissions.allowed' => 'Allowed',
			'strings.settings.permissions.denied' => 'Denied',
			'strings.settings.permissions.required' => 'Permission Required',
			'strings.settings.permissions.openSettings' => 'Open Settings',
			'strings.settings.permissions.description' => 'This feature requires permission. Please enable it in system settings.',
			'strings.settings.logout' => 'Logout',
			_ => null,
		};
	}
}
