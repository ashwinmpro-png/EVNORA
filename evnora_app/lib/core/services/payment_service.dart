import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../config/constants.dart';
import 'api_service.dart';

final paymentServiceProvider = Provider<PaymentService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return PaymentService(apiService);
});

class PaymentService {
  final ApiService _apiService;
  late Razorpay _razorpay;
  
  Function(PaymentSuccessResponse)? _onSuccess;
  Function(PaymentFailureResponse)? _onFailure;
  Function(ExternalWalletResponse)? _onWallet;

  PaymentService(this._apiService) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _onSuccess?.call(response);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _onFailure?.call(response);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _onWallet?.call(response);
  }

  /// Create an order on the backend and get order ID
  Future<PaymentOrder?> createOrder({
    required double amount,
    required String currency,
    required String description,
    required PaymentType type,
    String? programId,
  }) async {
    try {
      final response = await _apiService.post(
        AppConstants.paymentEndpoint,
        data: {
          'amount': (amount * 100).round(), // Razorpay expects amount in paise
          'currency': currency,
          'description': description,
          'type': type.value,
          if (programId != null) 'program_id': programId,
        },
      );

      if (response.statusCode == 200) {
        return PaymentOrder.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Error creating order: $e');
      return null;
    }
  }

  /// Open Razorpay checkout
  void openCheckout({
    required PaymentOrder order,
    required String userName,
    required String userEmail,
    required String userPhone,
    required Function(PaymentSuccessResponse) onSuccess,
    required Function(PaymentFailureResponse) onFailure,
    Function(ExternalWalletResponse)? onWallet,
  }) {
    _onSuccess = onSuccess;
    _onFailure = onFailure;
    _onWallet = onWallet;

    final options = {
      'key': AppConstants.razorpayKey,
      'amount': order.amount,
      'currency': order.currency,
      'order_id': order.orderId,
      'name': AppConstants.appName,
      'description': order.description,
      'prefill': {
        'name': userName,
        'email': userEmail,
        'contact': userPhone,
      },
      'theme': {
        'color': '#1E3A5F',
      },
      'modal': {
        'confirm_close': true,
      },
      'send_sms_hash': true,
      'retry': {
        'enabled': true,
        'max_count': 3,
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print('Error opening Razorpay: $e');
      onFailure(PaymentFailureResponse(
        Razorpay.UNKNOWN_ERROR,
        'Failed to open payment gateway',
        null,
      ));
    }
  }

  /// Verify payment on backend
  Future<PaymentVerification?> verifyPayment({
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    try {
      final response = await _apiService.post(
        '${AppConstants.paymentEndpoint}/verify',
        data: {
          'razorpay_order_id': orderId,
          'razorpay_payment_id': paymentId,
          'razorpay_signature': signature,
        },
      );

      if (response.statusCode == 200) {
        return PaymentVerification.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Error verifying payment: $e');
      return null;
    }
  }

  /// Get payment history
  Future<List<PaymentHistory>> getPaymentHistory() async {
    try {
      final response = await _apiService.get('${AppConstants.paymentEndpoint}/history');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['payments'];
        return data.map((p) => PaymentHistory.fromJson(p)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching payment history: $e');
      return [];
    }
  }

  /// Dispose Razorpay instance
  void dispose() {
    _razorpay.clear();
  }
}

// Payment Types
enum PaymentType {
  programEnrollment,
  certification,
  subscription,
}

extension PaymentTypeExtension on PaymentType {
  String get value {
    switch (this) {
      case PaymentType.programEnrollment:
        return 'program_enrollment';
      case PaymentType.certification:
        return 'certification';
      case PaymentType.subscription:
        return 'subscription';
    }
  }
}

// Payment Order Model
class PaymentOrder {
  final String orderId;
  final int amount;
  final String currency;
  final String description;
  final String status;
  final DateTime createdAt;

  PaymentOrder({
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  factory PaymentOrder.fromJson(Map<String, dynamic> json) {
    return PaymentOrder(
      orderId: json['order_id'],
      amount: json['amount'],
      currency: json['currency'],
      description: json['description'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  double get amountInRupees => amount / 100;
}

// Payment Verification Model
class PaymentVerification {
  final bool isValid;
  final String paymentId;
  final String orderId;
  final String? message;

  PaymentVerification({
    required this.isValid,
    required this.paymentId,
    required this.orderId,
    this.message,
  });

  factory PaymentVerification.fromJson(Map<String, dynamic> json) {
    return PaymentVerification(
      isValid: json['is_valid'],
      paymentId: json['payment_id'],
      orderId: json['order_id'],
      message: json['message'],
    );
  }
}

// Payment History Model
class PaymentHistory {
  final String id;
  final String orderId;
  final String paymentId;
  final double amount;
  final String currency;
  final String type;
  final String status;
  final String? description;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  PaymentHistory({
    required this.id,
    required this.orderId,
    required this.paymentId,
    required this.amount,
    required this.currency,
    required this.type,
    required this.status,
    this.description,
    required this.createdAt,
    this.metadata,
  });

  factory PaymentHistory.fromJson(Map<String, dynamic> json) {
    return PaymentHistory(
      id: json['id'],
      orderId: json['order_id'],
      paymentId: json['payment_id'],
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'],
      type: json['type'],
      status: json['status'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      metadata: json['metadata'],
    );
  }

  String get formattedAmount => '$currency ${amount.toStringAsFixed(2)}';
  
  bool get isSuccess => status == 'captured' || status == 'completed';
  bool get isPending => status == 'pending' || status == 'created';
  bool get isFailed => status == 'failed' || status == 'refunded';
}

// Payment Widget Helper
class PaymentWidgets {
  static void showPaymentBottomSheet(
    BuildContext context, {
    required String title,
    required double amount,
    required String currency,
    required VoidCallback onPay,
    String? description,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            
            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            if (description != null) ...[
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
            
            const SizedBox(height: 24),
            
            // Amount
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Amount',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '$currency ${amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A5F),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Pay Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onPay();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A5F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Pay Now',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Security note
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline, size: 16, color: Colors.grey[500]),
                const SizedBox(width: 8),
                Text(
                  'Secured by Razorpay',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  static void showPaymentSuccess(
    BuildContext context, {
    required String paymentId,
    required double amount,
    required String currency,
    VoidCallback? onDone,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFF10B981),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Payment Successful!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$currency ${amount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A5F),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Payment ID: $paymentId',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onDone?.call();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A5F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void showPaymentFailure(
    BuildContext context, {
    required String message,
    VoidCallback? onRetry,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFEF4444),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Payment Failed',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onRetry?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A5F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Retry'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
