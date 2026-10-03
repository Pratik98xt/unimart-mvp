import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../auth/login_screen.dart';
import '../buyer/buyer_home_screen.dart';
import '../seller/seller_home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<void> checkUser(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));

    if (!context.mounted) return;

    final user = FirebaseAuth.instance.currentUser;

    // No user logged in
    if (user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
      return;
    }

    // User is already logged in
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!context.mounted) return;

    if (!userDoc.exists) {
      await FirebaseAuth.instance.signOut();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );

      return;
    }

    final role = userDoc.data()?['role'];

    if (role == 'buyer') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const BuyerHomeScreen(),
        ),
      );
    } else if (role == 'seller') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SellerHomeScreen(),
        ),
      );
    } else {
      await FirebaseAuth.instance.signOut();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    checkUser(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // UniMart Logo
            Container(
              height: 110,
              width: 110,
              decoration: BoxDecoration(
                color: const Color(0xFFE35336),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.white,
                size: 60,
              ),
            ),

            const SizedBox(height: 25),

            // App Name
            const Text(
              'UniMart',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color(0xFFA0522D),
              ),
            ),

            const SizedBox(height: 10),

            // Tagline
            const Text(
              'Buy Smart. Sell Easy.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFA0522D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}