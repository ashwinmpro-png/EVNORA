// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JobAdapter extends TypeAdapter<Job> {
  @override
  final int typeId = 3;

  @override
  Job read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Job(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      company: fields[3] as Company,
      location: fields[4] as String,
      country: fields[5] as String,
      jobType: fields[6] as String,
      employmentType: fields[7] as String,
      salaryMin: fields[8] as String?,
      salaryMax: fields[9] as String?,
      salaryCurrency: fields[10] as String?,
      salaryPeriod: fields[11] as String?,
      experienceMin: fields[12] as String,
      experienceMax: fields[13] as String,
      skills: (fields[14] as List).cast<String>(),
      requirements: (fields[15] as List?)?.cast<String>(),
      responsibilities: (fields[16] as List?)?.cast<String>(),
      benefits: (fields[17] as List?)?.cast<String>(),
      qualifications: fields[18] as String?,
      vacancies: fields[19] as int,
      postedDate: fields[20] as DateTime,
      applicationDeadline: fields[21] as DateTime?,
      isActive: fields[22] as bool,
      isFeatured: fields[23] as bool,
      applicationsCount: fields[24] as int,
      externalUrl: fields[25] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Job obj) {
    writer
      ..writeByte(26)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.company)
      ..writeByte(4)
      ..write(obj.location)
      ..writeByte(5)
      ..write(obj.country)
      ..writeByte(6)
      ..write(obj.jobType)
      ..writeByte(7)
      ..write(obj.employmentType)
      ..writeByte(8)
      ..write(obj.salaryMin)
      ..writeByte(9)
      ..write(obj.salaryMax)
      ..writeByte(10)
      ..write(obj.salaryCurrency)
      ..writeByte(11)
      ..write(obj.salaryPeriod)
      ..writeByte(12)
      ..write(obj.experienceMin)
      ..writeByte(13)
      ..write(obj.experienceMax)
      ..writeByte(14)
      ..write(obj.skills)
      ..writeByte(15)
      ..write(obj.requirements)
      ..writeByte(16)
      ..write(obj.responsibilities)
      ..writeByte(17)
      ..write(obj.benefits)
      ..writeByte(18)
      ..write(obj.qualifications)
      ..writeByte(19)
      ..write(obj.vacancies)
      ..writeByte(20)
      ..write(obj.postedDate)
      ..writeByte(21)
      ..write(obj.applicationDeadline)
      ..writeByte(22)
      ..write(obj.isActive)
      ..writeByte(23)
      ..write(obj.isFeatured)
      ..writeByte(24)
      ..write(obj.applicationsCount)
      ..writeByte(25)
      ..write(obj.externalUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CompanyAdapter extends TypeAdapter<Company> {
  @override
  final int typeId = 4;

  @override
  Company read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Company(
      id: fields[0] as String,
      name: fields[1] as String,
      logo: fields[2] as String?,
      description: fields[3] as String?,
      website: fields[4] as String?,
      industry: fields[5] as String?,
      companySize: fields[6] as String?,
      headquarters: fields[7] as String?,
      foundedYear: fields[8] as int?,
      isVerified: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Company obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.logo)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.website)
      ..writeByte(5)
      ..write(obj.industry)
      ..writeByte(6)
      ..write(obj.companySize)
      ..writeByte(7)
      ..write(obj.headquarters)
      ..writeByte(8)
      ..write(obj.foundedYear)
      ..writeByte(9)
      ..write(obj.isVerified);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompanyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class JobApplicationAdapter extends TypeAdapter<JobApplication> {
  @override
  final int typeId = 5;

  @override
  JobApplication read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JobApplication(
      id: fields[0] as String,
      jobId: fields[1] as String,
      userId: fields[2] as String,
      status: fields[3] as String,
      appliedDate: fields[4] as DateTime,
      coverLetter: fields[5] as String?,
      resumeUrl: fields[6] as String?,
      notes: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, JobApplication obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.jobId)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.appliedDate)
      ..writeByte(5)
      ..write(obj.coverLetter)
      ..writeByte(6)
      ..write(obj.resumeUrl)
      ..writeByte(7)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobApplicationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Job _$JobFromJson(Map<String, dynamic> json) => Job(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      company: Company.fromJson(json['company'] as Map<String, dynamic>),
      location: json['location'] as String,
      country: json['country'] as String,
      jobType: json['jobType'] as String,
      employmentType: json['employmentType'] as String,
      salaryMin: json['salaryMin'] as String?,
      salaryMax: json['salaryMax'] as String?,
      salaryCurrency: json['salaryCurrency'] as String?,
      salaryPeriod: json['salaryPeriod'] as String?,
      experienceMin: json['experienceMin'] as String,
      experienceMax: json['experienceMax'] as String,
      skills:
          (json['skills'] as List<dynamic>).map((e) => e as String).toList(),
      requirements: (json['requirements'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      responsibilities: (json['responsibilities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      benefits: (json['benefits'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      qualifications: json['qualifications'] as String?,
      vacancies: (json['vacancies'] as num).toInt(),
      postedDate: DateTime.parse(json['postedDate'] as String),
      applicationDeadline: json['applicationDeadline'] == null
          ? null
          : DateTime.parse(json['applicationDeadline'] as String),
      isActive: json['isActive'] as bool? ?? true,
      isFeatured: json['isFeatured'] as bool? ?? false,
      applicationsCount: (json['applicationsCount'] as num?)?.toInt() ?? 0,
      externalUrl: json['externalUrl'] as String?,
    );

Map<String, dynamic> _$JobToJson(Job instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'company': instance.company,
      'location': instance.location,
      'country': instance.country,
      'jobType': instance.jobType,
      'employmentType': instance.employmentType,
      'salaryMin': instance.salaryMin,
      'salaryMax': instance.salaryMax,
      'salaryCurrency': instance.salaryCurrency,
      'salaryPeriod': instance.salaryPeriod,
      'experienceMin': instance.experienceMin,
      'experienceMax': instance.experienceMax,
      'skills': instance.skills,
      'requirements': instance.requirements,
      'responsibilities': instance.responsibilities,
      'benefits': instance.benefits,
      'qualifications': instance.qualifications,
      'vacancies': instance.vacancies,
      'postedDate': instance.postedDate.toIso8601String(),
      'applicationDeadline': instance.applicationDeadline?.toIso8601String(),
      'isActive': instance.isActive,
      'isFeatured': instance.isFeatured,
      'applicationsCount': instance.applicationsCount,
      'externalUrl': instance.externalUrl,
    };

Company _$CompanyFromJson(Map<String, dynamic> json) => Company(
      id: json['id'] as String,
      name: json['name'] as String,
      logo: json['logo'] as String?,
      description: json['description'] as String?,
      website: json['website'] as String?,
      industry: json['industry'] as String?,
      companySize: json['companySize'] as String?,
      headquarters: json['headquarters'] as String?,
      foundedYear: (json['foundedYear'] as num?)?.toInt(),
      isVerified: json['isVerified'] as bool? ?? false,
    );

Map<String, dynamic> _$CompanyToJson(Company instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'logo': instance.logo,
      'description': instance.description,
      'website': instance.website,
      'industry': instance.industry,
      'companySize': instance.companySize,
      'headquarters': instance.headquarters,
      'foundedYear': instance.foundedYear,
      'isVerified': instance.isVerified,
    };

JobApplication _$JobApplicationFromJson(Map<String, dynamic> json) =>
    JobApplication(
      id: json['id'] as String,
      jobId: json['jobId'] as String,
      userId: json['userId'] as String,
      status: json['status'] as String,
      appliedDate: DateTime.parse(json['appliedDate'] as String),
      coverLetter: json['coverLetter'] as String?,
      resumeUrl: json['resumeUrl'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$JobApplicationToJson(JobApplication instance) =>
    <String, dynamic>{
      'id': instance.id,
      'jobId': instance.jobId,
      'userId': instance.userId,
      'status': instance.status,
      'appliedDate': instance.appliedDate.toIso8601String(),
      'coverLetter': instance.coverLetter,
      'resumeUrl': instance.resumeUrl,
      'notes': instance.notes,
    };
