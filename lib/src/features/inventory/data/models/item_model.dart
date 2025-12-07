import 'package:equatable/equatable.dart';

class ItemModel extends Equatable {
  final String id;
  final String name;
  final String? description;
  final List<String> imageUrls;
  final List<String> aiTags; // Labels from Google ML Kit
  final double? estimatedValue;
  final DateTime createdAt;

  const ItemModel({
    required this.id,
    required this.name,
    this.description,
    required this.imageUrls,
    required this.aiTags,
    this.estimatedValue,
    required this.createdAt,
  });

  /// Creates a copy of this ItemModel but with the given fields replaced with the new values.
  ItemModel copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? imageUrls,
    List<String>? aiTags,
    double? estimatedValue,
    DateTime? createdAt,
  }) {
    return ItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls,
      aiTags: aiTags ?? this.aiTags,
      estimatedValue: estimatedValue ?? this.estimatedValue,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Converts the [ItemModel] to a Map for Firestore.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrls': imageUrls,
      'aiTags': aiTags,
      'estimatedValue': estimatedValue,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  /// Creates an [ItemModel] from a Map (e.g. from Firestore).
  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'] ?? '',
      name: map['name'] ?? 'Unknown Item',
      description: map['description'],
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      aiTags: List<String>.from(map['aiTags'] ?? []),
      estimatedValue: map['estimatedValue']?.toDouble(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
    );
  }

  @override
  List<Object?> get props => [id, name, description, imageUrls, aiTags, estimatedValue, createdAt];
}
