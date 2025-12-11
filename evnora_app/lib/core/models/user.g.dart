// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as String,
      email: fields[1] as String,
      fullName: fields[2] as String,
      phone: fields[3] as String?,
      profileImage: fields[4] as String?,
      designation: fields[5] as String?,
      userType: fields[6] as String,
      candidateType: fields[7] as String?,
      resumeUrl: fields[8] as String?,
      location: fields[9] as String?,
      latitude: fields[10] as double?,
      longitude: fields[11] as double?,
      skills: (fields[12] as List?)?.cast<String>(),
      workExperience: (fields[13] as List?)?.cast<WorkExperience>(),
      education: (fields[14] as List?)?.cast<Education>(),
      certificates: (fields[15] as List?)?.cast<String>(),
      isVerified: fields[16] as bool,
      isProfileComplete: fields[17] as bool,
      createdAt: fields[18] as DateTime,
      updatedAt: fields[19] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.fullName)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.profileImage)
      ..writeByte(5)
      ..write(obj.designation)
      ..writeByte(6)
      ..write(obj.userType)
      ..writeByte(7)
      ..write(obj.candidateType)
      ..writeByte(8)
      ..write(obj.resumeUrl)
      ..writeByte(9)
      ..write(obj.location)
      ..writeByte(10)
      ..write(obj.latitude)
      ..writeByte(11)
      ..write(obj.longitude)
      ..writeByte(12)
      ..write(obj.skills)
      ..writeByte(13)
      ..write(obj.workExperience)
      ..writeByte(14)
      ..write(obj.education)
      ..writeByte(15)
      ..write(obj.certificates)
      ..writeByte(16)
      ..write(obj.isVerified)
      ..writeByte(17)
      ..write(obj.isProfileComplete)
      ..writeByte(18)
      ..write(obj.createdAt)
      ..writeByte(19)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WorkExperienceAdapter extends TypeAdapter<WorkExperience> {
  @override
  final int typeId = 1;

  @override
  WorkExperience read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkExperience(
      id: fields[0] as String,
      companyName: fields[1] as String,
      designation: fields[2] as String,
      location: fields[3] as String?,
      startDate: fields[4] as DateTime,
      endDate: fields[5] as DateTime?,
      isCurrentJob: fields[6] as bool,
      description: fields[7] as String?,
      skills: (fields[8] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, WorkExperience obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.companyName)
      ..writeByte(2)
      ..write(obj.designation)
      ..writeByte(3)
      ..write(obj.location)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.endDate)
      ..writeByte(6)
      ..write(obj.isCurrentJob)
      ..writeByte(7)
      ..write(obj.description)
      ..writeByte(8)
      ..write(obj.skills);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkExperienceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EducationAdapter extends TypeAdapter<Education> {
  @override
  final int typeId = 2;

  @override
  Education read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Education(
      id: fields[0] as String,
      institutionName: fields[1] as String,
      degree: fields[2] as String,
      fieldOfStudy: fields[3] as String?,
      startDate: fields[4] as DateTime,
      endDate: fields[5] as DateTime?,
      isCurrentlyStudying: fields[6] as bool,
      grade: fields[7] as String?,
      description: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Education obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.institutionName)
      ..writeByte(2)
      ..write(obj.degree)
      ..writeByte(3)
      ..write(obj.fieldOfStudy)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.endDate)
      ..writeByte(6)
      ..write(obj.isCurrentlyStudying)
      ..writeByte(7)
      ..write(obj.grade)
      ..writeByte(8)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EducationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      phone: json['phone'] as String?,
      profileImage: json['profileImage'] as String?,
      designation: json['designation'] as String?,
      userType: json['userType'] as String,
      candidateType: json['candidateType'] as String?,
      resumeUrl: json['resumeUrl'] as String?,
      location: json['location'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      skills:
          (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList(),
      workExperience: (json['workExperience'] as List<dynamic>?)
          ?.map((e) => WorkExperience.fromJson(e as Map<String, dynamic>))
          .toList(),
      education: (json['education'] as List<dynamic>?)
          ?.map((e) => Education.fromJson(e as Map<String, dynamic>))
          .toList(),
      certificates: (json['certificates'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isVerified: json['isVerified'] as bool? ?? false,
      isProfileComplete: json['isProfileComplete'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'fullName': instance.fullName,
      'phone': instance.phone,
      'profileImage': instance.profileImage,
      'designation': instance.designation,
      'userType': instance.userType,
      'candidateType': instance.candidateType,
      'resumeUrl': instance.resumeUrl,
      'location': instance.location,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'skills': instance.skills,
      'workExperience': instance.workExperience,
      'education': instance.education,
      'certificates': instance.certificates,
      'isVerified': instance.isVerified,
      'isProfileComplete': instance.isProfileComplete,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

WorkExperience _$WorkExperienceFromJson(Map<String, dynamic> json) =>
    WorkExperience(
      id: json['id'] as String,
      companyName: json['companyName'] as String,
      designation: json['designation'] as String,
      location: json['location'] as String?,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      isCurrentJob: json['isCurrentJob'] as bool? ?? false,
      description: json['description'] as String?,
      skills:
          (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$WorkExperienceToJson(WorkExperience instance) =>
    <String, dynamic>{
      'id': instance.id,
      'companyName': instance.companyName,
      'designation': instance.designation,
      'location': instance.location,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'isCurrentJob': instance.isCurrentJob,
      'description': instance.description,
      'skills': instance.skills,
    };

Education _$EducationFromJson(Map<String, dynamic> json) => Education(
      id: json['id'] as String,
      institutionName: json['institutionName'] as String,
      degree: json['degree'] as String,
      fieldOfStudy: json['fieldOfStudy'] as String?,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      isCurrentlyStudying: json['isCurrentlyStudying'] as bool? ?? false,
      grade: json['grade'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$EducationToJson(Education instance) => <String, dynamic>{
      'id': instance.id,
      'institutionName': instance.institutionName,
      'degree': instance.degree,
      'fieldOfStudy': instance.fieldOfStudy,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'isCurrentlyStudying': instance.isCurrentlyStudying,
      'grade': instance.grade,
      'description': instance.description,
    };
