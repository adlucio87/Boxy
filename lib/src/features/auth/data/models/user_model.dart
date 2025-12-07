import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;
  final String city; // Important for local matching
  final DateTime createdAt;
  final double rating; // Seller rating

  const UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
    required this.city,
    required this.createdAt,
    this.rating = 0.0,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    String? city,
    DateTime? createdAt,
    double? rating,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      city: city ?? this.city,
      createdAt: createdAt ?? this.createdAt,
      rating: rating ?? this.rating,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'city': city,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'rating': rating,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? 'User',
      photoUrl: map['photoUrl'],
      city: map['city'] ?? 'Unknown',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      rating: map['rating']?.toDouble() ?? 0.0,
    );
  }

  @override
  List<Object?> get props => [id, email, displayName, photoUrl, city, createdAt, rating];
}
