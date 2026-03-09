import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/components/global_text_field.dart';
import 'package:app/components/global_password_field.dart';
import 'package:app/components/global_button.dart';
import 'package:app/components/global_card.dart';
import 'package:app/utils/app_theme.dart';
import 'package:app/services/auth_service.dart';
import 'register_screen.dart';
import 'package:app/screens/agency_screens/agency_navigation/agency_navigation.dart';
import 'package:app/screens/intern_screens/intern_navigation/intern_navigation.dart';

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
  final _authService = AuthService();
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
          // Get agency data
          Map<String, dynamic> agencyData = agencyDoc.data() as Map<String, dynamic>;
          
          // Save agency user data to AuthService
          Map<String, dynamic> userData = {
            'uid': uid,
            'email': userCredential.user!.email,
            'role': 'agency',
            'name': agencyData['agencyName'] ?? 'Agency User',
            'agencyName': agencyData['agencyName'],
            'contactPerson': agencyData['contactPerson'],
            'contactNumber': agencyData['contactNumber'],
            'fullAddress': agencyData['fullAddress'],
            'region': agencyData['region'],
            'province': agencyData['province'],
            'municipality': agencyData['municipality'],
            'barangay': agencyData['barangay'],
            'latitude': agencyData['latitude'],
            'longitude': agencyData['longitude'],
            'mapUrl': agencyData['mapUrl'],
            'isVerified': agencyData['isVerified'] ?? false,
          };
          
          await _authService.setUser(userData);
          await _authService.setUserRole('agency');
          await _authService.setToken(userCredential.user!.uid);
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Agency login successful!'), 
              backgroundColor: AppTheme.success,
            ),
          );
          
          // Navigate to Agency Dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AgencyNavigation(
                currentRoute: '/agency/dashboard',
              ),
            ),
          );
        } else {
          // Check if student
          DocumentSnapshot studentDoc = await _firestore.collection('students').doc(uid).get();
          if (studentDoc.exists) {
            // Get student data - MATCHING YOUR STUDENT MODEL FIELDS
            Map<String, dynamic> studentData = studentDoc.data() as Map<String, dynamic>;
            
            // Build full name from components
            String firstName = studentData['firstName'] ?? '';
            String lastName = studentData['lastName'] ?? '';
            String middleInitial = studentData['middleInitial'] ?? '';
            String fullName = '$firstName $middleInitial $lastName'.replaceAll('  ', ' ').trim();
            
            // Save student user data to AuthService
            Map<String, dynamic> userData = {
              'uid': uid,
              'email': userCredential.user!.email,
              'role': 'student',
              'name': fullName,
              'firstName': studentData['firstName'],
              'lastName': studentData['lastName'],
              'middleInitial': studentData['middleInitial'],
              'fullAddress': studentData['fullAddress'],
              'region': studentData['region'],
              'province': studentData['province'],
              'municipality': studentData['municipality'],
              'barangay': studentData['barangay'],
              'school': studentData['school'],
              'course': studentData['course'],
              'yearLevel': studentData['yearLevel'],
              'contactNumber': studentData['contactNumber'],
              'skills': studentData['skills'] ?? [],
              'applicationHistory': studentData['applicationHistory'] ?? [],
              'totalHours': studentData['totalHours'] ?? 0,
              'completedHours': studentData['completedHours'] ?? 0,
            };
            
            await _authService.setUser(userData);
            await _authService.setUserRole('student');
            await _authService.setToken(userCredential.user!.uid);
            
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Student login successful!'), 
                backgroundColor: AppTheme.success,
              ),
            );
            
            // Navigate to Intern Dashboard
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const InternNavigation(
                  currentRoute: '/intern/dashboard',
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('User data not found'), 
                backgroundColor: AppTheme.error,
              ),
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
          SnackBar(
            content: Text(message), 
            backgroundColor: AppTheme.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: $e'), 
            backgroundColor: AppTheme.error,
          ),
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
                  const SizedBox(height: 16),
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