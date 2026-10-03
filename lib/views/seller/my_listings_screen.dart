import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyListingsScreen extends StatefulWidget {
  const MyListingsScreen({super.key});

  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
  
  Stream<QuerySnapshot<Map<String, dynamic>>> get myListingsStream {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return const Stream.empty();
  }

  return FirebaseFirestore.instance
      .collection('items')
      .where('sellerId', isEqualTo: user.uid)
      .snapshots();
}

  Color getStatusColor(String status) {
    if (status == 'Approved') {
      return const Color(0xFF2E7D32);
    }

    if (status == 'Rejected') {
      return const Color(0xFFC62828);
    }

    return const Color(0xFFE67E22);
  }

  IconData getStatusIcon(String status) {
    if (status == 'Approved') {
      return Icons.check_circle_outline;
    }

    if (status == 'Rejected') {
      return Icons.cancel_outlined;
    }

    return Icons.access_time;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5DC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFFA0522D),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'My Listings',
          style: TextStyle(
            color: Color(0xFFA0522D),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
  stream: myListingsStream,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFE35336),
        ),
      );
    }

    if (snapshot.hasError) {
      return Center(
        child: Text(
          'Something went wrong: ${snapshot.error}',
          textAlign: TextAlign.center,
        ),
      );
    }

    final listings = snapshot.data?.docs ?? [];

    if (listings.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
      itemCount: listings.length,
      itemBuilder: (context, index) {
        final document = listings[index];

        return _buildListingCard(document);
      },
    );
  },
),
    );
  }

  Widget _buildListingCard(QueryDocumentSnapshot<Map<String, dynamic>> document) {
    final listing = document.data();

    final String status = listing['status'] ?? 'pending';
    

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Product Image
          ClipRRect(
  borderRadius: BorderRadius.circular(16),
  child: Image.asset(
    listing['imageAsset'] ?? '',
    width: 90,
    height: 90,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      return Container(
        width: 90,
        height: 90,
        color: const Color(0xFFF4A460),
        child: const Icon(
          Icons.shopping_bag_outlined,
          size: 38,
          color: Color(0xFFA0522D),
        ),
      );
    },
  ),
),

          const SizedBox(width: 14),

          // Product Information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  listing['itemName'] ?? 'Unknown Item',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFA0522D),
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  listing['category'] ?? 'Other',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF8B6B5A),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  '₹${listing['price'] ?? 0}',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE35336),
                  ),
                ),

                const SizedBox(height: 9),

                // Status
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: getStatusColor(status).withOpacity(0.10),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        getStatusIcon(status),
                        size: 15,
                        color: getStatusColor(status),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        status,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: getStatusColor(status),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFFF4A460).withOpacity(0.20),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                size: 50,
                color: Color(0xFFA0522D),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'No Listings Yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFFA0522D),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Items you list will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF8B6B5A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}