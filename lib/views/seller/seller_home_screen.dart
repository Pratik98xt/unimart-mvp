import 'package:flutter/material.dart';
import 'package:unimart_mvp/views/notifications/notification_screen.dart';
import 'package:unimart_mvp/views/seller/seller_chat_list_screen.dart';
import 'add_item_screen.dart';
import 'my_listings_screen.dart';
import '../profile/profile_screen.dart';

class SellerHomeScreen extends StatefulWidget {
  const SellerHomeScreen({super.key});

  @override
  State<SellerHomeScreen> createState() => _SellerHomeScreenState();
}

class _SellerHomeScreenState extends State<SellerHomeScreen> {
  int selectedIndex = 0;

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 18),

              // ---------------- HEADER ----------------

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [

                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE35336),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.white,
                        size: 27,
                      ),
                    ),

                    const SizedBox(width: 12),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back!',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF8B6B5A),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'UniMart',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFA0522D),
                            ),
                          ),
                        ],
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                         Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileScreen(role: 'Seller')));
                      },
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person_outline,
                          color: Color(0xFFA0522D),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ---------------- SELLING HERO ----------------

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE35336),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [

                            const Text(
                              'Have something\nto sell?',
                              style: TextStyle(
                                fontSize: 25,
                                height: 1.15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 10),

                            const Text(
                              'Give your unused items\na new home on campus.',
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.4,
                                color: Colors.white70,
                              ),
                            ),

                            const SizedBox(height: 18),

                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> const AddItemScreen()));
                                // Add Item navigation later.
                              },
                              icon: const Icon(
                                Icons.add,
                                size: 19,
                              ),
                              label: const Text(
                                'Sell an Item',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor:
                                    const Color(0xFFE35336),
                                elevation: 0,
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(13),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),

                      Container(
                        height: 105,
                        width: 105,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.sell_outlined,
                          size: 55,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ---------------- QUICK INFO ----------------

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Start Selling',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFA0522D),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [

                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const AddItemScreen()));
                  
                        },
                        child: _infoCard(
                          icon: Icons.add_box_outlined,
                          title: 'List an Item',
                          subtitle: 'Pay ₹5 & submit',
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                           Navigator.push(context, MaterialPageRoute(builder: (context)=> const MyListingsScreen()));
                        },
                        child: _infoCard(
                          icon: Icons.inventory_2_outlined,
                          title: 'My Listings',
                          subtitle: 'View your items',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ---------------- CATEGORIES ----------------

              

              const SizedBox(height: 25),

              // ---------------- SELLING STEPS ----------------

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        'How selling works',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFA0522D),
                        ),
                      ),

                      SizedBox(height: 15),

                      _Step(
                        number: '1',
                        title: 'Add your item',
                        subtitle: 'Enter details and select a category.',
                      ),

                      SizedBox(height: 12),

                      _Step(
                        number: '2',
                        title: 'Pay ₹5',
                        subtitle: 'Pay the UniMart listing fee.',
                      ),

                      SizedBox(height: 12),

                      _Step(
                        number: '3',
                        title: 'Get approved',
                        subtitle: 'Your listing goes live after approval.',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // ---------------- BOTTOM NAVIGATION ----------------

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              _bottomNavItem(
                index: 0,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
              ),

_bottomNavItem(
  index: 1,
  icon: Icons.notifications_none,
  activeIcon: Icons.chat_bubble,
  label: 'Chats',
),

_bottomNavItem(
  index: 2,
  icon: Icons.add_circle_outline,
  activeIcon: Icons.add_circle,
  label: 'Sell',
),

_bottomNavItem(
  index: 3,
  icon: Icons.inventory_2_outlined,
  activeIcon: Icons.inventory_2,
  label: 'Listings',
),

_bottomNavItem(
  index: 4,
  icon: Icons.person_outline,
  activeIcon: Icons.person,
  label: 'Profile',
),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- INFO CARD ----------------

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFF4A460),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFA0522D),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFFA0522D),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF8B6B5A),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- BOTTOM NAV ITEM ----------------

  Widget _bottomNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        if (index == 0) {

        setState(() {

          selectedIndex = 0;

        });

      }
      if (index == 1) {

         Navigator.push(

          context,

          MaterialPageRoute(

            builder: (context) => const NotificationScreen(),

          ),

        );

      }

      if (index == 2) {

        Navigator.push(

          context,

          MaterialPageRoute(

            builder: (context) => const AddItemScreen(),

          ),

        );

      }

      if (index == 3) {

        Navigator.push(

          context,

          MaterialPageRoute(

            builder: (context) => const MyListingsScreen(),

          ),

        );

      }

      if (index == 4) {

        Navigator.push(

          context,

          MaterialPageRoute(

            builder: (context) => const ProfileScreen(

              role: 'Seller',

            ),

          ),

        );

      }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFE35336)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [

            Icon(
              isSelected ? activeIcon : icon,
              size: 23,
              color: isSelected
                  ? Colors.white
                  : const Color(0xFFA0522D),
            ),

            if (isSelected) ...[
              const SizedBox(width: 7),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ---------------- SELLING STEP ----------------

class _Step extends StatelessWidget {
  final String number;
  final String title;
  final String subtitle;

  const _Step({
    required this.number,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Container(
          height: 32,
          width: 32,
          decoration: const BoxDecoration(
            color: Color(0xFFE35336),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFA0522D),
                ),
              ),

              const SizedBox(height: 2),

              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF8B6B5A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}