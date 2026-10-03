import 'package:flutter/material.dart';
import '../payment/payment_screen.dart';
import 'chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemDetailsScreen extends StatelessWidget {
  final String itemId;
final String itemName;
final String price;
final String category;
final String description;
final String imageAsset;
final String sellerId;

const ItemDetailsScreen({
  super.key,
  required this.itemId,
  required this.itemName,
  required this.price,
  required this.category,
  required this.description,
  required this.imageAsset,
  required this.sellerId,
});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),

      body: SafeArea(
        child: Column(
          children: [

            // ---------------- TOP BAR ----------------

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
              child: Row(
                children: [

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

                  const Text(
                    'Item Details',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFA0522D),
                    ),
                  ),
                ],
              ),
            ),

            // ---------------- CONTENT ----------------

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  10,
                  20,
                  25,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ---------------- ITEM IMAGE ----------------

                    ClipRRect(
  borderRadius: BorderRadius.circular(25),
  child: Image.asset(
    imageAsset,
    width: double.infinity,
    height: 260,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      return Container(
        height: 260,
        width: double.infinity,
        color: const Color(0xFFF4A460),
        child: const Icon(
          Icons.shopping_bag_outlined,
          size: 100,
          color: Color(0xFFA0522D),
        ),
      );
    },
  ),
),

                    const SizedBox(height: 22),

                    // ---------------- CATEGORY ----------------

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4A460),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        category,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFA0522D),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ---------------- NAME + PRICE ----------------

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Expanded(
                          child: Text(
                            itemName,
                            style: const TextStyle(
                              fontSize: 25,
                              height: 1.15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFA0522D),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Text(
                          price,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE35336),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // ---------------- DESCRIPTION ----------------

                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFA0522D),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: Color(0xFF8B6B5A),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // ---------------- SELLER CARD ----------------

                    FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
  future: FirebaseFirestore.instance
      .collection('users')
      .doc(sellerId)
      .get(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Text(
        'Loading...',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Color(0xFFA0522D),
        ),
      );
    }

    final sellerData = snapshot.data?.data();

    return Text(
      sellerData?['name'] ?? 'Unknown Seller',
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Color(0xFFA0522D),
      ),
    );
  },
),
                    const SizedBox(height: 10),

                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [

                          Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4A460),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Icon(
                              Icons.person_outline,
                              color: Color(0xFFA0522D),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [

                                FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
  future: FirebaseFirestore.instance
      .collection('users')
      .doc(sellerId)
      .get(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Text(
        'Loading...',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Color(0xFFA0522D),
        ),
      );
    }

    final sellerData = snapshot.data?.data();

    return Text(
      sellerData?['name'] ?? 'Unknown Seller',
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Color(0xFFA0522D),
      ),
    );
  },
),

                                const SizedBox(height: 4),

                                const Row(
                                  children: [
                                    Icon(
                                      Icons.lock_outline,
                                      size: 13,
                                      color: Color(0xFF8B6B5A),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Contact details locked',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF8B6B5A),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ---------------- INFO ----------------

                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9E8D7),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Icon(
                            Icons.info_outline,
                            color: Color(0xFFE35336),
                            size: 21,
                          ),

                          SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              'Pay ₹5 to unlock the seller details '
                              'and start chatting with the seller.',
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.4,
                                color: Color(0xFFA0522D),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // ---------------- CONTACT BUTTON ----------------

            Container(
              padding: const EdgeInsets.fromLTRB(
                20,
                12,
                20,
                18,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 15,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final paymentSuccessful = await Navigator.push(context,MaterialPageRoute(builder: (context) =>  PaymentScreen(paymentType: 'buyer',itemId: itemId,sellerId: sellerId,),),);
                    print('ITEM ID: $itemId');
                    print('SELLER ID: $sellerId');
                    if (paymentSuccessful == true && context.mounted) {
  try {
    final sellerDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(sellerId)
        .get();

    final sellerData = sellerDoc.data();
    final mobile = sellerData?['mobile'];

    if (mobile == null || mobile.toString().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Seller WhatsApp number is not available'),
        ),
      );
      return;
    }

    final whatsappNumber = '91${mobile.toString()}';

    final whatsappUrl = Uri.parse(
      'https://wa.me/$whatsappNumber',
    );

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(
        whatsappUrl,
        mode: LaunchMode.externalApplication,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open WhatsApp'),
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Unable to open WhatsApp: $e'),
      ),
    );
  }
}
                  },
                  icon: const Icon(
                    Icons.lock_open_outlined,
                    size: 20,
                  ),
                  label: const Text(
                    'Pay ₹5 & Contact Seller',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE35336),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}