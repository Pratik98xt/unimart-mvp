import 'package:flutter/material.dart';
import 'item_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryScreen extends StatefulWidget {
  final String categoryName;

  const CategoryScreen({
    super.key,
    required this.categoryName,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  

Stream<QuerySnapshot<Map<String, dynamic>>> get categoryItemsStream {
  final collection = FirebaseFirestore.instance
      .collection('items')
      .where('status', isEqualTo: 'approved');

  if (widget.categoryName == 'All Categories') {
    return collection.snapshots();
  }

  return collection
      .where('category', isEqualTo: widget.categoryName)
      .snapshots();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),

      body: SafeArea(
        child: Column(
          children: [

            // ---------------- HEADER ----------------

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 15),
              child: Row(
                children: [

                  // Back button
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 19,
                        color: Color(0xFFA0522D),
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Text(
                          'Category',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF8B6B5A),
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(
                          widget.categoryName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFA0522D),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Item count
                  
                ],
              ),
            ),

            // ---------------- DIVIDER ----------------

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 1,
                color: const Color(0xFFE5D8C8),
              ),
            ),

            const SizedBox(height: 18),

            // ---------------- PRODUCTS ----------------
            Expanded(
  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
    stream: categoryItemsStream,
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

      final products = snapshot.data?.docs ?? [];

      if (products.isEmpty) {
        return _emptyState();
      }

      return GridView.builder(
        padding: const EdgeInsets.fromLTRB(
          20,
          0,
          20,
          25,
        ),
        itemCount: products.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.78,
        ),
        itemBuilder: (context, index) {
          return _productCard(products[index]);
        },
      );
    },
  ),
),
          ],
        ),
      ),
    );
  }

  // ---------------- PRODUCT CARD ----------------

  Widget _productCard(QueryDocumentSnapshot<Map<String, dynamic>> document,) {
    final product = document.data();
    return GestureDetector(
      onTap: () {
        // Item Details navigation will be added later.
        Navigator.push(context,MaterialPageRoute(builder: (context) => 
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

            // Image placeholder
            Expanded(
              child: Container(
                width: double.infinity,

                decoration: const BoxDecoration(
                  color: Color(0xFFF4A460),

                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),

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
            ),

            Padding(
              padding: const EdgeInsets.all(12),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Category
                  Text(
                    product['category'],
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFFE35336),
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Product name
                  Text(
                    product['itemName'] ?? 'Unknown Item',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFA0522D),
                    ),
                  ),

                  const SizedBox(height: 7),

                  // Price
                  Text(
                    '₹${product['price'] ?? 0}',
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
      ),
    );
  }

  // ---------------- EMPTY STATE ----------------

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Container(
              height: 85,
              width: 85,

              decoration: BoxDecoration(
                color: const Color(0xFFF4A460),
                borderRadius: BorderRadius.circular(25),
              ),

              child: const Icon(
                Icons.inventory_2_outlined,
                size: 42,
                color: Color(0xFFA0522D),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'No items yet',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color(0xFFA0522D),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'There are no items listed in ${widget.categoryName} yet.',
              textAlign: TextAlign.center,
              style: const TextStyle(
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