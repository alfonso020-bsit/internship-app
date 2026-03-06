import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/models/philippine_address.dart';
import 'package:app/components/global_text_field.dart';

class AddressPicker extends StatefulWidget {
  final Function(String fullAddress) onAddressSelected;
  final Function({
    String? region,
    String? province,
    String? municipality,
    String? barangay,
    String? sitio,
  })? onComponentsSelected;
  final TextEditingController? sitioController;

  const AddressPicker({
    super.key,
    required this.onAddressSelected,
    this.onComponentsSelected,
    this.sitioController,
  });

  @override
  AddressPickerState createState() => AddressPickerState(); // Return public state
}

// Make state class public (remove underscore)
class AddressPickerState extends State<AddressPicker> {
  // Controllers
  final _sitioController = TextEditingController();
  
  // Data holders
  Map<String, PhilippineRegions> _regions = {};
  List<String> _regionCodes = [];
  
  // Selected values
  String? _selectedRegionCode;
  String? _selectedProvinceCode;
  String? _selectedMunicipalityCode;
  String? _selectedBarangay;
  
  // Available options based on selections
  List<String> _availableProvinces = [];
  List<String> _availableMunicipalities = [];
  List<String> _availableBarangays = [];
  
  bool _isLoading = true;
  bool _isSettingFromLocation = false;

  @override
  void initState() {
    super.initState();
    _loadAddressData();
    _sitioController.addListener(_updateFullAddress);
  }

