import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:map/map.dart';
import 'package:models/models.dart';

import '../providers/request_provider.dart';

class CreateRequestScreen extends ConsumerStatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  ConsumerState<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends ConsumerState<CreateRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _categoryController = TextEditingController();

  RequestUrgencyDto _urgency = RequestUrgencyDto.MEDIUM;
  bool _locating = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<LatLng?> _resolveLocation() async {
    final cached = ref.read(userLocationProvider).asData?.value;
    if (cached != null) return cached;

    setState(() => _locating = true);
    try {
      return await ref.refresh(userLocationProvider.future);
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final location = await _resolveLocation();
    if (location == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Turn on location so helpers can find this request nearby.',
          ),
        ),
      );
      return;
    }

    final dto = CreateRequestDto(
      title: _titleController.text,
      description: _descController.text,
      category: _categoryController.text,
      urgency: _urgency,
      lat: location.latitude,
      lng: location.longitude,
    );

    try {
      await ref.read(requestProvider.notifier).createRequest(dto);
      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request created successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(requestProvider);
    final isLoading = state.isLoading || _locating;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Ask for Help')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category (Optional)'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<RequestUrgencyDto>(
                initialValue: _urgency,
                decoration: const InputDecoration(labelText: 'Urgency'),
                items: RequestUrgencyDto.values.map((urgency) {
                  return DropdownMenuItem(value: urgency, child: Text(urgency.name));
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _urgency = val);
                  }
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Helpers see an approximate area, not your exact spot. Precise location is only shared after a session starts and you both agree.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: isLoading ? null : _submit,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Submit Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
