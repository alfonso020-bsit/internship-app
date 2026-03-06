import 'package:cloud_firestore/cloud_firestore.dart';  // Add this import

enum UserRole { student, agency }

class UserModel {
  String? uid;
  String email;
  UserRole role;
  String fullAddress;
  
  // Address components (for searching/filtering)
  String? region;
  String? province;
  String? municipality;
  String? barangay;
  String? sitio;
  
  // Timestamps
  DateTime? createdAt;
  DateTime? updatedAt;

  UserModel({
    this.uid,
    required this.email,
    required this.role,
    required this.fullAddress,
    this.region,
    this.province,
    this.municipality,
    this.barangay,
    this.sitio,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role.toString().split('.').last,
      'fullAddress': fullAddress,
      'region': region,
      'province': province,
      'municipality': municipality,
      'barangay': barangay,
      'sitio': sitio,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

    factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
      role: map['role'] == 'student' ? UserRole.student : UserRole.agency,
      fullAddress: map['fullAddress'] ?? '',
      region: map['region'],
      province: map['province'],
      municipality: map['municipality'],
      barangay: map['barangay'],
      sitio: map['sitio'],
      createdAt: map['createdAt'] != null 
          ? (map['createdAt'] as Timestamp).toDate() 
          : null,
      updatedAt: map['updatedAt'] != null 
          ? (map['updatedAt'] as Timestamp).toDate() 
          : null,
    );
  }
}