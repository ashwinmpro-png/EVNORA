import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'job.g.dart';

@JsonSerializable()
@HiveType(typeId: 3)
class Job extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final Company company;
  
  @HiveField(4)
  final String location;
  
  @HiveField(5)
  final String country;
  
  @HiveField(6)
  final String jobType; // 'blue_collar', 'white_collar'
  
  @HiveField(7)
  final String employmentType; // 'full_time', 'part_time', 'contract'
  
  @HiveField(8)
  final String? salaryMin;
  
  @HiveField(9)
  final String? salaryMax;
  
  @HiveField(10)
  final String? salaryCurrency;
  
  @HiveField(11)
  final String? salaryPeriod; // 'monthly', 'yearly', 'hourly'
  
  @HiveField(12)
  final String experienceMin;
  
  @HiveField(13)
  final String experienceMax;
  
  @HiveField(14)
  final List<String> skills;
  
  @HiveField(15)
  final List<String>? requirements;
  
  @HiveField(16)
  final List<String>? responsibilities;
  
  @HiveField(17)
  final List<String>? benefits;
  
  @HiveField(18)
  final String? qualifications;
  
  @HiveField(19)
  final int vacancies;
  
  @HiveField(20)
  final DateTime postedDate;
  
  @HiveField(21)
  final DateTime? applicationDeadline;
  
  @HiveField(22)
  final bool isActive;
  
  @HiveField(23)
  final bool isFeatured;
  
  @HiveField(24)
  final int applicationsCount;
  
  @HiveField(25)
  final String? externalUrl;

  const Job({
    required this.id,
    required this.title,
    required this.description,
    required this.company,
    required this.location,
    required this.country,
    required this.jobType,
    required this.employmentType,
    this.salaryMin,
    this.salaryMax,
    this.salaryCurrency,
    this.salaryPeriod,
    required this.experienceMin,
    required this.experienceMax,
    required this.skills,
    this.requirements,
    this.responsibilities,
    this.benefits,
    this.qualifications,
    required this.vacancies,
    required this.postedDate,
    this.applicationDeadline,
    this.isActive = true,
    this.isFeatured = false,
    this.applicationsCount = 0,
    this.externalUrl,
  });

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);
  Map<String, dynamic> toJson() => _$JobToJson(this);

  String get salaryRange {
    if (salaryMin == null && salaryMax == null) return 'Not Disclosed';
    if (salaryMin != null && salaryMax != null) {
      return '${salaryCurrency ?? ''} $salaryMin - $salaryMax ${salaryPeriod ?? ''}';
    }
    return '${salaryCurrency ?? ''} ${salaryMin ?? salaryMax} ${salaryPeriod ?? ''}';
  }

  String get experienceRange => '$experienceMin-$experienceMax Yrs';

  bool get isExpired {
    if (applicationDeadline == null) return false;
    return DateTime.now().isAfter(applicationDeadline!);
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        company,
        location,
        country,
        jobType,
        employmentType,
        salaryMin,
        salaryMax,
        salaryCurrency,
        salaryPeriod,
        experienceMin,
        experienceMax,
        skills,
        requirements,
        responsibilities,
        benefits,
        qualifications,
        vacancies,
        postedDate,
        applicationDeadline,
        isActive,
        isFeatured,
        applicationsCount,
        externalUrl,
      ];
}

@JsonSerializable()
@HiveType(typeId: 4)
class Company extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String? logo;
  
  @HiveField(3)
  final String? description;
  
  @HiveField(4)
  final String? website;
  
  @HiveField(5)
  final String? industry;
  
  @HiveField(6)
  final String? companySize;
  
  @HiveField(7)
  final String? headquarters;
  
  @HiveField(8)
  final int? foundedYear;
  
  @HiveField(9)
  final bool isVerified;

  const Company({
    required this.id,
    required this.name,
    this.logo,
    this.description,
    this.website,
    this.industry,
    this.companySize,
    this.headquarters,
    this.foundedYear,
    this.isVerified = false,
  });

  factory Company.fromJson(Map<String, dynamic> json) => _$CompanyFromJson(json);
  Map<String, dynamic> toJson() => _$CompanyToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        logo,
        description,
        website,
        industry,
        companySize,
        headquarters,
        foundedYear,
        isVerified,
      ];
}

@JsonSerializable()
@HiveType(typeId: 5)
class JobApplication extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String jobId;
  
  @HiveField(2)
  final String userId;
  
  @HiveField(3)
  final String status; // 'pending', 'reviewed', 'shortlisted', 'rejected', 'hired'
  
  @HiveField(4)
  final DateTime appliedDate;
  
  @HiveField(5)
  final String? coverLetter;
  
  @HiveField(6)
  final String? resumeUrl;
  
  @HiveField(7)
  final String? notes;

  const JobApplication({
    required this.id,
    required this.jobId,
    required this.userId,
    required this.status,
    required this.appliedDate,
    this.coverLetter,
    this.resumeUrl,
    this.notes,
  });

  factory JobApplication.fromJson(Map<String, dynamic> json) =>
      _$JobApplicationFromJson(json);
  Map<String, dynamic> toJson() => _$JobApplicationToJson(this);

  @override
  List<Object?> get props => [
        id,
        jobId,
        userId,
        status,
        appliedDate,
        coverLetter,
        resumeUrl,
        notes,
      ];
}

class JobFilter {
  final String? searchQuery;
  final String? jobType;
  final String? employmentType;
  final String? country;
  final String? location;
  final String? company;
  final String? experienceMin;
  final String? experienceMax;
  final String? salaryMin;
  final String? salaryMax;
  final List<String>? skills;
  final String? sortBy;
  final bool? sortAscending;

  const JobFilter({
    this.searchQuery,
    this.jobType,
    this.employmentType,
    this.country,
    this.location,
    this.company,
    this.experienceMin,
    this.experienceMax,
    this.salaryMin,
    this.salaryMax,
    this.skills,
    this.sortBy,
    this.sortAscending,
  });

  JobFilter copyWith({
    String? searchQuery,
    String? jobType,
    String? employmentType,
    String? country,
    String? location,
    String? company,
    String? experienceMin,
    String? experienceMax,
    String? salaryMin,
    String? salaryMax,
    List<String>? skills,
    String? sortBy,
    bool? sortAscending,
  }) {
    return JobFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      jobType: jobType ?? this.jobType,
      employmentType: employmentType ?? this.employmentType,
      country: country ?? this.country,
      location: location ?? this.location,
      company: company ?? this.company,
      experienceMin: experienceMin ?? this.experienceMin,
      experienceMax: experienceMax ?? this.experienceMax,
      salaryMin: salaryMin ?? this.salaryMin,
      salaryMax: salaryMax ?? this.salaryMax,
      skills: skills ?? this.skills,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
    );
  }

  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{};
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      params['q'] = searchQuery;
    }
    if (jobType != null) params['job_type'] = jobType;
    if (employmentType != null) params['employment_type'] = employmentType;
    if (country != null) params['country'] = country;
    if (location != null) params['location'] = location;
    if (company != null) params['company'] = company;
    if (experienceMin != null) params['exp_min'] = experienceMin;
    if (experienceMax != null) params['exp_max'] = experienceMax;
    if (salaryMin != null) params['salary_min'] = salaryMin;
    if (salaryMax != null) params['salary_max'] = salaryMax;
    if (skills != null && skills!.isNotEmpty) params['skills'] = skills!.join(',');
    if (sortBy != null) params['sort_by'] = sortBy;
    if (sortAscending != null) params['sort_asc'] = sortAscending;
    return params;
  }
}
