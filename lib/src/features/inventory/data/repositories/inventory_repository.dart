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
}