  // PUBLIC METHOD: Set address from location detection
void setAddressFromLocation({
  String? region,
  String? province,
  String? municipality,
  String? barangay,
  String? sitio,
}) {
  if (_isLoading) {
    print('⏳ AddressPicker still loading, retrying in 500ms...');
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setAddressFromLocation(
          region: region,
          province: province,
          municipality: municipality,
          barangay: barangay,
          sitio: sitio,
        );
      }
    });
    return;
  }

  print('🔍 DEBUG - Starting address population:');
  print('  Looking for Region: "$region"');
  print('  Looking for Province: "$province"');
  print('  Looking for Municipality: "$municipality"');
  print('  Looking for Barangay: "$barangay"');

  // Print all available regions for debugging
  print('📋 Available regions in phil.json:');
  _regionCodes.forEach((code) {
    print('  - $code: ${_regions[code]?.regionName}');
  });

  setState(() {
    _isSettingFromLocation = true;
    
    // Clear existing selections
    _selectedRegionCode = null;
    _selectedProvinceCode = null;
    _selectedMunicipalityCode = null;
    _selectedBarangay = null;
    _availableProvinces = [];
    _availableMunicipalities = [];
    _availableBarangays = [];

    // Set sitio if provided
    if (sitio != null && sitio.isNotEmpty) {
      _sitioController.text = sitio;
    }

    // ===== 1. FIND AND SET REGION =====
    if (region != null) {
      String searchRegion = _normalizeString(region);
      print('🔍 Searching for region: "$searchRegion" (original: "$region")');
      
      bool regionFound = false;
      
      // First try: Match by region code directly (for cases like "4B")
      for (var code in _regionCodes) {
        if (code == region) {
          _selectedRegionCode = code;
          _availableProvinces = _regions[code]!.provinces.keys.toList();
          print('  ✅ FOUND region by code: $code');
          regionFound = true;
          break;
        }
      }
      
      // Second try: Match by region name
      if (!regionFound) {
        for (var code in _regionCodes) {
          String regionName = _normalizeString(_regions[code]?.regionName ?? '');
          String regionCode = _normalizeString(code);
          
          print('  Checking: "$regionName" (code: $code)');
          
          if (regionName.contains(searchRegion) || 
              searchRegion.contains(regionName) ||
              regionCode.contains(searchRegion) || 
              searchRegion.contains(regionCode)) {
            _selectedRegionCode = code;
            _availableProvinces = _regions[code]!.provinces.keys.toList();
            print('  ✅ FOUND region: ${_regions[code]?.regionName} (code: $code)');
            regionFound = true;
            break;
          }
        }
      }
      
      if (!regionFound) {
        print('  ❌ No matching region found for: "$searchRegion"');
      }
    }

    // ===== 2. FIND AND SET PROVINCE =====
    if (province != null && _selectedRegionCode != null) {
      String searchProvince = _normalizeString(province);
      print('🔍 Searching for province: "$searchProvince"');
      print('📋 Available provinces in selected region:');
      _availableProvinces.forEach((p) => print('  - $p'));
      
      bool provinceFound = false;
      for (var provCode in _availableProvinces) {
        String provName = _normalizeString(provCode);
        print('  Checking province: "$provName"');
        
        if (provName.contains(searchProvince) || searchProvince.contains(provName)) {
          _selectedProvinceCode = provCode;
          _availableMunicipalities = _regions[_selectedRegionCode]!
              .provinces[provCode]!
              .municipalities
              .keys
              .toList();
          print('  ✅ FOUND province: $provCode');
          provinceFound = true;
          break;
        }
      }
      if (!provinceFound) {
        print('  ❌ No matching province found for: "$searchProvince"');
      }
    }

    // ===== 3. FIND AND SET MUNICIPALITY =====
    if (municipality != null && 
        _selectedRegionCode != null && 
        _selectedProvinceCode != null) {
      
      String searchMunicipality = _normalizeString(municipality);
      print('🔍 Searching for municipality: "$searchMunicipality"');
      print('📋 Available municipalities:');
      _availableMunicipalities.forEach((m) => print('  - $m'));
      
      var municipalities = _regions[_selectedRegionCode]!
          .provinces[_selectedProvinceCode]!
          .municipalities;
      
      bool municipalityFound = false;
      for (var munCode in _availableMunicipalities) {
        String munName = _normalizeString(munCode);
        print('  Checking municipality: "$munName"');
        
        if (munName.contains(searchMunicipality) || searchMunicipality.contains(munName)) {
          _selectedMunicipalityCode = munCode;
          _availableBarangays = municipalities[munCode]!.barangays;
          print('  ✅ FOUND municipality: $munCode');
          print('  📋 Barangays available: ${_availableBarangays.length}');
          municipalityFound = true;
          break;
        }
      }
      if (!municipalityFound) {
        print('  ❌ No matching municipality found for: "$searchMunicipality"');
      }
    }

    // ===== 4. FIND AND SET BARANGAY =====
    if (barangay != null && barangay.isNotEmpty && _selectedMunicipalityCode != null) {
      String searchBarangay = _normalizeString(barangay);
      print('🔍 Searching for barangay: "$searchBarangay"');
      
      bool barangayFound = false;
      for (var brgy in _availableBarangays) {
        String brgyName = _normalizeString(brgy);
        if (brgyName.contains(searchBarangay) || searchBarangay.contains(brgyName)) {
          _selectedBarangay = brgy;
          print('  ✅ FOUND barangay: $brgy');
          barangayFound = true;
          break;
        }
      }
      if (!barangayFound) {
        print('  ℹ️ Barangay not found (optional) - user can select manually');
      }
    }

    _isSettingFromLocation = false;
  });

  _updateFullAddress();
  
  print('✅ Address population complete');
  print('  Selected Region: $_selectedRegionCode');
  print('  Selected Province: $_selectedProvinceCode');
  print('  Selected Municipality: $_selectedMunicipalityCode');
  print('  Selected Barangay: $_selectedBarangay');
}

  String _normalizeString(String? input) {
  if (input == null) return '';
  return input
      .toUpperCase()
      .replaceAll('CITY OF ', '')
      .replaceAll('CITY', '')
      .replaceAll('METRO ', '')
      .replaceAll('NATIONAL CAPITAL REGION', 'NCR')
      .replaceAll('REGION', '')
      .replaceAll('-', ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .replaceAll('IV A', '4A')  // Add this
      .replaceAll('IV B', '4B')  // Add this
      .replaceAll('IVA', '4A')   // Add this
      .replaceAll('IVB', '4B')   // Add this
      .trim();
}

  Future<void> _loadAddressData() async {
    try {
      final String response = await rootBundle.loadString('lib/assets/phil.json');
      final Map<String, dynamic> data = json.decode(response);
      
      Map<String, PhilippineRegions> tempRegions = {};
      List<String> tempRegionCodes = [];
      
      data.forEach((code, regionData) {
        tempRegions[code] = PhilippineRegions.fromJson(code, regionData);
        tempRegionCodes.add(code);
      });
      
      setState(() {
        _regions = tempRegions;
        _regionCodes = tempRegionCodes;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading address data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onRegionSelected(String? regionCode) {
    if (_isSettingFromLocation) return;
    
    setState(() {
      _selectedRegionCode = regionCode;
      _selectedProvinceCode = null;
      _selectedMunicipalityCode = null;
      _selectedBarangay = null;
      
      _availableProvinces = [];
      _availableMunicipalities = [];
      _availableBarangays = [];
      
      if (regionCode != null && _regions[regionCode] != null) {
        _availableProvinces = _regions[regionCode]!.provinces.keys.toList();
      }
    });
    _updateFullAddress();
  }

  void _onProvinceSelected(String? provinceCode) {
    if (_isSettingFromLocation) return;
    
    setState(() {
      _selectedProvinceCode = provinceCode;
      _selectedMunicipalityCode = null;
      _selectedBarangay = null;
      
      _availableMunicipalities = [];
      _availableBarangays = [];
      
      if (provinceCode != null && 
          _selectedRegionCode != null && 
          _regions[_selectedRegionCode] != null &&
          _regions[_selectedRegionCode]!.provinces[provinceCode] != null) {
        _availableMunicipalities = _regions[_selectedRegionCode]!
            .provinces[provinceCode]!
            .municipalities
            .keys
            .toList();
      }
    });
    _updateFullAddress();
  }

  void _onMunicipalitySelected(String? municipalityCode) {
    if (_isSettingFromLocation) return;
    
    setState(() {
      _selectedMunicipalityCode = municipalityCode;
      _selectedBarangay = null;
      
      _availableBarangays = [];
      
      if (municipalityCode != null && 
          _selectedRegionCode != null && 
          _selectedProvinceCode != null &&
          _regions[_selectedRegionCode] != null &&
          _regions[_selectedRegionCode]!.provinces[_selectedProvinceCode] != null) {
        var municipality = _regions[_selectedRegionCode]!
            .provinces[_selectedProvinceCode]!
            .municipalities[municipalityCode];
        if (municipality != null) {
          _availableBarangays = municipality.barangays;
        }
      }
    });
    _updateFullAddress();
  }

  void _onBarangaySelected(String? barangay) {
    if (_isSettingFromLocation) return;
    
    setState(() {
      _selectedBarangay = barangay;
    });
    _updateFullAddress();
  }

  void _updateFullAddress() {
    String address = '';
    
    if (_sitioController.text.trim().isNotEmpty) {
      address += _sitioController.text.trim() + ', ';
    }
    
    if (_selectedBarangay != null && _selectedBarangay!.isNotEmpty) {
      address += _selectedBarangay! + ', ';
    }
    
    if (_selectedMunicipalityCode != null) {
      address += _selectedMunicipalityCode! + ', ';
    }
    
    if (_selectedProvinceCode != null) {
      address += _selectedProvinceCode! + ', ';
    }
    
    if (_selectedRegionCode != null && _regions[_selectedRegionCode] != null) {
      address += _regions[_selectedRegionCode]!.regionName;
    }
    
    if (address.endsWith(', ')) {
      address = address.substring(0, address.length - 2);
    }
    
    widget.onAddressSelected(address);
    
    if (widget.onComponentsSelected != null) {
      widget.onComponentsSelected!(
        region: _selectedRegionCode != null && _regions[_selectedRegionCode] != null
            ? _regions[_selectedRegionCode]!.regionName
            : null,
        province: _selectedProvinceCode,
        municipality: _selectedMunicipalityCode,
        barangay: _selectedBarangay,
        sitio: _sitioController.text.trim().isNotEmpty 
            ? _sitioController.text.trim() 
            : null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Address Information',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        
        GlobalTextField(
          controller: _sitioController,
          label: 'Sitio/Purok (Optional)',
          prefixIcon: Icons.location_on,
          onChanged: (value) => _updateFullAddress(),
        ),
        
        const SizedBox(height: 12),
        
        DropdownButtonFormField<String>(
          value: _selectedRegionCode,
          decoration: InputDecoration(
            labelText: 'Region',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            prefixIcon: const Icon(Icons.map),
          ),
          items: _regionCodes.map((code) {
            return DropdownMenuItem(
              value: code,
              child: Text(_regions[code]?.regionName ?? code),
            );
          }).toList(),
          onChanged: _onRegionSelected,
          validator: (value) {
            if (value == null) {
              return 'Please select a region';
            }
            return null;
          },
        ),
        
        const SizedBox(height: 12),
        
        DropdownButtonFormField<String>(
          value: _selectedProvinceCode,
          decoration: InputDecoration(
            labelText: 'Province',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            prefixIcon: const Icon(Icons.location_city),
          ),
          items: _availableProvinces.map((code) {
            return DropdownMenuItem(
              value: code,
              child: Text(code),
            );
          }).toList(),
          onChanged: _availableProvinces.isNotEmpty ? _onProvinceSelected : null,
          validator: (value) {
            if (value == null && _selectedRegionCode != null) {
              return 'Please select a province';
            }
            return null;
          },
        ),
        
        const SizedBox(height: 12),
        
        DropdownButtonFormField<String>(
          value: _selectedMunicipalityCode,
          decoration: InputDecoration(
            labelText: 'Municipality',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            prefixIcon: const Icon(Icons.location_city),
          ),
          items: _availableMunicipalities.map((code) {
            return DropdownMenuItem(
              value: code,
              child: Text(code),
            );
          }).toList(),
          onChanged: _availableMunicipalities.isNotEmpty ? _onMunicipalitySelected : null,
          validator: (value) {
            if (value == null && _selectedProvinceCode != null) {
              return 'Please select a municipality';
            }
            return null;
          },
        ),
        
        const SizedBox(height: 12),
        
        DropdownButtonFormField<String>(
          value: _selectedBarangay,
          decoration: InputDecoration(
            labelText: 'Barangay',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            prefixIcon: const Icon(Icons.location_on),
          ),
          items: _availableBarangays.map((barangay) {
            return DropdownMenuItem(
              value: barangay,
              child: Text(barangay),
            );
          }).toList(),
          onChanged: _availableBarangays.isNotEmpty ? _onBarangaySelected : null,
          validator: (value) {
            if (value == null && _selectedMunicipalityCode != null) {
              return 'Please select a barangay';
            }
            return null;
          },
        ),
        
        const SizedBox(height: 16),
        
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Full Address Preview:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _getPreviewAddress(),
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getPreviewAddress() {
    List<String> parts = [];
    
    if (_sitioController.text.trim().isNotEmpty) {
      parts.add(_sitioController.text.trim());
    }
    
    if (_selectedBarangay != null) {
      parts.add(_selectedBarangay!);
    }
    
    if (_selectedMunicipalityCode != null) {
      parts.add(_selectedMunicipalityCode!);
    }
    
    if (_selectedProvinceCode != null) {
      parts.add(_selectedProvinceCode!);
    }
    
    if (_selectedRegionCode != null && _regions[_selectedRegionCode] != null) {
      parts.add(_regions[_selectedRegionCode]!.regionName);
    }
    
    return parts.isNotEmpty ? parts.join(', ') : 'No address selected';
  }

  @override
  void dispose() {
    _sitioController.removeListener(_updateFullAddress);
    _sitioController.dispose();
    super.dispose();
  }
}