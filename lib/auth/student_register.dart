import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/components/global_text_field.dart';
import 'package:app/components/global_password_field.dart';
import 'package:app/components/global_button.dart';
import 'package:app/components/global_card.dart';
import 'package:app/components/address_picker.dart';
import 'package:app/models/student_model.dart';
import 'login_screen.dart';

class StudentRegisterScreen extends StatefulWidget {
  const StudentRegisterScreen({super.key});

  @override
  State<StudentRegisterScreen> createState() => _StudentRegisterScreenState();
}

class _StudentRegisterScreenState extends State<StudentRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Personal Information
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _middleInitialController = TextEditingController();
  
  // Address from picker
  String _fullAddress = '';
  // ADD THESE VARIABLES
  String? _selectedRegion;
  String? _selectedProvince;
  String? _selectedMunicipality;
  String? _selectedBarangay;
  String? _selectedSitio;
  
  // School Information
  final _schoolController = TextEditingController();
  final _courseController = TextEditingController();
  final _yearLevelController = TextEditingController();
  
  // Contact Information
  final _contactNumberController = TextEditingController();
  
  // Account Information
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  Future<void> _registerStudent() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_fullAddress.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete your address selection'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Create user in Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Create student model with ALL address components
      StudentModel newStudent = StudentModel(
        uid: userCredential.user!.uid,
        email: _emailController.text.trim(),
        fullAddress: _fullAddress,
        // ADD THESE LINES
        region: _selectedRegion,
        province: _selectedProvince,
        municipality: _selectedMunicipality,
        barangay: _selectedBarangay,
        sitio: _selectedSitio,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        middleInitial: _middleInitialController.text.trim().isEmpty 
            ? null 
            : _middleInitialController.text.trim(),
        school: _schoolController.text.trim(),
        course: _courseController.text.trim(),
        yearLevel: int.tryParse(_yearLevelController.text.trim()) ?? 1,
        contactNumber: _contactNumberController.text.trim(),
        skills: [],
        applicationHistory: [],
        totalHours: 0,
        completedHours: 0,
      );

      // Save to Firestore
      await _firestore
          .collection('students')
          .doc(userCredential.user!.uid)
          .set(newStudent.toMap());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Student account created successfully! Please login.'),
            backgroundColor: Colors.green,
          ),
        );
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Registration failed';
      if (e.code == 'weak-password') {
        message = 'Password is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'Email already in use';
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Register Student'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: GlobalCard(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Personal Information
                const Text(
                  'Personal Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: GlobalTextField(
                        controller: _firstNameController,
                        label: 'First Name',
                        prefixIcon: Icons.person,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Required';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: GlobalTextField(
                        controller: _middleInitialController,
                        label: 'M.I.',
                        hint: 'Optional',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: GlobalTextField(
                        controller: _lastNameController,
                        label: 'Last Name',
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Required';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                
                // Address Picker Component - UPDATED
                AddressPicker(
                  onAddressSelected: (address) {
                    setState(() {
                      _fullAddress = address;
                    });
                  },
                  onComponentsSelected: ({
                    region,
                    province,
                    municipality,
                    barangay,
                    sitio,
                  }) {
                    setState(() {
                      _selectedRegion = region;
                      _selectedProvince = province;
                      _selectedMunicipality = municipality;
                      _selectedBarangay = barangay;
                      _selectedSitio = sitio;
                    });
                  },
                ),
                
                const SizedBox(height: 16),
                
                // School Information
                const Text(
                  'School Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                
                GlobalTextField(
                  controller: _schoolController,
                  label: 'School/University',
                  prefixIcon: Icons.school,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    return null;
                  },
                ),
                
                GlobalTextField(
                  controller: _courseController,
                  label: 'Course/Program',
                  prefixIcon: Icons.menu_book,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    return null;
                  },
                ),
                
                GlobalTextField(
                  controller: _yearLevelController,
                  label: 'Year Level',
                  prefixIcon: Icons.format_list_numbered,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (int.tryParse(value) == null) return 'Enter a valid number';
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Contact Information
                const Text(
                  'Contact Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                
                GlobalTextField(
                  controller: _contactNumberController,
                  label: 'Contact Number',
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    return null;
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Account Information
                const Text(
                  'Account Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                
                GlobalTextField(
                  controller: _emailController,
                  label: 'Email',
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (!value.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                
                GlobalPasswordField(
                  controller: _passwordController,
                  label: 'Password',
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (value.length < 6) return 'Must be at least 6 characters';
                    return null;
                  },
                ),
                
                GlobalPasswordField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (value != _passwordController.text) return 'Passwords do not match';
                    return null;
                  },
                ),
                
                const SizedBox(height: 24),
                
                GlobalButton(
                  text: 'Create Student Account',
                  onPressed: _registerStudent,
                  isLoading: _isLoading,
                  color: Colors.green,
                ),
                
                const SizedBox(height: 16),
                
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Back to role selection'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _middleInitialController.dispose();
    _schoolController.dispose();
    _courseController.dispose();
    _yearLevelController.dispose();
    _contactNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}