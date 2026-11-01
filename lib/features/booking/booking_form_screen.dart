import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/booking.dart';
import '../../models/provider_profile.dart';
import 'booking_state.dart';

class BookingFormScreen extends ConsumerStatefulWidget {
  final ProviderProfile provider;
  const BookingFormScreen({super.key, required this.provider});

  @override
  ConsumerState<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends ConsumerState<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _problem = TextEditingController();
  final _address = TextEditingController();
  DateTime? _date;
  TimeOfDay? _time;

  @override
  void dispose() {
    _problem.dispose();
    _address.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
    );
    if (d != null) setState(() => _date = d);
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (t != null) setState(() => _time = t);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_date == null || _time == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose a date and time.')),
      );
      return;
    }
    final when = DateTime(
        _date!.year, _date!.month, _date!.day, _time!.hour, _time!.minute);
    final p = widget.provider;
    ref.read(bookingsProvider.notifier).add(
          Booking(
            id: 'b${DateTime.now().millisecondsSinceEpoch}',
            providerId: p.id,
            providerName: p.name,
            categoryId: p.categoryId,
            problem: _problem.text.trim(),
            address: _address.text.trim(),
            scheduledAt: when,
            status: BookingStatus.requested,
          ),
        );
    Navigator.of(context).popUntil((r) => r.isFirst);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Request sent. Status: REQUESTED (waiting for provider).'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateText = _date == null
        ? 'Choose date'
        : '${_date!.day}/${_date!.month}/${_date!.year}';
    final timeText = _time == null ? 'Choose time' : _time!.format(context);

    return Scaffold(
      appBar: AppBar(title: Text('Book ${widget.provider.name}')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _problem,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Describe the problem',
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.trim().length < 5)
                  ? 'Please describe the problem (at least 5 characters)'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _address,
              decoration: const InputDecoration(
                labelText: 'Service address',
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Please enter the service address'
                  : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.calendar_today),
                    label: Text(dateText),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickTime,
                    icon: const Icon(Icons.access_time),
                    label: Text(timeText),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _submit,
              child: const Text('Submit request'),
            ),
            const SizedBox(height: 8),
            const Text(
              'The provider must accept before this booking is confirmed. '
              '(MOCK: nothing is sent anywhere yet.)',
            ),
          ],
        ),
      ),
    );
  }
}