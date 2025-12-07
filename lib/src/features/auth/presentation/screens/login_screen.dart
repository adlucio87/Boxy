import 'package:flutter/material.dart';
import '../../logic/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // In a real app, use Provider/GetIt
  late final AuthController _authController;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isRegistering = false;

  @override
  void initState() {
    super.initState();
    _authController = AuthController();
    _authController.init();
    _authController.addListener(_onAuthChanged);
  }

  @override
  void dispose() {
    _authController.removeListener(_onAuthChanged);
    _authController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onAuthChanged() {
    setState(() {});
    // Navigation logic would go here (e.g., if user != null, go to Home)
    if (_authController.firebaseUser != null) {
      // For this demo, just show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Logged In Successfully!")),
      );
    }
  }

  Future<void> _submitEmail() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) return;

    if (_isRegistering) {
      await _authController.registerWithEmail(email, password);
    } else {
      await _authController.signInWithEmail(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isRegistering ? 'Register' : 'Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'SmartBox & Trade',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 32),
              if (_authController.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    _authController.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              if (_authController.isLoading)
                const CircularProgressIndicator()
              else
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: _submitEmail,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Text(_isRegistering ? 'Register' : 'Login'),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: _authController.signInWithGoogle,
                      icon: const Icon(Icons.login), // Replace with Google Icon in real app
                      label: const Text('Sign in with Google'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isRegistering = !_isRegistering;
                        });
                      },
                      child: Text(_isRegistering
                          ? 'Already have an account? Login'
                          : 'Need an account? Register'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
