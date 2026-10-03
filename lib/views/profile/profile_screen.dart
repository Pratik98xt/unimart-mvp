import 'package:flutter/material.dart';
import '../auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  final String role;

  const ProfileScreen({
    super.key,
    required this.role,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool get isSeller => widget.role == 'Seller';

  Future<void> logout() async {
   await FirebaseAuth.instance.signOut();
   if (!mounted) return;
    Navigator.pushAndRemoveUntil(
     context,
     MaterialPageRoute(
       builder: (context) => const LoginScreen(),
     ),
     (route) => false,
   );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5DC),
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Color(0xFFA0522D),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const SizedBox(height: 10),

            // Profile Header
            Container(
              width: 95,
              height: 95,
              decoration: BoxDecoration(
                color: const Color(0xFFE35336),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.person,
                size: 52,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              'Pratik Jadhav',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFFA0522D),
              ),
            ),

            const SizedBox(height: 5),

            Text(
              isSeller ? 'Seller' : 'Buyer',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF8B6B5A),
              ),
            ),

            const SizedBox(height: 25),

            // Personal Information
            _buildSection(
              title: 'Personal Information',
              children: [
                _buildInfoTile(
                  Icons.person_outline,
                  'Full Name',
                  'Pratik Jadhav',
                ),
                _buildInfoTile(
                  Icons.email_outlined,
                  'Email',
                  'pratik@example.com',
                ),
                _buildInfoTile(
                  Icons.phone_outlined,
                  'Mobile Number',
                  '+91 98765 43210',
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Role Specific Section
            _buildSection(
              title: isSeller ? 'Selling' : 'Activity',
              children: [
                _buildActionTile(
                  icon: isSeller
                      ? Icons.inventory_2_outlined
                      : Icons.chat_bubble_outline,
                  title: isSeller
                      ? 'My Listings'
                      : 'My Chats',
                  onTap: () {
                    // Navigation will be connected later.
                  },
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Logout
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC62828).withOpacity(0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.logout,
                    color: Color(0xFFC62828),
                  ),
                ),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFC62828),
                  ),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Color(0xFFB9A69A),
                ),
                onTap: logout,
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'UniMart • Buy Smart. Sell Easy.',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFFB9A69A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 9),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFFA0522D),
            ),
          ),
        ),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(
    IconData icon,
    String title,
    String value,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFFE35336),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFFB9A69A),
        ),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFFA0522D),
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFFE35336),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(0xFFA0522D),
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Color(0xFFB9A69A),
      ),
      onTap: onTap,
    );
  }
}