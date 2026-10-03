import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../buyer/buyer_home_screen.dart';
import '../seller/seller_home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String selectedRole = 'Buyer';
  bool isLoading = false;

  bool isPasswordVisible = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void navigate(){
    Navigator.push(
     context,
       MaterialPageRoute(
       builder: (context) => const SignupScreen(),
  ),
);
  }
  Future<void> loginUser() async {
  final email = emailController.text.trim();
  final password = passwordController.text.trim();

  // Basic validation
  if (email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter email and password'),
      ),
    );
    return;
  }

  setState(() {
    isLoading = true;
  });

  try {
    // 1. Login with Firebase Authentication
    final userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = userCredential.user!.uid;

    // 2. Get user's Firestore document
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    if (!userDoc.exists) {
      await FirebaseAuth.instance.signOut();

      throw Exception('User profile not found.');
    }

    // 3. Get role from Firestore
    final userData = userDoc.data()!;
    final firebaseRole = userData['role'];

    // 4. Check selected role
    if (firebaseRole != selectedRole.toLowerCase()) {
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'This account is registered as ${firebaseRole == 'buyer' ? 'Buyer' : 'Seller'}.',
          ),
        ),
      );

      return;
    }

    if (!mounted) return;

    // 5. Navigate according to role
    if (firebaseRole == 'buyer') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const BuyerHomeScreen(),
        ),
      );
    } else if (firebaseRole == 'seller') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SellerHomeScreen(),
        ),
      );
    }
  } on FirebaseAuthException catch (e) {
    String message;

    switch (e.code) {
      case 'invalid-credential':
        message = 'Invalid email or password.';
        break;

      case 'user-not-found':
        message = 'No account found with this email.';
        break;

      case 'wrong-password':
        message = 'Incorrect password.';
        break;

      case 'invalid-email':
        message = 'Please enter a valid email address.';
        break;

      case 'user-disabled':
        message = 'This account has been disabled.';
        break;

      case 'too-many-requests':
        message = 'Too many login attempts. Try again later.';
        break;

      case 'network-request-failed':
        message = 'Network error. Check your internet connection.';
        break;

      default:
        message = 'Login failed. Please try again.';
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Something went wrong: $e'),
      ),
    );
  } finally {
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              const SizedBox(height: 45),

              // ---------------- LOGO ----------------

              Container(
                height: 78,
                width: 78,
                decoration: BoxDecoration(
                  color: const Color(0xFFE35336),
                  borderRadius: BorderRadius.circular(24),
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
                  size: 42,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              // ---------------- TITLE ----------------

              const Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFA0522D),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Your campus marketplace is waiting for you.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF8B6B5A),
                ),
              ),

              const SizedBox(height: 35),

              // ---------------- LOGIN CARD ----------------

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
                      'Login as',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFA0522D),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ---------------- ROLE SELECTOR ----------------

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

                    const SizedBox(height: 25),

                    // ---------------- EMAIL ----------------

                    const Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFA0522D),
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,

                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        hintStyle: const TextStyle(
                          color: Color(0xFFB9A69A),
                        ),

                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Color(0xFFA0522D),
                        ),

                        filled: true,
                        fillColor: const Color(0xFFF9F5E9),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ---------------- PASSWORD ----------------

                    const Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFA0522D),
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: passwordController,
                      obscureText: !isPasswordVisible,

                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        hintStyle: const TextStyle(
                          color: Color(0xFFB9A69A),
                        ),

                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Color(0xFFA0522D),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isPasswordVisible =
                                  !isPasswordVisible;
                            });
                          },
                          icon: Icon(
                            isPasswordVisible
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
                    ),

                    const SizedBox(height: 28),

                    // ---------------- LOGIN BUTTON ----------------

                    SizedBox(
                      width: double.infinity,
                      height: 56,

                      child: ElevatedButton(
                        onPressed: isLoading ? null : loginUser,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE35336),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(16),
                          ),
                        ),

                        child: isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Login',
                              style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              ),
                            ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ---------------- SIGNUP ----------------

                    GestureDetector(
                      onTap: navigate,
                      child: Center(
                        child: RichText(
                          text: const TextSpan(
                            text: "Don't have an account? ",
                      
                            style: TextStyle(
                              color: Color(0xFF8B6B5A),
                              fontSize: 14,
                            ),
                      
                            children: [
                              TextSpan(
                                text: 'Sign Up',
                      
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

              const SizedBox(height: 30),

              // ---------------- FOOTER ----------------

              const Text(
                'Buy smart. Sell easy.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFFA0522D),
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- ROLE BUTTON ----------------

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

        padding: const EdgeInsets.symmetric(
          vertical: 12,
        ),

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