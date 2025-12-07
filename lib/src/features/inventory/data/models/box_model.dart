import 'package:equatable/equatable.dart';
import '../../../../core/enums/enums.dart';
import 'item_model.dart';

class BoxModel extends Equatable {
  final String id;
  final String ownerId;
  final String name; // e.g., "Scatola Estate 2023"
  final String location; // Room: "Cantina", "Soffitta"
  final String city; // "Milano", "Roma" (Privacy Safe)
  final String? description;
  final List<ItemModel> items;
  final bool isPublic;
  final SaleType saleType;
  final double? estimatedWeightKg;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BoxModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.location,
    required this.city,
    this.description,
    required this.items,
    required this.isPublic,
    required this.saleType,
    this.estimatedWeightKg,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a copy of this BoxModel with updated fields.
  BoxModel copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? location,
    String? city,
    String? description,
    List<ItemModel>? items,
    bool? isPublic,
    SaleType? saleType,
    double? estimatedWeightKg,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BoxModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      location: location ?? this.location,
      city: city ?? this.city,
      description: description ?? this.description,
      items: items ?? this.items,
      isPublic: isPublic ?? this.isPublic,
      saleType: saleType ?? this.saleType,
      estimatedWeightKg: estimatedWeightKg ?? this.estimatedWeightKg,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Converts the [BoxModel] to a Map for Firestore.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'location': location,
      'city': city,
      'description': description,
      'items': items.map((x) => x.toMap()).toList(),
      'isPublic': isPublic,
      'saleType': saleType.toStringValue(),
      'estimatedWeightKg': estimatedWeightKg,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  /// Creates a [BoxModel] from a Map (e.g. from Firestore).
  factory BoxModel.fromMap(Map<String, dynamic> map) {
    return BoxModel(
      id: map['id'] ?? '',
      ownerId: map['ownerId'] ?? '',
      name: map['name'] ?? 'Unknown Box',
      location: map['location'] ?? 'Unknown Location',
      city: map['city'] ?? 'Unknown City',
      description: map['description'],
      items: List<ItemModel>.from(
        (map['items'] ?? []).map((x) => ItemModel.fromMap(x)),
      ),
      isPublic: map['isPublic'] ?? false,
      saleType: SaleTypeExtension.fromStringValue(map['saleType'] ?? ''),
      estimatedWeightKg: map['estimatedWeightKg']?.toDouble(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] ?? 0),
    );
  }

  @override
  List<Object?> get props => [
        id,
        ownerId,
        name,
        location,
        city,
        description,
        items,
        isPublic,
        saleType,
        estimatedWeightKg,
        createdAt,
        updatedAt,
      ];
}
