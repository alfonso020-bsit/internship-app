import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/components/global_text_field.dart';
import 'package:app/components/global_password_field.dart';
import 'package:app/components/global_button.dart';
import 'package:app/components/global_card.dart';
import 'package:app/components/address_picker.dart';
import 'package:app/components/location_picker.dart';
import 'package:app/models/agency_model.dart';
import 'login_screen.dart';
import 'package:app/utils/app_theme.dart';

// Define a type for AddressPicker state
// typedef AddressPickerState = State<AddressPicker>;
// final GlobalKey<AddressPickerState> _addressPickerKey = GlobalKey<AddressPickerState>();

class AgencyRegisterScreen extends StatefulWidget {
  const AgencyRegisterScreen({super.key});

  @override
  State<AgencyRegisterScreen> createState() => _AgencyRegisterScreenState();
}

class _AgencyRegisterScreenState extends State<AgencyRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // FIX 1: Add these missing instances
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  
  // Key to access AddressPicker methods - FIX 2: Use GlobalKey<AddressPickerState>
  final GlobalKey<AddressPickerState> _addressPickerKey = GlobalKey();
  
  // Account Information
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  // Agency Information
  final _agencyNameController = TextEditingController();
  final _agencyAddressController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _websiteController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  // Address from picker
  String _fullAddress = '';
  String? _selectedRegion;
  String? _selectedProvince;
  String? _selectedMunicipality;
  String? _selectedBarangay;
  String? _selectedSitio;
  
  // Location coordinates (for mapping)
  double? _latitude;
  double? _longitude;
  
  // UI State
  bool _isLoading = false;
  bool _useLocationFirst = true;

  @override
  void initState() {
    super.initState();
  }

  // Handle detected location from LocationPicker
void _onLocationDetected({
  double? latitude,
  double? longitude,
  String? street,
  String? barangay,
  String? municipality,
  String? province,
  String? region,
}) {
  // Log what was detected
  // print('🎯 LOCATION DETECTED:');
  // print('  Lat/Lng: $latitude, $longitude');
  // print('  Street: $street');
  // print('  Barangay: $barangay');
  // print('  Municipality: $municipality');
  // print('  Province: $province');
  // print('  Region: $region');

  // Set coordinates
  setState(() {
    _latitude = latitude;
    _longitude = longitude;
    _useLocationFirst = false;
  });

  // Populate street address field
  if (street != null && street.isNotEmpty) {
    _agencyAddressController.text = street;
  }

  // Map the values to phil.json format
  String? mappedRegion = _mapToPhilJsonRegion(region);
  String? mappedProvince = _mapToPhilJsonProvince(province, municipality);
  String? mappedMunicipality = _mapToPhilJsonMunicipality(municipality);
  
  // print('  Mapped Values:');
  // print('    Region: $mappedRegion');
  // print('    Province: $mappedProvince');
  // print('    Municipality: $mappedMunicipality');

  // Populate address picker
  _addressPickerKey.currentState?.setAddressFromLocation(
    region: mappedRegion,
    province: mappedProvince,
    municipality: mappedMunicipality,
    barangay: barangay, // Usually matches
    sitio: null,
  );
}

