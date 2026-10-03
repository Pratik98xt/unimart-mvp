import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isLoading = false;
  String selectedRole = 'Buyer';
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void navigate(){
    Navigator.pop(context);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> createAccount() async {
  final name = nameController.text.trim();
  final email = emailController.text.trim().toLowerCase();
  final mobile = mobileController.text.trim();
  final password = passwordController.text;
  final confirmPassword = confirmPasswordController.text;

  // Name validation
  if (name.isEmpty) {
    showMessage('Please enter your full name');
    return;
  }

  if (name.length < 2) {
    showMessage('Name must contain at least 2 characters');
    return;
  }

  if (name.length > 50) {
    showMessage('Name cannot exceed 50 characters');
    return;
  }

  if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(name)) {
    showMessage('Name can contain only letters and spaces');
    return;
  }

  // Email validation
  if (email.isEmpty) {
    showMessage('Please enter your email');
    return;
  }

  if (!RegExp(
    r'^[\w\.-]+@[\w\.-]+\.\w+$',
  ).hasMatch(email)) {
    showMessage('Please enter a valid email address');
    return;
  }

  // Mobile validation
  if (mobile.isEmpty) {
    showMessage('Please enter your mobile number');
    return;
  }

  if (!RegExp(r'^[6-9][0-9]{9}$').hasMatch(mobile)) {
    showMessage('Enter a valid 10-digit mobile number');
    return;
  }

  // Password validation
  if (password.isEmpty) {
    showMessage('Please enter a password');
    return;
  }

  if (password.length < 8) {
    showMessage('Password must contain at least 8 characters');
    return;
  }

  if (!RegExp(r'[A-Z]').hasMatch(password)) {
    showMessage('Password must contain an uppercase letter');
    return;
  }

  if (!RegExp(r'[a-z]').hasMatch(password)) {
    showMessage('Password must contain a lowercase letter');
    return;
  }

  if (!RegExp(r'[0-9]').hasMatch(password)) {
    showMessage('Password must contain a number');
    return;
  }

  if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
    showMessage('Password must contain a special character');
    return;
  }

  // Confirm password
  if (confirmPassword.isEmpty) {
    showMessage('Please confirm your password');
    return;
  }

  if (password != confirmPassword) {
    showMessage('Passwords do not match');
    return;
  }

  setState(() {
    isLoading = true;
  });

  try {
    // Check whether mobile already exists
    final mobileQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('mobile', isEqualTo: mobile)
        .limit(1)
        .get();

    if (mobileQuery.docs.isNotEmpty) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }

      showMessage('This mobile number is already registered');
      return;
    }

    // Create Firebase Auth account
    final userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user;

    if (user == null) {
      throw Exception('Unable to create account');
    }

    // Save additional user information
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set({
      'uid': user.uid,
      'name': name,
      'email': email,
      'mobile': mobile,
      'role': selectedRole.toLowerCase(),
      'createdAt': FieldValue.serverTimestamp(),
    });

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account created successfully'),
      ),
    );

    Navigator.pop(context);
  } on FirebaseAuthException catch (e) {
    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (e.code == 'email-already-in-use') {
      showMessage('This email is already registered');
    } else if (e.code == 'invalid-email') {
      showMessage('Invalid email address');
    } else if (e.code == 'weak-password') {
      showMessage('Password is too weak');
    } else if (e.code == 'network-request-failed') {
      showMessage('Network error. Please check your internet connection');
    } else {
      showMessage(e.message ?? 'Unable to create account');
    }
  } catch (e) {
    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    showMessage('Something went wrong. Please try again');
  }
}

void showMessage(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),

              // Logo
              Container(
                height: 72,
                width: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFFE35336),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE35336).withOpacity(0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  size: 40,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 29,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFA0522D),
                ),
              ),

              const SizedBox(height: 7),

              const Text(
                'Join your campus marketplace today.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF8B6B5A),
                ),
              ),

              const SizedBox(height: 28),

              // Signup Card
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'I want to join as',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFA0522D),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Role selector
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5DC),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _roleButton(
                              title: 'Buyer',
                              icon: Icons.shopping_cart_outlined,
                            ),
                          ),
                          Expanded(
                            child: _roleButton(
                              title: 'Seller',
                              icon: Icons.sell_outlined,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 23),

                    _fieldLabel('Full Name'),

                    const SizedBox(height: 8),

                    _textField(
                      controller: nameController,
                      hint: 'Enter your full name',
                      icon: Icons.person_outline,
                    ),

                    const SizedBox(height: 17),

                    _fieldLabel('Email'),

                    const SizedBox(height: 8),

                    _textField(
                      controller: emailController,
                      hint: 'Enter your email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 17),

                    _fieldLabel('Mobile Number'),

                    const SizedBox(height: 8),

                    _textField(
                      controller: mobileController,
                      hint: 'Enter your mobile number',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),

                    const SizedBox(height: 17),

                    _fieldLabel('Password'),

                    const SizedBox(height: 8),

                    _passwordField(
                      controller: passwordController,
                      hint: 'Create a password',
                      isVisible: isPasswordVisible,
                      onToggle: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),

                    const SizedBox(height: 17),

                    _fieldLabel('Confirm Password'),

                    const SizedBox(height: 8),

                    _passwordField(
                      controller: confirmPasswordController,
                      hint: 'Confirm your password',
                      isVisible: isConfirmPasswordVisible,
                      onToggle: () {
                        setState(() {
                          isConfirmPasswordVisible =
                              !isConfirmPasswordVisible;
                        });
                      },
                    ),

                    const SizedBox(height: 27),

                    // Create Account button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : createAccount,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE35336),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          ) 
                        :const Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 23),

                    // Login link
                    GestureDetector(
                      onTap: navigate,
                      child: Center(
                        child: RichText(
                          text: const TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(
                              color: Color(0xFF8B6B5A),
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(
                                text: 'Login',
                                style: TextStyle(
                                  color: Color(0xFFE35336),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Buy smart. Sell easy.',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFFA0522D),
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Field label
  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFFA0522D),
      ),
    );
  }

  // Normal text field
  Widget _textField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFFB9A69A),
        ),
        prefixIcon: Icon(
          icon,
          color: const Color(0xFFA0522D),
        ),
        filled: true,
        fillColor: const Color(0xFFF9F5E9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // Password field
  Widget _passwordField({
    required TextEditingController controller,
    required String hint,
    required bool isVisible,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFFB9A69A),
        ),
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: Color(0xFFA0522D),
        ),
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(
            isVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: const Color(0xFFA0522D),
          ),
        ),
        filled: true,
        fillColor: const Color(0xFFF9F5E9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // Buyer / Seller selector
  Widget _roleButton({
    required String title,
    required IconData icon,
  }) {
    final bool isSelected = selectedRole == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = title;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFE35336)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 19,
              color: isSelected
                  ? Colors.white
                  : const Color(0xFFA0522D),
            ),
            const SizedBox(width: 7),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? Colors.white
                    : const Color(0xFFA0522D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}