import 'user_model.dart';

enum ApplicationStatus { pending, approved, rejected, completed }

class StudentModel extends UserModel {
  // Personal Information
  String firstName;
  String lastName;
  String? middleInitial;
  String school;
  String course;
  int yearLevel;
  
  // Contact Information
  String contactNumber;
  
  // Documents and Profile
  String? profilePhotoUrl;
  String? resumeUrl;
  List<String>? skills;
  
  // Applications and Status
  String? currentAgencyId;
  String? currentAgencyName;
  ApplicationStatus? applicationStatus;
  List<Map<String, dynamic>>? applicationHistory;
  
  // Statistics
  int totalHours;
  int completedHours;

  StudentModel({
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
    required this.firstName,
    required this.lastName,
    this.middleInitial,
    required this.school,
    required this.course,
    required this.yearLevel,
    required this.contactNumber,
    this.profilePhotoUrl,
    this.resumeUrl,
    this.skills,
    this.currentAgencyId,
    this.currentAgencyName,
    this.applicationStatus,
    this.applicationHistory,
    this.totalHours = 0,
    this.completedHours = 0,
  }) : super(role: UserRole.student);

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'firstName': firstName,
      'lastName': lastName,
      'middleInitial': middleInitial,
      'school': school,
      'course': course,
      'yearLevel': yearLevel,
      'contactNumber': contactNumber,
      'profilePhotoUrl': profilePhotoUrl,
      'resumeUrl': resumeUrl,
      'skills': skills,
      'currentAgencyId': currentAgencyId,
      'currentAgencyName': currentAgencyName,
      'applicationStatus': applicationStatus?.toString().split('.').last,
      'applicationHistory': applicationHistory,
      'totalHours': totalHours,
      'completedHours': completedHours,
    });
    return map;
  }

  factory StudentModel.fromMap(Map<String, dynamic> map, String uid) {
    final base = UserModel.fromMap(map, uid);
    return StudentModel(
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
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      middleInitial: map['middleInitial'],
      school: map['school'] ?? '',
      course: map['course'] ?? '',
      yearLevel: map['yearLevel'] ?? 1,
      contactNumber: map['contactNumber'] ?? '',
      profilePhotoUrl: map['profilePhotoUrl'],
      resumeUrl: map['resumeUrl'],
      skills: map['skills'] != null ? List<String>.from(map['skills']) : null,
      currentAgencyId: map['currentAgencyId'],
      currentAgencyName: map['currentAgencyName'],
      applicationStatus: map['applicationStatus'] != null
          ? _parseApplicationStatus(map['applicationStatus'])
          : null,
      applicationHistory: map['applicationHistory'] != null
          ? List<Map<String, dynamic>>.from(map['applicationHistory'])
          : null,
      totalHours: map['totalHours'] ?? 0,
      completedHours: map['completedHours'] ?? 0,
    );
  }

  static ApplicationStatus _parseApplicationStatus(String status) {
    switch (status) {
      case 'pending':
        return ApplicationStatus.pending;
      case 'approved':
        return ApplicationStatus.approved;
      case 'rejected':
        return ApplicationStatus.rejected;
      case 'completed':
        return ApplicationStatus.completed;
      default:
        return ApplicationStatus.pending;
    }
  }
}