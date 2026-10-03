import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminApprovalScreen extends StatefulWidget {
  const AdminApprovalScreen({super.key});

  @override
  State<AdminApprovalScreen> createState() =>
      _AdminApprovalScreenState();
}

class _AdminApprovalScreenState
    extends State<AdminApprovalScreen> {
  
Stream<QuerySnapshot<Map<String, dynamic>>> get pendingListingsStream {
  return FirebaseFirestore.instance
      .collection('items')
      .where('status', isEqualTo: 'pending')
      .snapshots();
}
  
  Future<void> approveListing(String itemId) async {
  try {
    final itemRef = FirebaseFirestore.instance
        .collection('items')
        .doc(itemId);

    final itemSnapshot = await itemRef.get();

    if (!itemSnapshot.exists) {
      throw Exception('Listing not found');
    }

    final itemData = itemSnapshot.data();

    final sellerId = itemData?['sellerId'];
    final itemName = itemData?['itemName'] ?? 'Your item';

    await itemRef.update({
      'status': 'approved',
    });

    if (sellerId != null) {
      final now = DateTime.now();
      final expiresAt = now.add(const Duration(days: 2));

      await FirebaseFirestore.instance.collection('notifications').add({
        'userId': sellerId,
        'title': 'Listing Approved',
        'message': '$itemName has been approved and is now visible to buyers.',
        'type': 'listing_approved',
        'itemId': itemId,
        'createdAt': Timestamp.fromDate(now),
        'expiresAt': Timestamp.fromDate(expiresAt),
      });
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Listing approved successfully'),
      ),
    );
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to approve listing: $e'),
      ),
    );
  }
}

Future<void> rejectListing(String itemId) async {
  try {
    final itemRef = FirebaseFirestore.instance
        .collection('items')
        .doc(itemId);

    final itemSnapshot = await itemRef.get();

    if (!itemSnapshot.exists) {
      throw Exception('Listing not found');
    }

    final itemData = itemSnapshot.data();

    final sellerId = itemData?['sellerId'];
    final itemName = itemData?['itemName'] ?? 'Your item';

    await itemRef.update({
      'status': 'rejected',
    });

    if (sellerId != null) {
      final now = DateTime.now();
      final expiresAt = now.add(const Duration(days: 2));

      await FirebaseFirestore.instance.collection('notifications').add({
        'userId': sellerId,
        'title': 'Listing Rejected',
        'message': '$itemName was rejected by the admin.',
        'type': 'listing_rejected',
        'itemId': itemId,
        'createdAt': Timestamp.fromDate(now),
        'expiresAt': Timestamp.fromDate(expiresAt),
      });
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Listing rejected'),
      ),
    );
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to reject listing: $e'),
      ),
    );
  }
}

    

  

    

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5DC),
        elevation: 0,
        title: const Text(
          'Admin Approval',
          style: TextStyle(
            color: Color(0xFFA0522D),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: pendingListingsStream,
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
      padding: const EdgeInsets.fromLTRB(
        16,
        10,
        16,
        30,
      ),
      itemCount: listings.length,
      itemBuilder: (context, index) {
        final document = listings[index];

        return _buildListingCard(
          document,
        );
      },
    );
  },
),
    );
  }

  Widget _buildListingCard(
    QueryDocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final listing = document.data();
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Image + Basic Information
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              ClipRRect(
  borderRadius: BorderRadius.circular(16),
  child: Image.asset(
    listing['imageAsset'] ?? '',
    width: 85,
    height: 85,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      return Container(
        width: 85,
        height: 85,
        decoration: BoxDecoration(
          color: const Color(0xFFF4A460).withOpacity(0.25),
          borderRadius: BorderRadius.circular(16),
        ),
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

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Text(
  listing['itemName'] ?? 'Unknown Item',
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
  style: const TextStyle(
    fontSize: 17,
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

                    const SizedBox(height: 4),

                    Text(
                      '₹${listing['price'] ?? 0}',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE35336),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Seller
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF9F5E9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [

                const Icon(
                  Icons.person_outline,
                  size: 20,
                  color: Color(0xFFA0522D),
                ),

                const SizedBox(width: 8),

                const Text(
                  'Seller:',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF8B6B5A),
                  ),
                ),

                const SizedBox(width: 5),

                FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
  future: FirebaseFirestore.instance
      .collection('users')
      .doc(listing['sellerId'])
      .get(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Text(
        'Loading...',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Color(0xFFA0522D),
        ),
      );
    }

    if (!snapshot.hasData || !snapshot.data!.exists) {
      return const Text(
        'Unknown Seller',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Color(0xFFA0522D),
        ),
      );
    }

    final sellerData = snapshot.data!.data();

    return Text(
      sellerData?['name'] ?? 'Unknown Seller',
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Color(0xFFA0522D),
      ),
    );
  },
),
              ],
            ),
          ),

          const SizedBox(height: 15),

          // Action Buttons
          Row(
            children: [

              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    rejectListing(document.id);
                  },
                  icon: const Icon(
                    Icons.close,
                    size: 18,
                  ),
                  label: const Text('Reject'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFC62828),
                    side: const BorderSide(
                      color: Color(0xFFC62828),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 13,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    approveListing(document.id);
                  },
                  icon: const Icon(
                    Icons.check,
                    size: 18,
                  ),
                  label: const Text('Approve'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE35336),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 13,
                    ),
                  ),
                ),
              ),
            ],
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
                color: const Color(0xFFF4A460)
                    .withOpacity(0.20),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline,
                size: 52,
                color: Color(0xFFA0522D),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'No Pending Listings',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFFA0522D),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'All submitted listings have been reviewed.',
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