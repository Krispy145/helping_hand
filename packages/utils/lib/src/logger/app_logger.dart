import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Log level enum for categorizing log messages
enum LogLevel { debug, info, warning, error, fatal }

/// Feature enum for categorizing logs by functional area
enum LogFeature {
  auth('🔐'),
  storage('💾'),
  map('🗺️'),
  network('🌐'),
  ui('🖼️'),
  core('⚡'),
  onboarding('🚀'),
  settings('⚙️'),
  notification('🔔');

  final String emoji;
  const LogFeature(this.emoji);
}

/// Callback type for custom log handlers
typedef LogHandler = void Function(LogLevel level, String message, {Object? error, StackTrace? stackTrace, Map<String, dynamic>? extras, LogFeature? feature});

/// Setup class for configuring AppLoggerInjector
class LoggerSetup {
  LoggerSetup({this.enableDebugLogging = kDebugMode, this.handlers = const []});

  /// Enable debug printing for local development
  final bool enableDebugLogging;

  /// Custom log handlers (e.g., Firebase Crashlytics, Datadog, etc.)
  final List<LogHandler> handlers;
}

/// Lazy getter for AppLoggerInjector
// ignore: non_constant_identifier_names
AppLoggerInjector get AppLogger => AppLoggerInjector.instance;

/// Centralized logging class that can connect to various logging services
class AppLoggerInjector {
  AppLoggerInjector._();
  static final AppLoggerInjector instance = AppLoggerInjector._();

  final List<LogHandler> _handlers = [];
  bool _isInitialized = false;
  late final Logger _logger;

  /// Initialize the logger with setup configuration
  void initialize({LoggerSetup? setup}) {
    final config = setup ?? LoggerSetup();

    if (_isInitialized) {
      if (kDebugMode) {
        print('AppLoggerInjector already initialized');
      }
      return;
    }

    // Initialize Logger instance
    _logger = Logger(
      level: Level.all, // Ensure all logs are shown
      printer: PrettyPrinter(
        methodCount: 0, // Don't show method count
      ),
    );

    _handlers.clear();

    // Add debug handler for local development
    if (config.enableDebugLogging) {
      _handlers.add(_debugHandler);
    }

    // Add custom handlers from setup
    _handlers.addAll(config.handlers);

    _isInitialized = true;
  }

  /// Debug handler for local development
  void _debugHandler(LogLevel level, String message, {Object? error, StackTrace? stackTrace, Map<String, dynamic>? extras, LogFeature? feature}) {
    // Build the log message with feature and extras
    final buffer = StringBuffer();
    if (feature != null) {
      buffer.write('[${feature.emoji} ${feature.name}] ');
    }
    buffer.write(message);

    if (extras != null && extras.isNotEmpty) {
      buffer.write('\nExtras: $extras');
    }

    final logMessage = buffer.toString();

    // Use Logger's appropriate method based on level
    switch (level) {
      case LogLevel.debug:
        _logger.d(logMessage, error: error, stackTrace: stackTrace);
        break;
      case LogLevel.info:
        _logger.i(logMessage, error: error, stackTrace: stackTrace);
        break;
      case LogLevel.warning:
        _logger.w(logMessage, error: error, stackTrace: stackTrace);
        break;
      case LogLevel.error:
        _logger.e(logMessage, error: error, stackTrace: stackTrace);
        break;
      case LogLevel.fatal:
        _logger.f(logMessage, error: error, stackTrace: stackTrace);
        break;
    }
  }

  /// Log a debug message
  void debug(String message, {Map<String, dynamic>? extras, LogFeature? feature}) {
    _log(LogLevel.debug, message, extras: extras, feature: feature);
  }

  /// Log an info message
  void info(String message, {Map<String, dynamic>? extras, LogFeature? feature}) {
    _log(LogLevel.info, message, extras: extras, feature: feature);
  }

  /// Log a warning message
  void warning(String message, {Object? error, Map<String, dynamic>? extras, LogFeature? feature}) {
    _log(LogLevel.warning, message, error: error, extras: extras, feature: feature);
  }

  /// Log an error message
  void error(String message, {Object? error, StackTrace? stackTrace, Map<String, dynamic>? extras, LogFeature? feature}) {
    _log(LogLevel.error, message, error: error, stackTrace: stackTrace, extras: extras, feature: feature);
  }

  /// Log an fatal error message
  void fatal(String message, {Object? error, StackTrace? stackTrace, Map<String, dynamic>? extras, LogFeature? feature}) {
    _log(LogLevel.fatal, message, error: error, stackTrace: stackTrace, extras: extras, feature: feature);
  }

  void _log(LogLevel level, String message, {Object? error, StackTrace? stackTrace, Map<String, dynamic>? extras, LogFeature? feature}) {
    if (!_isInitialized) {
      // Fallback to basic print if logger not initialized
      debugPrint('AppLoggerInjector not initialized. Message: $message');
      return;
    }

    for (final handler in _handlers) {
      try {
        handler(level, message, error: error, stackTrace: stackTrace, extras: extras, feature: feature);
      } catch (e) {
        _logger.e('Error in log handler: $e', error: e);
      }
    }
  }
}
