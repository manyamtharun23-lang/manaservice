import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/mock/mock_data.dart';
import 'provider_registration_state.dart';

const _regulated = {'veterinary', 'medical'};

class ProviderRegistrationScreen extends ConsumerStatefulWidget {
  const ProviderRegistrationScreen({super.key});

  @override
  ConsumerState<ProviderRegistrationScreen> createState() =>
      _ProviderRegistrationScreenState();
}

class _ProviderRegistrationScreenState
    extends ConsumerState<ProviderRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _area = TextEditingController();
  final _languages = TextEditingController();
  final _experience = TextEditingController();
  final Set<String> _cats = {};
  PricingModel _pricing = PricingModel.inspectionQuote;

  @override
  void initState() {
    super.initState();
    final r = ref.read(registrationProvider);
    if (r != null) {
      _cats.addAll(r.categoryIds);
      _area.text = r.serviceArea;
      _languages.text = r.languages;
      _experience.text = r.experience;
      _pricing = r.pricing;
    }
  }

  @override
  void dispose() {
    _area.dispose();
    _languages.dispose();
    _experience.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    if (_cats.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose at least one service category.')),
      );
      return;
    }
    ref.read(registrationProvider.notifier).save(
          ProviderRegistration(
            categoryIds: Set.of(_cats),
            serviceArea: _area.text.trim(),
            pricing: _pricing,
            languages: _languages.text.trim(),
            experience: _experience.text.trim(),
          ),
        );
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile saved. Verification: pending review (MOCK).'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasRegulated = _cats.any(_regulated.contains);
    return Scaffold(
      appBar: AppBar(title: const Text('Provider profile')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Services you offer',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final c in mockCategories)
                  FilterChip(
                    label: Text(c.name),
                    selected: _cats.contains(c.id),
                    onSelected: (v) {
                      setState(() {
                        if (v) {
                          _cats.add(c.id);
                        } else {
                          _cats.remove(c.id);
                        }
                      });
                    },
                  ),
              ],
            ),
            if (hasRegulated)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Veterinary and Medical services need professional '
                    'credentials to be checked by an administrator before '
                    'your profile can show as verified. Until then you will '
                    'appear as "Not verified". Do not advertise regulated '
                    'practice unless you are legally registered.',
                  ),
                ),
              ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _area,
              decoration: const InputDecoration(
                labelText: 'Service area (village, town or postal code)',
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Enter your service area'
                  : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<PricingModel>(
              initialValue: _pricing,
              decoration: const InputDecoration(
                labelText: 'Pricing model',
                border: OutlineInputBorder(),
              ),
              items: [
                for (final m in PricingModel.values)
                  DropdownMenuItem(value: m, child: Text(pricingLabel(m))),
              ],
              onChanged: (m) {
                if (m != null) setState(() => _pricing = m);
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _languages,
              decoration: const InputDecoration(
                labelText: 'Languages spoken (for example Telugu, Hindi)',
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Enter at least one language'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _experience,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Experience (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _save, child: const Text('Save profile')),
            const SizedBox(height: 8),
            const Text('MOCK: nothing is uploaded or verified yet.'),
          ],
        ),
      ),
    );
  }
}