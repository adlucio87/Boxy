import 'package:flutter/material.dart';
import '../../data/models/box_model.dart';
import '../../data/repositories/inventory_repository.dart';

class MyBoxesScreen extends StatefulWidget {
  final String userId;

  const MyBoxesScreen({super.key, required this.userId});

  @override
  State<MyBoxesScreen> createState() => _MyBoxesScreenState();
}

class _MyBoxesScreenState extends State<MyBoxesScreen> {
  final InventoryRepository _repository = InventoryRepository();
  List<BoxModel> _allBoxes = [];
  List<BoxModel> _filteredBoxes = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadBoxes();
  }

  Future<void> _loadBoxes() async {
    try {
      final boxes = await _repository.getUserBoxes(widget.userId);
      setState(() {
        _allBoxes = boxes;
        _filteredBoxes = boxes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading boxes: $e')),
        );
      }
    }
  }

  void _filterBoxes(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredBoxes = _allBoxes;
      } else {
        final lower = query.toLowerCase();
        _filteredBoxes = _allBoxes.where((box) {
          final matchName = box.name.toLowerCase().contains(lower);
          final matchLocation = box.location.toLowerCase().contains(lower);
          final matchItems = box.items.any((item) => item.name.toLowerCase().contains(lower));
          return matchName || matchLocation || matchItems;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Inventory'),
        actions: [
           IconButton(
             icon: const Icon(Icons.add),
             onPressed: () {
               // Navigate to Box Creation Screen
             },
           )
        ],
      ),
      body: Column(
        children: [
          // Local Search Bar for "My Boxes"
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search my boxes...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterBoxes,
            ),
          ),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredBoxes.isEmpty
                    ? Center(
                        child: Text(_searchQuery.isEmpty
                            ? 'You have no boxes yet.'
                            : 'No matching boxes found.'),
                      )
                    : ListView.builder(
                        itemCount: _filteredBoxes.length,
                        itemBuilder: (context, index) {
                          final box = _filteredBoxes[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: ListTile(
                              title: Text(box.name),
                              subtitle: Text(
                                  '${box.location} • ${box.items.length} items • ${box.isPublic ? "Public" : "Private"}'),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                // Navigate to Box Details
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