String? _mapToPhilJsonRegion(String? region) {
  if (region == null) return null;
  
  print('🔄 Mapping region: "$region"');
  
  // Normalize the input
  String normalized = region.toUpperCase().trim();
  
  // Special case for MIMAROPA (this is your region!)
  if (normalized.contains('MIMAROPA') || 
      normalized.contains('IV-B') || 
      normalized.contains('4B')) {
    // print('  ✅ MIMAROPA detected -> 4B');
    return '4B';
  }
  
  // Special case for CALABARZON
  if (normalized.contains('CALABARZON') || 
      normalized.contains('IV-A') || 
      normalized.contains('4A')) {
    // print('  ✅ CALABARZON detected -> 4A');
    return '4A';
  }
  
  // Region mapping dictionary
  final Map<String, String> regionMap = {
    // NCR
    'METRO MANILA': 'NCR',
    'NATIONAL CAPITAL REGION': 'NCR',
    'NCR': 'NCR',
    'MANILA': 'NCR',
    
    // Region I - Ilocos
    'REGION I': 'REGION I',
    'ILOCOS': 'REGION I',
    'I': 'REGION I',
    
    // Region II - Cagayan Valley
    'REGION II': 'REGION II',
    'CAGAYAN': 'REGION II',
    'II': 'REGION II',
    
    // Region III - Central Luzon
    'REGION III': 'REGION III',
    'CENTRAL LUZON': 'REGION III',
    'III': 'REGION III',
    
    // Region V - Bicol
    'REGION V': '05',
    'BICOL': '05',
    'V': '05',
    
    // Region VI - Western Visayas
    'REGION VI': '06',
    'WESTERN VISAYAS': '06',
    'VI': '06',
    
    // Region VII - Central Visayas
    'REGION VII': '07',
    'CENTRAL VISAYAS': '07',
    'VII': '07',
    
    // Region VIII - Eastern Visayas
    'REGION VIII': '08',
    'EASTERN VISAYAS': '08',
    'VIII': '08',
    
    // Region IX - Zamboanga Peninsula
    'REGION IX': '09',
    'ZAMBOANGA': '09',
    'IX': '09',
    
    // Region X - Northern Mindanao
    'REGION X': '10',
    'NORTHERN MINDANAO': '10',
    'X': '10',
    
    // Region XI - Davao Region
    'REGION XI': '11',
    'DAVAO': '11',
    'XI': '11',
    
    // Region XII - SOCCSKSARGEN
    'REGION XII': '12',
    'SOCCSKSARGEN': '12',
    'XII': '12',
    
    // Region XIII - Caraga
    'REGION XIII': '13',
    'CARAGA': '13',
    'XIII': '13',
    
    // BARMM
    'BARMM': 'BARMM',
    'BANGSAMORO': 'BARMM',
    
    // CAR
    'CAR': 'CAR',
    'CORDILLERA': 'CAR',
  };
  
  // Try exact match first
  if (regionMap.containsKey(normalized)) {
    // print('  ✅ Exact match: ${regionMap[normalized]}');
    return regionMap[normalized];
  }
  
  // Try contains match (but be careful with Roman numerals!)
  for (var key in regionMap.keys) {
    // Skip single Roman numerals to avoid false matches
    if (key.length == 1 && (key == 'I' || key == 'V' || key == 'X')) {
      continue;
    }
    
    if (normalized.contains(key)) {
      // print('  ✅ Contains match: "$key" -> ${regionMap[key]}');
      return regionMap[key];
    }
  }
  
  // If still not found, try to extract region number
  final RegExp regionRegex = RegExp(r'REGION\s*([IVX]+|\d+)', caseSensitive: false);
  final match = regionRegex.firstMatch(normalized);
  if (match != null) {
    String regionNum = match.group(1) ?? '';
    
    // Convert Roman numerals
    if (regionNum == 'I') return 'REGION I';
    if (regionNum == 'II') return 'REGION II';
    if (regionNum == 'III') return 'REGION III';
    if (regionNum == 'IV' || regionNum == 'IV-A' || regionNum == 'IVA') return '4A'; // CALABARZON
    if (regionNum == 'IV-B' || regionNum == 'IVB') return '4B'; // MIMAROPA
    if (regionNum == 'V') return '05';
    if (regionNum == 'VI') return '06';
    if (regionNum == 'VII') return '07';
    if (regionNum == 'VIII') return '08';
    if (regionNum == 'IX') return '09';
    if (regionNum == 'X') return '10';
    if (regionNum == 'XI') return '11';
    if (regionNum == 'XII') return '12';
    if (regionNum == 'XIII') return '13';
    
    return 'REGION $regionNum';
  }
  
  // print('  ❌ No match found for: "$region"');
  return region;
}

