import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/ui.dart';
import 'package:utils/utils.dart';

import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(authProvider.notifier).register(_emailController.text, _passwordController.text, _nameController.text);

      if (mounted && ref.read(authProvider).hasValue && ref.read(authProvider).value != null) {
        context.go('/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.hasError && (!previous!.hasError || previous.error != next.error)) {
        context.showErrorSnackBar(next.error);
      }
    });

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: context.primary),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              elevation: 4,
              shadowColor: Colors.black.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Join Us', style: context.h1.copyWith(color: context.primary)),
                      const SizedBox(height: 8),
                      Text('Create your account', style: context.bodyLarge.copyWith(color: context.textSecondary)),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _nameController,
                        autofillHints: const [AutofillHints.name],
                        decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline)),
                        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        autofillHints: const [AutofillHints.email],
                        decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
                        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        autofillHints: const [AutofillHints.newPassword],
                        decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outline)),
                        obscureText: true,
                        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 32),
                      if (authState.isLoading)
                        const BreathingLoader()
                      else
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(onPressed: _submit, child: const Text('Register')),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
