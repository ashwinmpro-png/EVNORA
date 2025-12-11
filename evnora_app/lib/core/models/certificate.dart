import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'certificate.g.dart';

@JsonSerializable()
@HiveType(typeId: 10)
class Certificate extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String certificateNumber;
  
  @HiveField(2)
  final String title;
  
  @HiveField(3)
  final String holderName;
  
  @HiveField(4)
  final String? holderId;
  
  @HiveField(5)
  final String programId;
  
  @HiveField(6)
  final String programTitle;
  
  @HiveField(7)
  final String? category;
  
  @HiveField(8)
  final DateTime issueDate;
  
  @HiveField(9)
  final DateTime? expiryDate;
  
  @HiveField(10)
  final bool hasExpiry;
  
  @HiveField(11)
  final String? issuingAuthority;
  
  @HiveField(12)
  final String? issuerLogo;
  
  @HiveField(13)
  final String? certificateUrl;
  
  @HiveField(14)
  final String? qrCodeUrl;
  
  @HiveField(15)
  final String status; // 'valid', 'expired', 'revoked'
  
  @HiveField(16)
  final String? grade;
  
  @HiveField(17)
  final double? score;
  
  @HiveField(18)
  final List<String>? skills;
  
  @HiveField(19)
  final String? verificationUrl;
  
  @HiveField(20)
  final Map<String, dynamic>? metadata;

  const Certificate({
    required this.id,
    required this.certificateNumber,
    required this.title,
    required this.holderName,
    this.holderId,
    required this.programId,
    required this.programTitle,
    this.category,
    required this.issueDate,
    this.expiryDate,
    this.hasExpiry = false,
    this.issuingAuthority,
    this.issuerLogo,
    this.certificateUrl,
    this.qrCodeUrl,
    required this.status,
    this.grade,
    this.score,
    this.skills,
    this.verificationUrl,
    this.metadata,
  });

  factory Certificate.fromJson(Map<String, dynamic> json) =>
      _$CertificateFromJson(json);
  Map<String, dynamic> toJson() => _$CertificateToJson(this);

  bool get isValid => status == 'valid';
  
  bool get isExpired {
    if (!hasExpiry || expiryDate == null) return false;
    return DateTime.now().isAfter(expiryDate!);
  }

  int? get daysUntilExpiry {
    if (!hasExpiry || expiryDate == null) return null;
    return expiryDate!.difference(DateTime.now()).inDays;
  }

  String get statusLabel {
    switch (status) {
      case 'valid':
        return 'Valid';
      case 'expired':
        return 'Expired';
      case 'revoked':
        return 'Revoked';
      default:
        return status;
    }
  }

  @override
  List<Object?> get props => [
        id,
        certificateNumber,
        title,
        holderName,
        holderId,
        programId,
        programTitle,
        category,
        issueDate,
        expiryDate,
        hasExpiry,
        issuingAuthority,
        issuerLogo,
        certificateUrl,
        qrCodeUrl,
        status,
        grade,
        score,
        skills,
        verificationUrl,
        metadata,
      ];
}

@JsonSerializable()
class CertificateVerification extends Equatable {
  final String certificateNumber;
  final bool isValid;
  final Certificate? certificate;
  final String? message;
  final DateTime verifiedAt;

  const CertificateVerification({
    required this.certificateNumber,
    required this.isValid,
    this.certificate,
    this.message,
    required this.verifiedAt,
  });

  factory CertificateVerification.fromJson(Map<String, dynamic> json) =>
      _$CertificateVerificationFromJson(json);
  Map<String, dynamic> toJson() => _$CertificateVerificationToJson(this);

  @override
  List<Object?> get props => [
        certificateNumber,
        isValid,
        certificate,
        message,
        verifiedAt,
      ];
}
