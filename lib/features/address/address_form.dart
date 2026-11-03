import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../models/address.dart';

class AddressFormController {
  final line = TextEditingController();
  final village = TextEditingController();
  final district = TextEditingController();
  final pincode = TextEditingController();
  String? state;
  double? latitude;
  double? longitude;

  void dispose() {
    line.dispose();
    village.dispose();
    district.dispose();
    pincode.dispose();
  }

  ServiceAddress toAddress() => ServiceAddress(
    line: line.text.trim(),
    village: village.text.trim(),
    district: district.text.trim(),
    state: state ?? '',
    pincode: pincode.text.trim(),
    latitude: latitude,
    longitude: longitude,
  );
}

class AddressForm extends StatefulWidget {
  final AddressFormController controller;
  const AddressForm({super.key, required this.controller});

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  bool _locating = false;

  Future<void> _useMyLocation() async {
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Use your location?'),
        content: const Text(
          'We use your location only to find providers near you. '
          'You can also type the address yourself.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Not now'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
    if (ok != true) return;

    setState(() => _locating = true);
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Please turn on Location in phone settings.'),
          ),
        );
        return;
      }
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text(
              'Location permission denied. Please type your address.',
            ),
          ),
        );
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      final c = widget.controller;
      setState(() {
        c.latitude = pos.latitude;
        c.longitude = pos.longitude;
      });
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Location saved. Please type your address below.'),
        ),
      );
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Could not get location. Please type your address.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OutlinedButton.icon(
          onPressed: _locating ? null : _useMyLocation,
          icon: _locating
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.my_location),
          label: const Text('Use my current location'),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: c.line,
          decoration: const InputDecoration(
            labelText: 'House no. / street / landmark',
            border: OutlineInputBorder(),
          ),
          validator: (v) => (v == null || v.trim().isEmpty)
              ? 'Enter house or street details'
              : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: c.village,
          decoration: const InputDecoration(
            labelText: 'Village / town / city',
            border: OutlineInputBorder(),
          ),
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Enter village or town' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: c.district,
          decoration: const InputDecoration(
            labelText: 'District',
            border: OutlineInputBorder(),
          ),
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Enter district' : null,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          key: ValueKey(c.state),
          initialValue: c.state,
          isExpanded: true,
          decoration: const InputDecoration(
            labelText: 'State',
            border: OutlineInputBorder(),
          ),
          items: [
            for (final s in indianStates)
              DropdownMenuItem(value: s, child: Text(s)),
          ],
          onChanged: (v) => c.state = v,
          validator: (v) => v == null ? 'Choose a state' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: c.pincode,
          keyboardType: TextInputType.number,
          maxLength: 6,
          decoration: const InputDecoration(
            labelText: 'Pincode',
            border: OutlineInputBorder(),
          ),
          validator: (v) =>
              isValidPincode(v ?? '') ? null : 'Enter a valid 6-digit pincode',
        ),
        if (c.latitude != null)
          const Text(
            'Location attached (GPS).',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
      ],
    );
  }
}
