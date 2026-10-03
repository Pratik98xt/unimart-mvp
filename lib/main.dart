import 'package:flutter/material.dart';
import 'package:unimart_mvp/views/admin/admin_approval_screen.dart';
import 'package:unimart_mvp/views/auth/login_screen.dart';
import 'package:unimart_mvp/views/auth/signup_screen.dart';
import 'package:unimart_mvp/views/buyer/buyer_home_screen.dart';
import 'package:unimart_mvp/views/buyer/category_screen.dart';
import 'package:unimart_mvp/views/buyer/chat_screen.dart';
import 'package:unimart_mvp/views/buyer/item_details_screen.dart';
import 'package:unimart_mvp/views/notifications/notification_screen.dart';
import 'package:unimart_mvp/views/payment/payment_screen.dart';
import 'package:unimart_mvp/views/seller/my_listings_screen.dart';
import 'package:unimart_mvp/views/seller/seller_home_screen.dart';
import 'package:unimart_mvp/views/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen()
    );
  }
}
