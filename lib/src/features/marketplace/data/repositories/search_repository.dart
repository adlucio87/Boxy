import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../features/inventory/data/models/box_model.dart';

class SearchRepository {
  final FirebaseFirestore _firestore;

  SearchRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Fetches public boxes and filters them based on the [query].
  ///
  /// Note: In a production environment with thousands of records,
  /// this should be replaced by a dedicated search service like Algolia or ElasticSearch,
  /// or a more specific Firestore structure (e.g. array-contains 'keywords').
  Future<List<BoxModel>> searchPublicBoxes(String query) async {
    try {
      // 1. Fetch all public boxes (Limit to recent 100 for prototype safety)
      final QuerySnapshot snapshot = await _firestore
          .collection('boxes')
          .where('isPublic', isEqualTo: true)
          .limit(100)
          .get();

      final List<BoxModel> allPublicBoxes = snapshot.docs
          .map((doc) => BoxModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      if (query.isEmpty) {
        return allPublicBoxes;
      }

      final lowercaseQuery = query.toLowerCase();

      // 2. Filter client-side
      final filteredBoxes = allPublicBoxes.where((box) {
        // Check Box details
        final matchBoxName = box.name.toLowerCase().contains(lowercaseQuery);
        final matchDescription = box.description?.toLowerCase().contains(lowercaseQuery) ?? false;

        // Check Items details
        final matchItems = box.items.any((item) {
          final matchItemName = item.name.toLowerCase().contains(lowercaseQuery);
          final matchTags = item.aiTags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
          return matchItemName || matchTags;
        });

        return matchBoxName || matchDescription || matchItems;
      }).toList();

      return filteredBoxes;
    } catch (e) {
      throw Exception('Search failed: $e');
    }
  }
}
