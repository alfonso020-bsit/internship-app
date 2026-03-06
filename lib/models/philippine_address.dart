class PhilippineRegions {
  final String regionCode;
  final String regionName;
  final Map<String, PhilippineProvinces> provinces;

  PhilippineRegions({
    required this.regionCode,
    required this.regionName,
    required this.provinces,
  });

  factory PhilippineRegions.fromJson(String code, Map<String, dynamic> json) {
    Map<String, PhilippineProvinces> provinceMap = {};
    if (json['province_list'] != null) {
      (json['province_list'] as Map<String, dynamic>).forEach((provinceCode, provinceData) {
        provinceMap[provinceCode] = PhilippineProvinces.fromJson(provinceCode, provinceData);
      });
    }
    
    return PhilippineRegions(
      regionCode: code,
      regionName: json['region_name'] ?? '',
      provinces: provinceMap,
    );
  }
}

class PhilippineProvinces {
  final String provinceCode;
  final Map<String, PhilippineMunicipalities> municipalities;

  PhilippineProvinces({
    required this.provinceCode,
    required this.municipalities,
  });

  factory PhilippineProvinces.fromJson(String code, Map<String, dynamic> json) {
    Map<String, PhilippineMunicipalities> municipalityMap = {};
    if (json['municipality_list'] != null) {
      (json['municipality_list'] as Map<String, dynamic>).forEach((municipalityCode, municipalityData) {
        municipalityMap[municipalityCode] = PhilippineMunicipalities.fromJson(municipalityCode, municipalityData);
      });
    }
    
    return PhilippineProvinces(
      provinceCode: code,
      municipalities: municipalityMap,
    );
  }
}

class PhilippineMunicipalities {
  final String municipalityCode;
  final List<String> barangays;

  PhilippineMunicipalities({
    required this.municipalityCode,
    required this.barangays,
  });

  factory PhilippineMunicipalities.fromJson(String code, Map<String, dynamic> json) {
    List<String> barangayList = [];
    if (json['barangay_list'] != null) {
      barangayList = List<String>.from(json['barangay_list']);
    }
    
    return PhilippineMunicipalities(
      municipalityCode: code,
      barangays: barangayList,
    );
  }
}