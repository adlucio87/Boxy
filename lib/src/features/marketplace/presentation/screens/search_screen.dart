import 'package:flutter/material.dart';
import '../../../../features/inventory/data/models/box_model.dart';
import '../../logic/search_controller.dart' as logic; // Alias to avoid conflict with Flutter's SearchController if needed

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final logic.SearchController _controller;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = logic.SearchController();
    _controller.addListener(_onControllerUpdate);
    // Load initial data (empty query)
    _controller.search('');
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _onControllerUpdate() {
    setState(() {});
  }

  void _onSearchChanged(String value) {
    // In a real app, add debounce here (e.g. 500ms) to avoid spamming the "repo"
    _controller.search(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace Search'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'Search boxes, items, or tags...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _onSearchChanged,
            ),
          ),

          // Results
          Expanded(
            child: _controller.isLoading
                ? const Center(child: CircularProgressIndicator())
                : _controller.results.isEmpty
                    ? const Center(child: Text('No results found.'))
                    : ListView.builder(
                        itemCount: _controller.results.length,
                        itemBuilder: (context, index) {
                          final box = _controller.results[index];
                          return _BoxResultTile(box: box, query: _textController.text);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _BoxResultTile extends StatelessWidget {
  final BoxModel box;
  final String query;

  const _BoxResultTile({required this.box, required this.query});

  @override
  Widget build(BuildContext context) {
    // Determine why it matched to show a snippet
    String matchSnippet = '';
    final lowerQuery = query.toLowerCase();

    if (query.isNotEmpty) {
      // Check items
      final matchedItems = box.items.where((item) {
        return item.name.toLowerCase().contains(lowerQuery) ||
               item.aiTags.any((tag) => tag.toLowerCase().contains(lowerQuery));
      }).toList();

      if (matchedItems.isNotEmpty) {
        matchSnippet = 'Contains: ${matchedItems.take(2).map((e) => e.name).join(", ")}';
        if (matchedItems.length > 2) matchSnippet += '...';
      } else if (box.description != null && box.description!.toLowerCase().contains(lowerQuery)) {
        matchSnippet = box.description!;
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(box.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${box.city} • ${box.saleType.toString().split('.').last}'),
            if (matchSnippet.isNotEmpty)
              Text(
                matchSnippet,
                style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Navigate to Box Details (Not implemented in this task, but placeholder action)
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text('Open Box: ${box.name}')),
          );
        },
      ),
    );
  }
}
