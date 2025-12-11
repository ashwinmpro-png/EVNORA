import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'user.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class User extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String email;
  
  @HiveField(2)
  final String fullName;
  
  @HiveField(3)
  final String? phone;
  
  @HiveField(4)
  final String? profileImage;
  
  @HiveField(5)
  final String? designation;
  
  @HiveField(6)
  final String userType; // 'candidate' or 'employer'
  
  @HiveField(7)
  final String? candidateType; // 'blue_collar' or 'white_collar'
  
  @HiveField(8)
  final String? resumeUrl;
  
  @HiveField(9)
  final String? location;
  
  @HiveField(10)
  final double? latitude;
  
  @HiveField(11)
  final double? longitude;
  
  @HiveField(12)
  final List<String>? skills;
  
  @HiveField(13)
  final List<WorkExperience>? workExperience;
  
  @HiveField(14)
  final List<Education>? education;
  
  @HiveField(15)
  final List<String>? certificates;
  
  @HiveField(16)
  final bool isVerified;
  
  @HiveField(17)
  final bool isProfileComplete;
  
  @HiveField(18)
  final DateTime createdAt;
  
  @HiveField(19)
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.fullName,
    this.phone,
    this.profileImage,
    this.designation,
    required this.userType,
    this.candidateType,
    this.resumeUrl,
    this.location,
    this.latitude,
    this.longitude,
    this.skills,
    this.workExperience,
    this.education,
    this.certificates,
    this.isVerified = false,
    this.isProfileComplete = false,
    required this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phone,
    String? profileImage,
    String? designation,
    String? userType,
    String? candidateType,
    String? resumeUrl,
    String? location,
    double? latitude,
    double? longitude,
    List<String>? skills,
    List<WorkExperience>? workExperience,
    List<Education>? education,
    List<String>? certificates,
    bool? isVerified,
    bool? isProfileComplete,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      designation: designation ?? this.designation,
      userType: userType ?? this.userType,
      candidateType: candidateType ?? this.candidateType,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      skills: skills ?? this.skills,
      workExperience: workExperience ?? this.workExperience,
      education: education ?? this.education,
      certificates: certificates ?? this.certificates,
      isVerified: isVerified ?? this.isVerified,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        fullName,
        phone,
        profileImage,
        designation,
        userType,
        candidateType,
        resumeUrl,
        location,
        latitude,
        longitude,
        skills,
        workExperience,
        education,
        certificates,
        isVerified,
        isProfileComplete,
        createdAt,
        updatedAt,
      ];
}

@JsonSerializable()
@HiveType(typeId: 1)
class WorkExperience extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String companyName;
  
  @HiveField(2)
  final String designation;
  
  @HiveField(3)
  final String? location;
  
  @HiveField(4)
  final DateTime startDate;
  
  @HiveField(5)
  final DateTime? endDate;
  
  @HiveField(6)
  final bool isCurrentJob;
  
  @HiveField(7)
  final String? description;
  
  @HiveField(8)
  final List<String>? skills;

  const WorkExperience({
    required this.id,
    required this.companyName,
    required this.designation,
    this.location,
    required this.startDate,
    this.endDate,
    this.isCurrentJob = false,
    this.description,
    this.skills,
  });

  factory WorkExperience.fromJson(Map<String, dynamic> json) =>
      _$WorkExperienceFromJson(json);
  Map<String, dynamic> toJson() => _$WorkExperienceToJson(this);

  @override
  List<Object?> get props => [
        id,
        companyName,
        designation,
        location,
        startDate,
        endDate,
        isCurrentJob,
        description,
        skills,
      ];
}

@JsonSerializable()
@HiveType(typeId: 2)
class Education extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String institutionName;
  
  @HiveField(2)
  final String degree;
  
  @HiveField(3)
  final String? fieldOfStudy;
  
  @HiveField(4)
  final DateTime startDate;
  
  @HiveField(5)
  final DateTime? endDate;
  
  @HiveField(6)
  final bool isCurrentlyStudying;
  
  @HiveField(7)
  final String? grade;
  
  @HiveField(8)
  final String? description;

  const Education({
    required this.id,
    required this.institutionName,
    required this.degree,
    this.fieldOfStudy,
    required this.startDate,
    this.endDate,
    this.isCurrentlyStudying = false,
    this.grade,
    this.description,
  });

  factory Education.fromJson(Map<String, dynamic> json) =>
      _$EducationFromJson(json);
  Map<String, dynamic> toJson() => _$EducationToJson(this);

  @override
  List<Object?> get props => [
        id,
        institutionName,
        degree,
        fieldOfStudy,
        startDate,
        endDate,
        isCurrentlyStudying,
        grade,
        description,
      ];
}
