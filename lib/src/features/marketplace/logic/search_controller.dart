import 'package:flutter/material.dart';
import '../../../../features/inventory/data/models/box_model.dart';
import '../data/repositories/search_repository.dart';

class SearchController extends ChangeNotifier {
  final SearchRepository _repository;

  SearchController({SearchRepository? repository})
      : _repository = repository ?? SearchRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<BoxModel> _results = [];
  List<BoxModel> get results => _results;

  String? _error;
  String? get error => _error;

  Future<void> search(String query) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _results = await _repository.searchPublicBoxes(query);
    } catch (e) {
      _error = "An error occurred while searching.";
      _results = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
