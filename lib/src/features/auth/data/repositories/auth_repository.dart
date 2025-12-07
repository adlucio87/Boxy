import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User canceled

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      throw Exception('Google Sign-In failed: $e');
    }
  }

  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      final UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      throw Exception('Email Sign-In failed: $e');
    }
  }

  Future<User?> registerWithEmailPassword(String email, String password) async {
    try {
      final UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  // Helper to convert Firebase User to app's UserModel (incomplete implementation, mostly for ID)
  // In a real app, you'd fetch the full profile from Firestore.
  UserModel? mapFirebaseUser(User? user) {
    if (user == null) return null;
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? 'User',
      photoUrl: user.photoURL,
      city: 'Unknown', // Placeholder, would fetch from DB
      createdAt: user.metadata.creationTime ?? DateTime.now(),
    );
  }
}
