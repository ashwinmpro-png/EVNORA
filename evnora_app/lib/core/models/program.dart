import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'program.g.dart';

@JsonSerializable()
@HiveType(typeId: 6)
class Program extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final String category; // 'blue_collar', 'white_collar', 'digital_soft_skills', 'hse'
  
  @HiveField(4)
  final String? subcategory;
  
  @HiveField(5)
  final String? imageUrl;
  
  @HiveField(6)
  final List<String>? images;
  
  @HiveField(7)
  final String duration;
  
  @HiveField(8)
  final String durationUnit; // 'weeks', 'months', 'hours'
  
  @HiveField(9)
  final String deliveryMode; // 'online', 'offline', 'hybrid'
  
  @HiveField(10)
  final double price;
  
  @HiveField(11)
  final double? discountedPrice;
  
  @HiveField(12)
  final String currency;
  
  @HiveField(13)
  final bool isFree;
  
  @HiveField(14)
  final bool isPaid;
  
  @HiveField(15)
  final List<String>? features;
  
  @HiveField(16)
  final List<ProgramModule>? modules;
  
  @HiveField(17)
  final List<String>? prerequisites;
  
  @HiveField(18)
  final List<String>? learningOutcomes;
  
  @HiveField(19)
  final List<String>? targetAudience;
  
  @HiveField(20)
  final String? certificationDetails;
  
  @HiveField(21)
  final bool hasCertification;
  
  @HiveField(22)
  final String? instructorName;
  
  @HiveField(23)
  final String? instructorBio;
  
  @HiveField(24)
  final String? instructorImage;
  
  @HiveField(25)
  final double rating;
  
  @HiveField(26)
  final int reviewsCount;
  
  @HiveField(27)
  final int enrollmentsCount;
  
  @HiveField(28)
  final DateTime? startDate;
  
  @HiveField(29)
  final DateTime? endDate;
  
  @HiveField(30)
  final bool isActive;
  
  @HiveField(31)
  final bool isFeatured;
  
  @HiveField(32)
  final DateTime createdAt;

  const Program({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.subcategory,
    this.imageUrl,
    this.images,
    required this.duration,
    required this.durationUnit,
    required this.deliveryMode,
    required this.price,
    this.discountedPrice,
    required this.currency,
    this.isFree = false,
    this.isPaid = true,
    this.features,
    this.modules,
    this.prerequisites,
    this.learningOutcomes,
    this.targetAudience,
    this.certificationDetails,
    this.hasCertification = true,
    this.instructorName,
    this.instructorBio,
    this.instructorImage,
    this.rating = 0.0,
    this.reviewsCount = 0,
    this.enrollmentsCount = 0,
    this.startDate,
    this.endDate,
    this.isActive = true,
    this.isFeatured = false,
    required this.createdAt,
  });

  factory Program.fromJson(Map<String, dynamic> json) => _$ProgramFromJson(json);
  Map<String, dynamic> toJson() => _$ProgramToJson(this);

  String get formattedDuration => '$duration $durationUnit';

  String get formattedPrice {
    if (isFree) return 'Free';
    final actualPrice = discountedPrice ?? price;
    return '$currency ${actualPrice.toStringAsFixed(0)}';
  }

  bool get hasDiscount => discountedPrice != null && discountedPrice! < price;

  double get discountPercentage {
    if (!hasDiscount) return 0;
    return ((price - discountedPrice!) / price * 100).roundToDouble();
  }

  String get categoryLabel {
    switch (category) {
      case 'blue_collar':
        return 'Blue Collar';
      case 'white_collar':
        return 'White Collar';
      case 'digital_soft_skills':
        return 'Digital + Soft Skills';
      case 'hse':
        return 'HSE';
      default:
        return category;
    }
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        category,
        subcategory,
        imageUrl,
        images,
        duration,
        durationUnit,
        deliveryMode,
        price,
        discountedPrice,
        currency,
        isFree,
        isPaid,
        features,
        modules,
        prerequisites,
        learningOutcomes,
        targetAudience,
        certificationDetails,
        hasCertification,
        instructorName,
        instructorBio,
        instructorImage,
        rating,
        reviewsCount,
        enrollmentsCount,
        startDate,
        endDate,
        isActive,
        isFeatured,
        createdAt,
      ];
}

