// Enum for Sale Types (Modalità di Vendita)
enum SaleType {
  /// BlindBox: Buyer sees only origin room, estimated weight, and city.
  blindBox,

  /// PeepHole: Buyer sees 2-3 "bait" items, others hidden.
  peepHole,

  /// OpenBox: All content is visible.
  openBox,

  /// SingleItem: Selling a single item extracted from a box.
  singleItem,
}

// Enum for Offer Status (Stato dell'offerta)
enum OfferStatus {
  /// The offer has been made but not yet responded to.
  pending,

  /// The seller has accepted the offer. Chat/Email unlocked.
  accepted,

  /// The seller has rejected the offer.
  rejected,

  /// The transaction is completed.
  completed,
}

// Helper extension to easily convert to/from String for Firestore
extension SaleTypeExtension on SaleType {
  String toStringValue() => toString().split('.').last;

  static SaleType fromStringValue(String value) {
    return SaleType.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => SaleType.openBox, // Default fallback
    );
  }
}

extension OfferStatusExtension on OfferStatus {
  String toStringValue() => toString().split('.').last;

  static OfferStatus fromStringValue(String value) {
    return OfferStatus.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => OfferStatus.pending, // Default fallback
    );
  }
}