String? _mapToPhilJsonProvince(String? province, String? municipality) {
  if (province == null) return null;
  
  // print('🔄 Mapping province: "$province"');
  
  String upperProvince = province.toUpperCase();
  
  // Extract the actual province name (remove "Mimaropa (Region IV-B)" part)
  if (upperProvince.contains('MIMAROPA')) {
    // For Victoria, Oriental Mindoro, we need to return the correct province
    if (municipality != null && municipality.toUpperCase().contains('VICTORIA')) {
      return 'ORIENTAL MINDORO';
    }
  }
  
  // Handle NCR
  if (upperProvince.contains('METRO MANILA') || 
      upperProvince.contains('NCR') || 
      upperProvince.contains('NATIONAL CAPITAL')) {
    
    if (municipality != null) {
      String upperMun = municipality.toUpperCase();
      
      if (['MAKATI', 'PASIG', 'PATEROS', 'TAGUIG', 'PARAÑAQUE', 'LAS PIÑAS', 'MUNTINLUPA']
          .any((m) => upperMun.contains(m))) {
        return 'NATIONAL CAPITAL REGION - FOURTH DISTRICT';
      }
      if (upperMun.contains('MANILA')) {
        return 'NATIONAL CAPITAL REGION - MANILA';
      }
      if (['QUEZON', 'SAN JUAN', 'MANDALUYONG', 'MARIKINA']
          .any((m) => upperMun.contains(m))) {
        return 'NATIONAL CAPITAL REGION - SECOND DISTRICT';
      }
      if (['CALOOCAN', 'VALENZUELA', 'MALABON', 'NAVOTAS']
          .any((m) => upperMun.contains(m))) {
        return 'NATIONAL CAPITAL REGION - THIRD DISTRICT';
      }
    }
  }
  
  // Clean up province name
  String cleanProvince = province
      .replaceAll(' (Region IV-B)', '')
      .replaceAll(' (Region IV-A)', '')
      .replaceAll(' Region', '')
      .trim();
  
  return cleanProvince.toUpperCase();
}

