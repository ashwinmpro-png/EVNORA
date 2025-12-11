// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certificate.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CertificateAdapter extends TypeAdapter<Certificate> {
  @override
  final int typeId = 10;

  @override
  Certificate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Certificate(
      id: fields[0] as String,
      certificateNumber: fields[1] as String,
      title: fields[2] as String,
      holderName: fields[3] as String,
      holderId: fields[4] as String?,
      programId: fields[5] as String,
      programTitle: fields[6] as String,
      category: fields[7] as String?,
      issueDate: fields[8] as DateTime,
      expiryDate: fields[9] as DateTime?,
      hasExpiry: fields[10] as bool,
      issuingAuthority: fields[11] as String?,
      issuerLogo: fields[12] as String?,
      certificateUrl: fields[13] as String?,
      qrCodeUrl: fields[14] as String?,
      status: fields[15] as String,
      grade: fields[16] as String?,
      score: fields[17] as double?,
      skills: (fields[18] as List?)?.cast<String>(),
      verificationUrl: fields[19] as String?,
      metadata: (fields[20] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Certificate obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.certificateNumber)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.holderName)
      ..writeByte(4)
      ..write(obj.holderId)
      ..writeByte(5)
      ..write(obj.programId)
      ..writeByte(6)
      ..write(obj.programTitle)
      ..writeByte(7)
      ..write(obj.category)
      ..writeByte(8)
      ..write(obj.issueDate)
      ..writeByte(9)
      ..write(obj.expiryDate)
      ..writeByte(10)
      ..write(obj.hasExpiry)
      ..writeByte(11)
      ..write(obj.issuingAuthority)
      ..writeByte(12)
      ..write(obj.issuerLogo)
      ..writeByte(13)
      ..write(obj.certificateUrl)
      ..writeByte(14)
      ..write(obj.qrCodeUrl)
      ..writeByte(15)
      ..write(obj.status)
      ..writeByte(16)
      ..write(obj.grade)
      ..writeByte(17)
      ..write(obj.score)
      ..writeByte(18)
      ..write(obj.skills)
      ..writeByte(19)
      ..write(obj.verificationUrl)
      ..writeByte(20)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CertificateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Certificate _$CertificateFromJson(Map<String, dynamic> json) => Certificate(
      id: json['id'] as String,
      certificateNumber: json['certificateNumber'] as String,
      title: json['title'] as String,
      holderName: json['holderName'] as String,
      holderId: json['holderId'] as String?,
      programId: json['programId'] as String,
      programTitle: json['programTitle'] as String,
      category: json['category'] as String?,
      issueDate: DateTime.parse(json['issueDate'] as String),
      expiryDate: json['expiryDate'] == null
          ? null
          : DateTime.parse(json['expiryDate'] as String),
      hasExpiry: json['hasExpiry'] as bool? ?? false,
      issuingAuthority: json['issuingAuthority'] as String?,
      issuerLogo: json['issuerLogo'] as String?,
      certificateUrl: json['certificateUrl'] as String?,
      qrCodeUrl: json['qrCodeUrl'] as String?,
      status: json['status'] as String,
      grade: json['grade'] as String?,
      score: (json['score'] as num?)?.toDouble(),
      skills:
          (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList(),
      verificationUrl: json['verificationUrl'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$CertificateToJson(Certificate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'certificateNumber': instance.certificateNumber,
      'title': instance.title,
      'holderName': instance.holderName,
      'holderId': instance.holderId,
      'programId': instance.programId,
      'programTitle': instance.programTitle,
      'category': instance.category,
      'issueDate': instance.issueDate.toIso8601String(),
      'expiryDate': instance.expiryDate?.toIso8601String(),
      'hasExpiry': instance.hasExpiry,
      'issuingAuthority': instance.issuingAuthority,
      'issuerLogo': instance.issuerLogo,
      'certificateUrl': instance.certificateUrl,
      'qrCodeUrl': instance.qrCodeUrl,
      'status': instance.status,
      'grade': instance.grade,
      'score': instance.score,
      'skills': instance.skills,
      'verificationUrl': instance.verificationUrl,
      'metadata': instance.metadata,
    };

CertificateVerification _$CertificateVerificationFromJson(
        Map<String, dynamic> json) =>
    CertificateVerification(
      certificateNumber: json['certificateNumber'] as String,
      isValid: json['isValid'] as bool,
      certificate: json['certificate'] == null
          ? null
          : Certificate.fromJson(json['certificate'] as Map<String, dynamic>),
      message: json['message'] as String?,
      verifiedAt: DateTime.parse(json['verifiedAt'] as String),
    );

Map<String, dynamic> _$CertificateVerificationToJson(
        CertificateVerification instance) =>
    <String, dynamic>{
      'certificateNumber': instance.certificateNumber,
      'isValid': instance.isValid,
      'certificate': instance.certificate,
      'message': instance.message,
      'verifiedAt': instance.verifiedAt.toIso8601String(),
    };
