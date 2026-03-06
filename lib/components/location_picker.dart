import 'package:flutter/material.dart';
import 'package:app/services/location_service.dart';

class LocationPicker extends StatefulWidget {
  final Function({
    double? latitude,
    double? longitude,
    String? street,
    String? barangay,
    String? municipality,
    String? province,
    String? region,
  }) onLocationDetected;
  
  final VoidCallback? onManualEntry;

  const LocationPicker({
    super.key,
    required this.onLocationDetected,
    this.onManualEntry,
  });

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  bool _isLoading = false;

  Future<void> _detectLocation() async {
    setState(() => _isLoading = true);

    try {
      final locationData = await LocationService.getCurrentLocationWithAddress();
      
      if (locationData != null && mounted) {
        final address = locationData['address'] as Map<String, String?>?;
        
        widget.onLocationDetected(
          latitude: locationData['latitude'] as double?,
          longitude: locationData['longitude'] as double?,
          street: address?['street'],
          barangay: address?['barangay'],
          municipality: address?['municipality'],
          province: address?['province'],
          region: address?['region'],
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Location detected! Address fields have been populated.'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        _showErrorDialog('Could not detect location. Please check your GPS and permissions.');
      }
    } catch (e) {
      _showErrorDialog('Error detecting location: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Location Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
          if (widget.onManualEntry != null)
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                widget.onManualEntry!();
              },
              child: const Text('Enter Manually'),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.my_location,
                  color: Colors.blue.shade700,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Quick Setup',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Use your current location to automatically fill in your address details',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _detectLocation,
                  icon: _isLoading
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.gps_fixed),
                  label: Text(_isLoading ? 'Detecting...' : 'Use My Current Location'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
          if (widget.onManualEntry != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: widget.onManualEntry,
                    icon: const Icon(Icons.edit),
                    label: const Text('Enter Address Manually'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}