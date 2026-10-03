import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentScreen extends StatefulWidget {
  
  final String paymentType;
  final String? itemId;
  final String? sellerId;

  const PaymentScreen({
    super.key,
    required this.paymentType,
    this.itemId,
    this.sellerId,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isProcessing = false;

  bool get isSellerPayment => widget.paymentType == 'seller';

  
Future<void> handlePayment() async {
  setState(() {
    isProcessing = true;
  });

  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    if (!mounted) return;

    setState(() {
      isProcessing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please login again'),
      ),
    );

    return;
  }

  // Dummy payment processing for now.
  await Future.delayed(const Duration(seconds: 2));
   try {
      await FirebaseFirestore.instance.collection('payments').add({
        'userId': user.uid,
        'paymentType': widget.paymentType,
        'itemId': widget.itemId,
        'sellerId': widget.sellerId,
        'amount': 5,
        'status': 'success',
        'createdAt': FieldValue.serverTimestamp(),
      });

  // Freeze the item only for buyer payments
  if (widget.paymentType == 'buyer' && widget.itemId != null) {
    final itemRef = FirebaseFirestore.instance.collection('items').doc(widget.itemId);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final itemSnapshot = await transaction.get(itemRef);
      if (!itemSnapshot.exists) {
        throw Exception('Item not found');
      }
      final itemData = itemSnapshot.data() as Map<String, dynamic>;
      if (itemData['status'] != 'approved') {
        throw Exception('This item is no longer available');
      }
      final now = DateTime.now();
      final expiresAt = now.add(const Duration(days: 2));
      transaction.update(itemRef, {
        'status': 'frozen',
        'frozenAt': Timestamp.fromDate(now),
        'expiresAt': Timestamp.fromDate(expiresAt),
        'buyerId': user.uid,
      });
    });
  }

  // Create notification for buyer
if (widget.paymentType == 'buyer') {
  final now = DateTime.now();
  final expiresAt = now.add(const Duration(days: 2));

  await FirebaseFirestore.instance.collection('notifications').add({
    'userId': user.uid,
    'title': 'Payment Successful',
    'message': 'Your ₹5 payment was successful. Seller contact is now unlocked.',
    'type': 'payment_success',
    'createdAt': Timestamp.fromDate(now),
    'expiresAt': Timestamp.fromDate(expiresAt),
  });
}

// Create notification for seller
if (widget.paymentType == 'buyer' && widget.sellerId != null) {
  final now = DateTime.now();
  final expiresAt = now.add(const Duration(days: 2));

  await FirebaseFirestore.instance.collection('notifications').add({
    'userId': widget.sellerId,
    'title': 'Item Reserved',
    'message':
        'A buyer has unlocked your item and can now contact you on WhatsApp.',
    'type': 'item_reserved',
    'itemId': widget.itemId,
    'createdAt': Timestamp.fromDate(now),
    'expiresAt': Timestamp.fromDate(expiresAt),
  });
}

  if (!mounted) return;

  Navigator.pop(context, true);

}
   catch (e) {
    if (!mounted) return;

    setState(() {
      isProcessing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment record failed: $e'),
      ),
    );
  }
}
  // Dummy payment for now.
  // Razorpay will be integrated later.

 


  @override
  Widget build(BuildContext context) {
    final String title = isSellerPayment
        ? 'Listing Fee'
        : 'Unlock Seller Details';

    final String description = isSellerPayment
        ? 'Pay ₹5 to submit your item for admin approval.'
        : 'Pay ₹5 to unlock the seller details and start chatting.';

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
          'Payment',
          style: TextStyle(
            color: Color(0xFFA0522D),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const SizedBox(height: 25),

            // Payment Icon
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFFE35336),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.payment,
                size: 45,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 25),

            Text(
              title,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xFFA0522D),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Color(0xFF8B6B5A),
              ),
            ),

            const SizedBox(height: 30),

            // Payment Summary
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'UniMart Fee',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF8B6B5A),
                        ),
                      ),
                      const Text(
                        '₹5',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFA0522D),
                        ),
                      ),
                    ],
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Divider(),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFA0522D),
                        ),
                      ),
                      const Text(
                        '₹5',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE35336),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Pay Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isProcessing ? null : handlePayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE35336),
                  disabledBackgroundColor:
                      const Color(0xFFE35336).withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 0,
                ),
                child: isProcessing
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        isSellerPayment
                            ? 'Pay ₹5 & Submit Listing'
                            : 'Pay ₹5 & Unlock',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Secure payment powered by Razorpay',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFFB9A69A),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}