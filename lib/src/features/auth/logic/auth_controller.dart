import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository _repository;

  AuthController({AuthRepository? repository})
      : _repository = repository ?? AuthRepository();

  User? _firebaseUser;
  User? get firebaseUser => _firebaseUser;

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Initialize auth state listener
  void init() {
    _repository.authStateChanges.listen((User? user) {
      _firebaseUser = user;
      _currentUser = _repository.mapFirebaseUser(user);
      notifyListeners();
    });
  }

  Future<void> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.signInWithGoogle();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.signInWithEmailPassword(email, password);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> registerWithEmail(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.registerWithEmailPassword(email, password);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
  }
}
