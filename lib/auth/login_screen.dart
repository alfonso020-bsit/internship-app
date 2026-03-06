import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/components/global_text_field.dart';
import 'package:app/components/global_password_field.dart';
import 'package:app/components/global_button.dart';
import 'package:app/components/global_card.dart';
import 'package:app/utils/app_theme.dart';
// import 'package:app/models/user_model.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      
      if (mounted) {
        // Check user role from Firestore
        String uid = userCredential.user!.uid;
        
        // Check if agency
        DocumentSnapshot agencyDoc = await _firestore.collection('agencies').doc(uid).get();
        if (agencyDoc.exists) {
          // Navigate to Agency Dashboard
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Agency login successful!'), backgroundColor: AppTheme.success),
          );
          // TODO: Navigate to Agency Dashboard
        } else {
          // Check if student
          DocumentSnapshot studentDoc = await _firestore.collection('students').doc(uid).get();
          if (studentDoc.exists) {
            // Navigate to Student Dashboard
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Student login successful!'), backgroundColor: AppTheme.success),
            );
            // TODO: Navigate to Student Dashboard
          } else {
            // User exists in Auth but not in Firestore (shouldn't happen)
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('User data not found'), backgroundColor:AppTheme.error),
            );
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Login failed';
      if (e.code == 'user-not-found') {
        message = 'No user found with this email';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password';
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        title: const Text('InternTrack - Login'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: AppTheme.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: GlobalCard(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Welcome Back!',
                    style: AppTheme.heading1,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Sign in to continue',
                    style: TextStyle(fontSize: 16, color: AppTheme.darkGrey),
                  ),
                  const SizedBox(height: 30),
                  GlobalTextField(
                    controller: _emailController,
                    label: 'Email',
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  GlobalPasswordField(
                    controller: _passwordController,
                    label: 'Password',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  GlobalButton(
                    text: 'Sign In',
                    onPressed: _signIn,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterScreen()),
                      );
                    },
                    child: const Text('Don\'t have an account? Sign Up'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}