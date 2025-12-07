import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/box_model.dart';

class InventoryRepository {
  final FirebaseFirestore _firestore;

  InventoryRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> createBox(BoxModel box) async {
    try {
      await _firestore.collection('boxes').doc(box.id).set(box.toMap());
    } catch (e) {
      throw Exception('Failed to create box: $e');
    }
  }

  Future<BoxModel?> getBox(String boxId) async {
    try {
      final doc = await _firestore.collection('boxes').doc(boxId).get();
      if (doc.exists && doc.data() != null) {
        return BoxModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get box: $e');
    }
  }

  /// Fetches all boxes belonging to a specific user.
  Future<List<BoxModel>> getUserBoxes(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('boxes')
          .where('ownerId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => BoxModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch user boxes: $e');
    }
  }
}
