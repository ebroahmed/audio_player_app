import 'package:audio_player_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends ConsumerStatefulWidget {
  final VoidCallback? onSignupSuccess;

  const SignupScreen({super.key, this.onSignupSuccess});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String displayName = '';
  bool isLoading = false;
  String? errorMessage;

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await ref
          .read(authRepositoryProvider)
          .signUp(email: email, password: password, displayName: displayName);
      widget.onSignupSuccess?.call();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Account created. Please login'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Registration failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('Sign Up'),
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Center(
            child: Image(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.08),
              image: AssetImage('assets/images/track.png'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  if (errorMessage != null)
                    Text(errorMessage!, style: TextStyle(color: Colors.red)),
                  TextFormField(
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onPrimaryFixedVariant,
                      decorationThickness: 0,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Display Name',
                      labelStyle: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onPrimaryFixedVariant,
                      ),
                    ),
                    onChanged: (val) => displayName = val.trim(),
                    validator: (val) => val == null || val.isEmpty
                        ? 'Enter a display name'
                        : null,
                  ),
                  TextFormField(
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onPrimaryFixedVariant,
                      decorationThickness: 0,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onPrimaryFixedVariant,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (val) => email = val.trim(),
                    validator: (val) => val == null || !val.contains('@')
                        ? 'Enter a valid email'
                        : null,
                  ),
                  TextFormField(
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onPrimaryFixedVariant,
                      decorationThickness: 0,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onPrimaryFixedVariant,
                      ),
                    ),
                    obscureText: true,
                    onChanged: (val) => password = val.trim(),
                    validator: (val) => val == null || val.length < 6
                        ? 'Password too short'
                        : null,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: isLoading ? null : _signup,
                    child: isLoading
                        ? CircularProgressIndicator()
                        : Text('Sign Up'),
                  ),
                  SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text(
                      'Already have an account? Login',
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
