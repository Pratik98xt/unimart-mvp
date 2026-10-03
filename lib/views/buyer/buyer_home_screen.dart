import 'package:flutter/material.dart';
import 'category_screen.dart';
import 'chat_screen.dart';
import '../profile/profile_screen.dart';
import 'chat_list_screen.dart';
import 'item_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unimart_mvp/views/notifications/notification_screen.dart';

class BuyerHomeScreen extends StatefulWidget {
  const BuyerHomeScreen({super.key});

  @override
  State<BuyerHomeScreen> createState() => _BuyerHomeScreenState();
}

class _BuyerHomeScreenState extends State<BuyerHomeScreen> {
  int selectedIndex = 0;

  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Books',
      'icon': Icons.menu_book_outlined,
    },
    {
      'name': 'Furniture',
      'icon': Icons.chair_outlined,
    },
    {
      'name': 'Electronics',
      'icon': Icons.devices_outlined,
    },
    {
      'name': 'Clothing',
      'icon': Icons.checkroom_outlined,
    },
    {
      'name': 'Bags',
      'icon': Icons.backpack_outlined,
    },
    {
      'name': 'Hostel',
      'icon': Icons.home_outlined,
    },
    {
      'name': 'Other',
      'icon': Icons.category_outlined,
    },
  ];

  Stream<QuerySnapshot<Map<String, dynamic>>> get approvedItemsStream {
  return FirebaseFirestore.instance
      .collection('items')
      .where('status', isEqualTo: 'approved')
      .snapshots();
}

  Widget _bottomNavItem({
  required int index,
  required IconData icon,
  required IconData activeIcon,
  required String label,
}) {
  final bool isSelected = selectedIndex == index;

  return GestureDetector(
    onTap: () {
      setState(() {
        selectedIndex = index;
      });
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

                    // Logo
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

                    // Profile
                    Container(
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
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ---------------- GREETING ----------------

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Find what you need,\nfor less.',
                  style: TextStyle(
                    fontSize: 29,
                    height: 1.15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFA0522D),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // ---------------- SIMPLE SEARCH FIELD ----------------

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Search items...',
                      hintStyle: TextStyle(
                        color: Color(0xFFB9A69A),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Color(0xFFA0522D),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ---------------- CATEGORIES ----------------

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFA0522D),
                      ),
                    ),
                    Text(
                      'View all',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE35336),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                height: 105,
                child: ListView.builder(
                  padding: const EdgeInsets.only(left: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {

                    final category = categories[index];

                    return Container(
                      width: 82,
                      margin: const EdgeInsets.only(right: 12),
                      child: Column(
                        children: [

                          Container(
                            height: 65,
                            width: 65,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4A460),
                              borderRadius:
                                  BorderRadius.circular(20),
                            ),
                            child: Icon(
                              category['icon'],
                              size: 28,
                              color: const Color(0xFFA0522D),
                            ),
                          ),

                          const SizedBox(height: 7),

                          Text(
                            category['name'],
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFA0522D),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 25),

              // ---------------- RECENT ITEMS ----------------

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recently Listed',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFA0522D),
                      ),
                    ),
                    Text(
                      'View all',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE35336),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // Product grid
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
  stream: approvedItemsStream,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Padding(
        padding: EdgeInsets.all(30),
        child: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFE35336),
          ),
        ),
      );
    }

    if (snapshot.hasError) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          'Something went wrong: ${snapshot.error}',
          textAlign: TextAlign.center,
        ),
      );
    }

    final products = snapshot.data?.docs ?? [];

    if (products.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(30),
        child: Center(
          child: Text(
            'No items available yet.',
            style: TextStyle(
              color: Color(0xFF8B6B5A),
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: products.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.78,
        ),
        itemBuilder: (context, index) {
          final document = products[index];

          return _productCard(document);
        },
      ),
    );
  },
),
            ],
          ),
        ),
      ),

      // ---------------- BOTTOM NAVIGATION ----------------

      bottomNavigationBar: Padding(
  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
  child: Container(
    height: 68,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 18,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _modernNavItem(
          index: 0,
          icon: Icons.home_outlined,
          activeIcon: Icons.home,
          label: 'Home',
        ),

        _modernNavItem(
          index: 1,
          icon: Icons.grid_view_outlined,
          activeIcon: Icons.grid_view,
          label: 'Categories',
        ),

        _modernNavItem(
          index: 2,
          icon: Icons.notifications_none,
          activeIcon: Icons.chat_bubble,
          label: 'Notifications',
        ),

        _modernNavItem(
          index: 3,
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

  // ---------------- PRODUCT CARD ----------------
  Widget _productCard(
  QueryDocumentSnapshot<Map<String, dynamic>> document,
) {
  final product = document.data();

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => 
          ItemDetailsScreen(
  itemId: document.id,
  itemName: product['itemName'] ?? 'Unknown Item',
  price: '₹${product['price'] ?? 0}',
  category: product['category'] ?? 'Other',
  description: product['description'] ?? 'No description available.',
  imageAsset: product['imageAsset'] ?? '',
  sellerId: product['sellerId'] ?? '',
),
        ),
      );
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Image
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: Image.asset(
                product['imageAsset'] ?? '',
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    color: const Color(0xFFF4A460),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      size: 55,
                      color: Color(0xFFA0522D),
                    ),
                  );
                },
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  product['category'] ?? 'Other',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFFE35336),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  product['itemName'] ?? 'Unknown Item',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFA0522D),
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  '₹${product['price'] ?? 0}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE35336),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
  
    Widget _modernNavItem({
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
            builder: (context) => const CategoryScreen(
              categoryName: 'All Categories',
            ),
          ),
        );
      }

      if (index == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NotificationScreen(),
          ),
        );
      }

      if (index == 3) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfileScreen(
              role: 'Buyer',
            ),
          ),
        );
      }
    },
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          isSelected ? activeIcon : icon,
          size: 23,
          color: isSelected
              ? const Color(0xFFE35336)
              : const Color(0xFF8B6B5A),
        ),

        const SizedBox(height: 4),

        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isSelected
                ? FontWeight.bold
                : FontWeight.w500,
            color: isSelected
                ? const Color(0xFFE35336)
                : const Color(0xFF8B6B5A),
          ),
        ),
      ],
    ),
  );
}
}