@JsonSerializable()
@HiveType(typeId: 7)
class ProgramModule extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String? description;
  
  @HiveField(3)
  final int order;
  
  @HiveField(4)
  final String? duration;
  
  @HiveField(5)
  final List<ModuleLesson>? lessons;

  const ProgramModule({
    required this.id,
    required this.title,
    this.description,
    required this.order,
    this.duration,
    this.lessons,
  });

  factory ProgramModule.fromJson(Map<String, dynamic> json) =>
      _$ProgramModuleFromJson(json);
  Map<String, dynamic> toJson() => _$ProgramModuleToJson(this);

  @override
  List<Object?> get props => [id, title, description, order, duration, lessons];
}

@JsonSerializable()
@HiveType(typeId: 8)
class ModuleLesson extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String? description;
  
  @HiveField(3)
  final int order;
  
  @HiveField(4)
  final String? duration;
  
  @HiveField(5)
  final String? contentType; // 'video', 'document', 'quiz', 'assignment'
  
  @HiveField(6)
  final String? contentUrl;

  const ModuleLesson({
    required this.id,
    required this.title,
    this.description,
    required this.order,
    this.duration,
    this.contentType,
    this.contentUrl,
  });

  factory ModuleLesson.fromJson(Map<String, dynamic> json) =>
      _$ModuleLessonFromJson(json);
  Map<String, dynamic> toJson() => _$ModuleLessonToJson(this);

  @override
  List<Object?> get props => [id, title, description, order, duration, contentType, contentUrl];
}

@JsonSerializable()
@HiveType(typeId: 9)
class ProgramEnrollment extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String programId;
  
  @HiveField(2)
  final String userId;
  
  @HiveField(3)
  final String status; // 'pending', 'active', 'completed', 'cancelled'
  
  @HiveField(4)
  final DateTime enrolledDate;
  
  @HiveField(5)
  final DateTime? completedDate;
  
  @HiveField(6)
  final double progress;
  
  @HiveField(7)
  final String? paymentId;
  
  @HiveField(8)
  final double? amountPaid;
  
  @HiveField(9)
  final String? certificateId;
  
  @HiveField(10)
  final String? certificateUrl;

  const ProgramEnrollment({
    required this.id,
    required this.programId,
    required this.userId,
    required this.status,
    required this.enrolledDate,
    this.completedDate,
    this.progress = 0.0,
    this.paymentId,
    this.amountPaid,
    this.certificateId,
    this.certificateUrl,
  });

  factory ProgramEnrollment.fromJson(Map<String, dynamic> json) =>
      _$ProgramEnrollmentFromJson(json);
  Map<String, dynamic> toJson() => _$ProgramEnrollmentToJson(this);

  @override
  List<Object?> get props => [
        id,
        programId,
        userId,
        status,
        enrolledDate,
        completedDate,
        progress,
        paymentId,
        amountPaid,
        certificateId,
        certificateUrl,
      ];
}

class ProgramFilter {
  final String? searchQuery;
  final String? category;
  final String? deliveryMode;
  final double? priceMin;
  final double? priceMax;
  final bool? hasCertification;
  final double? minRating;
  final String? sortBy;
  final bool? sortAscending;

  const ProgramFilter({
    this.searchQuery,
    this.category,
    this.deliveryMode,
    this.priceMin,
    this.priceMax,
    this.hasCertification,
    this.minRating,
    this.sortBy,
    this.sortAscending,
  });

  ProgramFilter copyWith({
    String? searchQuery,
    String? category,
    String? deliveryMode,
    double? priceMin,
    double? priceMax,
    bool? hasCertification,
    double? minRating,
    String? sortBy,
    bool? sortAscending,
  }) {
    return ProgramFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      category: category ?? this.category,
      deliveryMode: deliveryMode ?? this.deliveryMode,
      priceMin: priceMin ?? this.priceMin,
      priceMax: priceMax ?? this.priceMax,
      hasCertification: hasCertification ?? this.hasCertification,
      minRating: minRating ?? this.minRating,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
    );
  }

  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{};
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      params['q'] = searchQuery;
    }
    if (category != null) params['category'] = category;
    if (deliveryMode != null) params['delivery_mode'] = deliveryMode;
    if (priceMin != null) params['price_min'] = priceMin;
    if (priceMax != null) params['price_max'] = priceMax;
    if (hasCertification != null) params['has_certification'] = hasCertification;
    if (minRating != null) params['min_rating'] = minRating;
    if (sortBy != null) params['sort_by'] = sortBy;
    if (sortAscending != null) params['sort_asc'] = sortAscending;
    return params;
  }
}