String? _mapToPhilJsonMunicipality(String? municipality) {
  if (municipality == null) return null;
  
  // Handle city/municipality names
  String mapped = municipality
      .replaceAll(' City', '')
      .replaceAll('City of ', '')
      .toUpperCase();
  
  // Special cases
  if (municipality.contains('Quezon City')) return 'QUEZON CITY';
  if (municipality.contains('Manila')) return 'MANILA';
  if (municipality.contains('Caloocan')) return 'CALOOCAN CITY';
  if (municipality.contains('Las Piñas')) return 'LAS PIÑAS';
  if (municipality.contains('Parañaque')) return 'PARAÑAQUE';
  
  return mapped;
}

  // Switch to manual entry
  void _switchToManualEntry() {
    setState(() {
      _useLocationFirst = false;
    });
  }

  Future<void> _registerAgency() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_fullAddress.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete your address selection'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Generate map URL if coordinates exist
      String? mapUrl;
      if (_latitude != null && _longitude != null) {
        mapUrl = 'https://www.google.com/maps?q=$_latitude,$_longitude';
      }

      AgencyModel newAgency = AgencyModel(
        uid: userCredential.user!.uid,
        email: _emailController.text.trim(),
        fullAddress: _fullAddress,
        region: _selectedRegion,
        province: _selectedProvince,
        municipality: _selectedMunicipality,
        barangay: _selectedBarangay,
        sitio: _selectedSitio,
        latitude: _latitude,
        longitude: _longitude,
        mapUrl: mapUrl,
        agencyName: _agencyNameController.text.trim(),
        agencyAddress: _agencyAddressController.text.trim(),
        contactPerson: _contactPersonController.text.trim(),
        contactNumber: _contactNumberController.text.trim(),
        website: _websiteController.text.trim().isEmpty 
            ? null 
            : _websiteController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        isVerified: false,
        postedInternships: [],
        totalInterns: 0,
        activeInterns: 0,
      );

      await _firestore
          .collection('agencies')
          .doc(userCredential.user!.uid)
          .set(newAgency.toMap());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Agency account created successfully! Please login.'),
            backgroundColor: Colors.green,
          ),
        );
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Registration failed';
      if (e.code == 'weak-password') {
        message = 'Password is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'Email already in use';
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        title: const Text('Register Agency'),
        backgroundColor: AppTheme.agencyColor,
        foregroundColor: AppTheme.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: GlobalCard(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Show Location Picker first (optional)
                if (_useLocationFirst) ...[
                  LocationPicker(
                    onLocationDetected: _onLocationDetected,
                    onManualEntry: _switchToManualEntry,
                  ),
                  const Divider(height: 32),
                ],

                // Agency Information Section
                const Text(
                  'Agency Information',
                  style: AppTheme.heading4,
                ),
                const SizedBox(height: 16),
                
                GlobalTextField(
                  controller: _agencyNameController,
                  label: 'Agency/Company Name',
                  prefixIcon: Icons.business,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter agency name';
                    }
                    return null;
                  },
                ),
                
                GlobalTextField(
                  controller: _agencyAddressController,
                  label: 'Street Address (Building, Street)',
                  prefixIcon: Icons.home,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter street address';
                    }
                    return null;
                  },
                ),
                
                // Address Picker Component
                AddressPicker(
                  key: _addressPickerKey,
                  onAddressSelected: (address) {
                    setState(() {
                      _fullAddress = address;
                    });
                  },
                  onComponentsSelected: ({
                    region,
                    province,
                    municipality,
                    barangay,
                    sitio,
                  }) {
                    setState(() {
                      _selectedRegion = region;
                      _selectedProvince = province;
                      _selectedMunicipality = municipality;
                      _selectedBarangay = barangay;
                      _selectedSitio = sitio;
                    });
                  },
                ),
                
                // Show coordinates if available
                if (_latitude != null && _longitude != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.studentColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.green.shade700),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Location Detected',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Lat: ${_latitude!.toStringAsFixed(6)}, Lng: ${_longitude!.toStringAsFixed(6)}',
                                style: const TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                const SizedBox(height: 16),
                
                // Contact Information Section
                const Text(
                  'Contact Information',
                  style: AppTheme.heading1,
                ),
                const SizedBox(height: 16),
                
                GlobalTextField(
                  controller: _contactPersonController,
                  label: 'Contact Person',
                  prefixIcon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter contact person';
                    }
                    return null;
                  },
                ),
                
                GlobalTextField(
                  controller: _contactNumberController,
                  label: 'Contact Number',
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter contact number';
                    }
                    return null;
                  },
                ),
                
                GlobalTextField(
                  controller: _websiteController,
                  label: 'Website (Optional)',
                  prefixIcon: Icons.language,
                  keyboardType: TextInputType.url,
                ),
                
                GlobalTextField(
                  controller: _descriptionController,
                  label: 'Agency Description (Optional)',
                  prefixIcon: Icons.description,
                  maxLines: 3,
                ),
                
                const SizedBox(height: 24),
                
                // Account Information Section
                const Text(
                  'Account Information',
                  style: AppTheme.heading4,
                ),
                const SizedBox(height: 16),
                
                GlobalTextField(
                  controller: _emailController,
                  label: 'Email',
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                    if (!value.contains('@')) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                
                GlobalPasswordField(
                  controller: _passwordController,
                  label: 'Password',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                
                GlobalPasswordField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 24),
                
                GlobalButton(
                  text: 'Create Agency Account',
                  onPressed: _registerAgency,
                  isLoading: _isLoading,
                  color: AppTheme.agencyColor,
                ),
                
                const SizedBox(height: 16),
                
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Back to role selection'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _agencyNameController.dispose();
    _agencyAddressController.dispose();
    _contactPersonController.dispose();
    _contactNumberController.dispose();
    _websiteController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}