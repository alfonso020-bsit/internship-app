import 'user_model.dart';

class AgencyModel extends UserModel {
  // Agency Information
  String agencyName;
  String agencyAddress;
  String contactPerson;
  String contactNumber;
  String? agencyLogo;
  String? website;
  String? description;

  // Location coordinates (NEW)
  double? latitude;
  double? longitude;
  String? mapUrl;
  
  // Status and Verification
  bool isVerified;
  List<String>? postedInternships; // IDs of internship posts
  
  // Statistics
  int totalInterns;
  int activeInterns;

  AgencyModel({
    required super.uid,
    required super.email,
    required super.fullAddress,
    super.region,
    super.province,
    super.municipality,
    super.barangay,
    super.sitio,
    super.createdAt,
    super.updatedAt,
    required this.agencyName,
    required this.agencyAddress,
    required this.contactPerson,
    required this.contactNumber,
    this.agencyLogo,
    this.website,
    this.description,
    this.latitude,          // NEW
    this.longitude,         // NEW
    this.mapUrl, 
    this.isVerified = false,
    this.postedInternships,
    this.totalInterns = 0,
    this.activeInterns = 0,
  }) : super(role: UserRole.agency);

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'agencyName': agencyName,
      'agencyAddress': agencyAddress,
      'contactPerson': contactPerson,
      'contactNumber': contactNumber,
      'agencyLogo': agencyLogo,
      'website': website,
      'description': description,
      'latitude': latitude,        // NEW
      'longitude': longitude,       // NEW
      'mapUrl': mapUrl,
      'isVerified': isVerified,
      'postedInternships': postedInternships,
      'totalInterns': totalInterns,
      'activeInterns': activeInterns,
    });
    return map;
  }

  factory AgencyModel.fromMap(Map<String, dynamic> map, String uid) {
    final base = UserModel.fromMap(map, uid);
    return AgencyModel(
      uid: uid,
      email: base.email,
      fullAddress: base.fullAddress,
      region: base.region,
      province: base.province,
      municipality: base.municipality,
      barangay: base.barangay,
      sitio: base.sitio,
      createdAt: base.createdAt,
      updatedAt: base.updatedAt,
      agencyName: map['agencyName'] ?? '',
      agencyAddress: map['agencyAddress'] ?? '',
      contactPerson: map['contactPerson'] ?? '',
      contactNumber: map['contactNumber'] ?? '',
      agencyLogo: map['agencyLogo'],
      website: map['website'],
      description: map['description'],
      latitude: map['latitude']?.toDouble(),     // NEW
      longitude: map['longitude']?.toDouble(),   // NEW
      mapUrl: map['mapUrl'],
      isVerified: map['isVerified'] ?? false,
      postedInternships: map['postedInternships'] != null 
          ? List<String>.from(map['postedInternships']) 
          : null,
      totalInterns: map['totalInterns'] ?? 0,
      activeInterns: map['activeInterns'] ?? 0,
    );
  }
}