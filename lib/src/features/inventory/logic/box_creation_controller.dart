import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/enums/enums.dart';
import '../data/models/box_model.dart';
import '../data/models/item_model.dart';
import '../data/repositories/inventory_repository.dart';
import 'image_labeling_service.dart';

class BoxCreationController extends ChangeNotifier {
  final ImageLabelingService _labelingService;
  final InventoryRepository _repository;
  final Uuid _uuid;

  BoxCreationController({
    ImageLabelingService? labelingService,
    InventoryRepository? repository,
  })  : _labelingService = labelingService ?? ImageLabelingService(),
        _repository = repository ?? InventoryRepository(),
        _uuid = const Uuid();

  // State
  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  final List<ItemModel> _items = [];
  List<ItemModel> get items => List.unmodifiable(_items);

  BoxModel? _createdBox;
  BoxModel? get createdBox => _createdBox;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Processes an image, extracts tags, and creates a temporary ItemModel.
  Future<void> addItemFromImage(String imagePath) async {
    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final tags = await _labelingService.getLabels(imagePath);

      // Auto-name based on the first tag, or "Unknown Item" if no tags
      final name = tags.isNotEmpty ? tags.first : 'Unknown Item';

      final newItem = ItemModel(
        id: _uuid.v4(),
        name: name,
        imageUrls: [imagePath], // Currently local path, in real app upload to Storage first
        aiTags: tags,
        createdAt: DateTime.now(),
      );

      _items.add(newItem);
    } catch (e) {
      _errorMessage = "Failed to process image: $e";
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  /// Removes an item from the list before creating the box.
  void removeItem(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }

  /// Finalizes the box creation and saves to Firestore.
  Future<void> createBox({
    required String ownerId,
    required String name,
    required String location,
    required String city,
    String? description,
    bool isPublic = false,
    SaleType saleType = SaleType.blindBox,
  }) async {
    if (_items.isEmpty) {
      _errorMessage = "Cannot create an empty box. Add at least one item.";
      notifyListeners();
      return;
    }

    _isProcessing = true;
    notifyListeners();

    try {
      final newBox = BoxModel(
        id: _uuid.v4(),
        ownerId: ownerId,
        name: name,
        location: location,
        city: city,
        description: description,
        items: List.from(_items),
        isPublic: isPublic,
        saleType: saleType,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _repository.createBox(newBox);
      _createdBox = newBox;

      // Clear items after successful creation
      _items.clear();

    } catch (e) {
      _errorMessage = "Failed to save box: $e";
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _labelingService.dispose();
    super.dispose();
  }
}
