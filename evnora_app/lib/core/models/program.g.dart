// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProgramAdapter extends TypeAdapter<Program> {
  @override
  final int typeId = 6;

  @override
  Program read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Program(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      category: fields[3] as String,
      subcategory: fields[4] as String?,
      imageUrl: fields[5] as String?,
      images: (fields[6] as List?)?.cast<String>(),
      duration: fields[7] as String,
      durationUnit: fields[8] as String,
      deliveryMode: fields[9] as String,
      price: fields[10] as double,
      discountedPrice: fields[11] as double?,
      currency: fields[12] as String,
      isFree: fields[13] as bool,
      isPaid: fields[14] as bool,
      features: (fields[15] as List?)?.cast<String>(),
      modules: (fields[16] as List?)?.cast<ProgramModule>(),
      prerequisites: (fields[17] as List?)?.cast<String>(),
      learningOutcomes: (fields[18] as List?)?.cast<String>(),
      targetAudience: (fields[19] as List?)?.cast<String>(),
      certificationDetails: fields[20] as String?,
      hasCertification: fields[21] as bool,
      instructorName: fields[22] as String?,
      instructorBio: fields[23] as String?,
      instructorImage: fields[24] as String?,
      rating: fields[25] as double,
      reviewsCount: fields[26] as int,
      enrollmentsCount: fields[27] as int,
      startDate: fields[28] as DateTime?,
      endDate: fields[29] as DateTime?,
      isActive: fields[30] as bool,
      isFeatured: fields[31] as bool,
      createdAt: fields[32] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Program obj) {
    writer
      ..writeByte(33)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.subcategory)
      ..writeByte(5)
      ..write(obj.imageUrl)
      ..writeByte(6)
      ..write(obj.images)
      ..writeByte(7)
      ..write(obj.duration)
      ..writeByte(8)
      ..write(obj.durationUnit)
      ..writeByte(9)
      ..write(obj.deliveryMode)
      ..writeByte(10)
      ..write(obj.price)
      ..writeByte(11)
      ..write(obj.discountedPrice)
      ..writeByte(12)
      ..write(obj.currency)
      ..writeByte(13)
      ..write(obj.isFree)
      ..writeByte(14)
      ..write(obj.isPaid)
      ..writeByte(15)
      ..write(obj.features)
      ..writeByte(16)
      ..write(obj.modules)
      ..writeByte(17)
      ..write(obj.prerequisites)
      ..writeByte(18)
      ..write(obj.learningOutcomes)
      ..writeByte(19)
      ..write(obj.targetAudience)
      ..writeByte(20)
      ..write(obj.certificationDetails)
      ..writeByte(21)
      ..write(obj.hasCertification)
      ..writeByte(22)
      ..write(obj.instructorName)
      ..writeByte(23)
      ..write(obj.instructorBio)
      ..writeByte(24)
      ..write(obj.instructorImage)
      ..writeByte(25)
      ..write(obj.rating)
      ..writeByte(26)
      ..write(obj.reviewsCount)
      ..writeByte(27)
      ..write(obj.enrollmentsCount)
      ..writeByte(28)
      ..write(obj.startDate)
      ..writeByte(29)
      ..write(obj.endDate)
      ..writeByte(30)
      ..write(obj.isActive)
      ..writeByte(31)
      ..write(obj.isFeatured)
      ..writeByte(32)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgramAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProgramModuleAdapter extends TypeAdapter<ProgramModule> {
  @override
  final int typeId = 7;

  @override
  ProgramModule read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProgramModule(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String?,
      order: fields[3] as int,
      duration: fields[4] as String?,
      lessons: (fields[5] as List?)?.cast<ModuleLesson>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProgramModule obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.order)
      ..writeByte(4)
      ..write(obj.duration)
      ..writeByte(5)
      ..write(obj.lessons);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgramModuleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ModuleLessonAdapter extends TypeAdapter<ModuleLesson> {
  @override
  final int typeId = 8;

  @override
  ModuleLesson read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModuleLesson(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String?,
      order: fields[3] as int,
      duration: fields[4] as String?,
      contentType: fields[5] as String?,
      contentUrl: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ModuleLesson obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.order)
      ..writeByte(4)
      ..write(obj.duration)
      ..writeByte(5)
      ..write(obj.contentType)
      ..writeByte(6)
      ..write(obj.contentUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModuleLessonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProgramEnrollmentAdapter extends TypeAdapter<ProgramEnrollment> {
  @override
  final int typeId = 9;

  @override
  ProgramEnrollment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProgramEnrollment(
      id: fields[0] as String,
      programId: fields[1] as String,
      userId: fields[2] as String,
      status: fields[3] as String,
      enrolledDate: fields[4] as DateTime,
      completedDate: fields[5] as DateTime?,
      progress: fields[6] as double,
      paymentId: fields[7] as String?,
      amountPaid: fields[8] as double?,
      certificateId: fields[9] as String?,
      certificateUrl: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProgramEnrollment obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.programId)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.enrolledDate)
      ..writeByte(5)
      ..write(obj.completedDate)
      ..writeByte(6)
      ..write(obj.progress)
      ..writeByte(7)
      ..write(obj.paymentId)
      ..writeByte(8)
      ..write(obj.amountPaid)
      ..writeByte(9)
      ..write(obj.certificateId)
      ..writeByte(10)
      ..write(obj.certificateUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgramEnrollmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Program _$ProgramFromJson(Map<String, dynamic> json) => Program(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      subcategory: json['subcategory'] as String?,
      imageUrl: json['imageUrl'] as String?,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      duration: json['duration'] as String,
      durationUnit: json['durationUnit'] as String,
      deliveryMode: json['deliveryMode'] as String,
      price: (json['price'] as num).toDouble(),
      discountedPrice: (json['discountedPrice'] as num?)?.toDouble(),
      currency: json['currency'] as String,
      isFree: json['isFree'] as bool? ?? false,
      isPaid: json['isPaid'] as bool? ?? true,
      features: (json['features'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      modules: (json['modules'] as List<dynamic>?)
          ?.map((e) => ProgramModule.fromJson(e as Map<String, dynamic>))
          .toList(),
      prerequisites: (json['prerequisites'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      learningOutcomes: (json['learningOutcomes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      targetAudience: (json['targetAudience'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      certificationDetails: json['certificationDetails'] as String?,
      hasCertification: json['hasCertification'] as bool? ?? true,
      instructorName: json['instructorName'] as String?,
      instructorBio: json['instructorBio'] as String?,
      instructorImage: json['instructorImage'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: (json['reviewsCount'] as num?)?.toInt() ?? 0,
      enrollmentsCount: (json['enrollmentsCount'] as num?)?.toInt() ?? 0,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      isActive: json['isActive'] as bool? ?? true,
      isFeatured: json['isFeatured'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ProgramToJson(Program instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'subcategory': instance.subcategory,
      'imageUrl': instance.imageUrl,
      'images': instance.images,
      'duration': instance.duration,
      'durationUnit': instance.durationUnit,
      'deliveryMode': instance.deliveryMode,
      'price': instance.price,
      'discountedPrice': instance.discountedPrice,
      'currency': instance.currency,
      'isFree': instance.isFree,
      'isPaid': instance.isPaid,
      'features': instance.features,
      'modules': instance.modules,
      'prerequisites': instance.prerequisites,
      'learningOutcomes': instance.learningOutcomes,
      'targetAudience': instance.targetAudience,
      'certificationDetails': instance.certificationDetails,
      'hasCertification': instance.hasCertification,
      'instructorName': instance.instructorName,
      'instructorBio': instance.instructorBio,
      'instructorImage': instance.instructorImage,
      'rating': instance.rating,
      'reviewsCount': instance.reviewsCount,
      'enrollmentsCount': instance.enrollmentsCount,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'isActive': instance.isActive,
      'isFeatured': instance.isFeatured,
      'createdAt': instance.createdAt.toIso8601String(),
    };

ProgramModule _$ProgramModuleFromJson(Map<String, dynamic> json) =>
    ProgramModule(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      order: (json['order'] as num).toInt(),
      duration: json['duration'] as String?,
      lessons: (json['lessons'] as List<dynamic>?)
          ?.map((e) => ModuleLesson.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProgramModuleToJson(ProgramModule instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'order': instance.order,
      'duration': instance.duration,
      'lessons': instance.lessons,
    };

ModuleLesson _$ModuleLessonFromJson(Map<String, dynamic> json) => ModuleLesson(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      order: (json['order'] as num).toInt(),
      duration: json['duration'] as String?,
      contentType: json['contentType'] as String?,
      contentUrl: json['contentUrl'] as String?,
    );

Map<String, dynamic> _$ModuleLessonToJson(ModuleLesson instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'order': instance.order,
      'duration': instance.duration,
      'contentType': instance.contentType,
      'contentUrl': instance.contentUrl,
    };

ProgramEnrollment _$ProgramEnrollmentFromJson(Map<String, dynamic> json) =>
    ProgramEnrollment(
      id: json['id'] as String,
      programId: json['programId'] as String,
      userId: json['userId'] as String,
      status: json['status'] as String,
      enrolledDate: DateTime.parse(json['enrolledDate'] as String),
      completedDate: json['completedDate'] == null
          ? null
          : DateTime.parse(json['completedDate'] as String),
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      paymentId: json['paymentId'] as String?,
      amountPaid: (json['amountPaid'] as num?)?.toDouble(),
      certificateId: json['certificateId'] as String?,
      certificateUrl: json['certificateUrl'] as String?,
    );

Map<String, dynamic> _$ProgramEnrollmentToJson(ProgramEnrollment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'programId': instance.programId,
      'userId': instance.userId,
      'status': instance.status,
      'enrolledDate': instance.enrolledDate.toIso8601String(),
      'completedDate': instance.completedDate?.toIso8601String(),
      'progress': instance.progress,
      'paymentId': instance.paymentId,
      'amountPaid': instance.amountPaid,
      'certificateId': instance.certificateId,
      'certificateUrl': instance.certificateUrl,
    };
