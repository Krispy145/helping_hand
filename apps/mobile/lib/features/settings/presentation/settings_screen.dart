// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ui/ui.dart';

import '../../auth/presentation/widgets/profile_avatar.dart';
import '../../auth/providers/auth_provider.dart';
import '../application/theme_controller.dart';
import 'settings_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final themeMode = ref.watch(themeControllerProvider);
    final state = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: Text(t.strings.settings.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const ProfileAvatar(),
            const SizedBox(height: 32),
            _buildSectionHeader(context, t.strings.settings.theme.title),
            Card(
              child: Column(
                children: [
                  RadioListTile<ThemeMode>(
                    title: Text(t.strings.settings.theme.system),
                    value: ThemeMode.system,
                    groupValue: themeMode,
                    onChanged: (val) => ref.read(themeControllerProvider.notifier).setTheme(val!),
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text(t.strings.settings.theme.light),
                    value: ThemeMode.light,
                    groupValue: themeMode,
                    onChanged: (val) => ref.read(themeControllerProvider.notifier).setTheme(val!),
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text(t.strings.settings.theme.dark),
                    value: ThemeMode.dark,
                    groupValue: themeMode,
                    onChanged: (val) => ref.read(themeControllerProvider.notifier).setTheme(val!),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildSectionHeader(context, t.strings.settings.permissions.title),
            Card(
              child: Column(
                children: [
                  _PermissionTile(
                    title: t.strings.settings.permissions.location,
                    status: state.location,
                    onTap: () => controller.handlePermission(Permission.locationWhenInUse),
                    openSettingsLabel: t.strings.settings.permissions.openSettings,
                    allowedLabel: t.strings.settings.permissions.allowed,
                    deniedLabel: t.strings.settings.permissions.denied,
                  ),
                  const Divider(height: 1),
                  _PermissionTile(
                    title: t.strings.settings.permissions.notifications,
                    status: state.notification,
                    onTap: () => controller.handlePermission(Permission.notification),
                    openSettingsLabel: t.strings.settings.permissions.openSettings,
                    allowedLabel: t.strings.settings.permissions.allowed,
                    deniedLabel: t.strings.settings.permissions.denied,
                  ),
                  const Divider(height: 1),
                  _PermissionTile(
                    title: t.strings.settings.permissions.camera,
                    status: state.camera,
                    onTap: () => controller.handlePermission(Permission.camera),
                    openSettingsLabel: t.strings.settings.permissions.openSettings,
                    allowedLabel: t.strings.settings.permissions.allowed,
                    deniedLabel: t.strings.settings.permissions.denied,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  ref.read(authProvider.notifier).logout();
                  context.go('/login');
                },
                child: Text(t.strings.settings.logout),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: context.bodySmall.copyWith(fontWeight: FontWeight.bold, color: context.textSecondary),
        ),
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  final String title;
  final PermissionStatus? status;
  final VoidCallback onTap;
  final String openSettingsLabel;
  final String allowedLabel;
  final String deniedLabel;

  const _PermissionTile({required this.title, required this.status, required this.onTap, required this.openSettingsLabel, required this.allowedLabel, required this.deniedLabel});

  @override
  Widget build(BuildContext context) {
    final isGranted = status?.isGranted ?? false;
    final isPermaDenied = status?.isPermanentlyDenied ?? false;

    return ListTile(
      title: Text(title),
      trailing: isGranted
          ? Icon(Icons.check_circle, color: context.success)
          : isPermaDenied
          ? TextOutlineButton(label: openSettingsLabel)
          : const Icon(Icons.arrow_forward_ios, size: 16),
      subtitle: isGranted
          ? Text(allowedLabel, style: TextStyle(color: context.success, fontSize: 12))
          : isPermaDenied
          ? Text(deniedLabel, style: TextStyle(color: context.error, fontSize: 12))
          : null,
      onTap: onTap,
    );
  }
}

class TextOutlineButton extends StatelessWidget {
  final String label;
  const TextOutlineButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: context.primary),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, color: context.primary, fontWeight: FontWeight.bold),
      ),
    );
  }
}
