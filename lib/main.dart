import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final Map<String, String> _users = <String, String>{};
  String? _loggedInEmail;

  String? _signUp(String email, String password) {
    if (_users.containsKey(email)) {
      return 'User already exists. Please login.';
    }

    _users[email] = password;
    _loggedInEmail = email;
    setState(() {});
    return null;
  }

  String? _login(String email, String password) {
    if (!_users.containsKey(email)) {
      return 'User not found. Please sign up first.';
    }

    if (_users[email] != password) {
      return 'Invalid password.';
    }

    _loggedInEmail = email;
    setState(() {});
    return null;
  }

  void _logout() {
    _loggedInEmail = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_loggedInEmail != null) {
      return HomeScreen(
        email: _loggedInEmail!,
        onLogout: _logout,
      );
    }

    return AuthScreen(
      onLogin: _login,
      onSignUp: _signUp,
    );
  }
}

typedef AuthHandler = String? Function(String email, String password);

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    required this.onLogin,
    required this.onSignUp,
    super.key,
  });

  final AuthHandler onLogin;
  final AuthHandler onSignUp;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLogin = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    final FormState? state = _formKey.currentState;
    if (state == null || !state.validate()) {
      return;
    }

    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    final String? error = _isLogin
        ? widget.onLogin(email, password)
        : widget.onSignUp(email, password);

    setState(() {
      _errorMessage = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String title = _isLogin ? 'Login' : 'Sign Up';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    key: const Key('emailField'),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    key: const Key('passwordField'),
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  if (!_isLogin) ...<Widget>[
                    const SizedBox(height: 12),
                    TextFormField(
                      key: const Key('confirmPasswordField'),
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration:
                          const InputDecoration(labelText: 'Confirm Password'),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ],
                  const SizedBox(height: 16),
                  ElevatedButton(
                    key: const Key('submitButton'),
                    onPressed: _submit,
                    child: Text(title),
                  ),
                  TextButton(
                    key: const Key('toggleAuthModeButton'),
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                        _errorMessage = null;
                        _passwordController.clear();
                        _confirmPasswordController.clear();
                      });
                    },
                    child: Text(
                      _isLogin
                          ? 'Need an account? Sign up'
                          : 'Already have an account? Login',
                    ),
                  ),
                  if (_errorMessage != null) ...<Widget>[
                    const SizedBox(height: 8),
                    Text(
                      _errorMessage!,
                      key: const Key('authError'),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.email,
    required this.onLogout,
    super.key,
  });

  final String email;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: <Widget>[
          IconButton(
            onPressed: onLogout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Welcome, $email',
          key: const Key('welcomeText'),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}