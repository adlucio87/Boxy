import 'package:equatable/equatable.dart';
import '../../../../core/enums/enums.dart';

class OfferModel extends Equatable {
  final String id;
  final String boxId;
  final String buyerId;
  final String sellerId;
  final double offerAmount;
  final String currency; // Default "EUR"
  final OfferStatus status;
  final DateTime createdAt;
  final String? message; // Optional message with the bid

  const OfferModel({
    required this.id,
    required this.boxId,
    required this.buyerId,
    required this.sellerId,
    required this.offerAmount,
    this.currency = 'EUR',
    required this.status,
    required this.createdAt,
    this.message,
  });

  /// Creates a copy with updated fields.
  OfferModel copyWith({
    String? id,
    String? boxId,
    String? buyerId,
    String? sellerId,
    double? offerAmount,
    String? currency,
    OfferStatus? status,
    DateTime? createdAt,
    String? message,
  }) {
    return OfferModel(
      id: id ?? this.id,
      boxId: boxId ?? this.boxId,
      buyerId: buyerId ?? this.buyerId,
      sellerId: sellerId ?? this.sellerId,
      offerAmount: offerAmount ?? this.offerAmount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      message: message ?? this.message,
    );
  }

  /// Converts the [OfferModel] to a Map for Firestore.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'boxId': boxId,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'offerAmount': offerAmount,
      'currency': currency,
      'status': status.toStringValue(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'message': message,
    };
  }

  /// Creates an [OfferModel] from a Map.
  factory OfferModel.fromMap(Map<String, dynamic> map) {
    return OfferModel(
      id: map['id'] ?? '',
      boxId: map['boxId'] ?? '',
      buyerId: map['buyerId'] ?? '',
      sellerId: map['sellerId'] ?? '',
      offerAmount: map['offerAmount']?.toDouble() ?? 0.0,
      currency: map['currency'] ?? 'EUR',
      status: OfferStatusExtension.fromStringValue(map['status'] ?? ''),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      message: map['message'],
    );
  }

  @override
  List<Object?> get props => [
        id,
        boxId,
        buyerId,
        sellerId,
        offerAmount,
        currency,
        status,
        createdAt,
        message,
      ];
}
