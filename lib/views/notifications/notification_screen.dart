import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  Stream<QuerySnapshot<Map<String, dynamic>>> get notificationsStream {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return const Stream.empty();
  }

  return FirebaseFirestore.instance
      .collection('notifications')
      .where('userId', isEqualTo: user.uid)
      .snapshots();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5DC),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Color(0xFFA0522D),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: notificationsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(
                  color: Color(0xFF8B6B5A),
                ),
              ),
            );
          }

          final documents = snapshot.data?.docs ?? [];

          final now = DateTime.now();

          final notifications = documents.where((doc) {
            final data = doc.data();

            final expiresAt = data['expiresAt'];

            if (expiresAt == null) {
              return true;
            }

            final expiryDate = (expiresAt as Timestamp).toDate();

            return expiryDate.isAfter(now);
          }).toList();
          notifications.sort((a, b) {

  final aTime = a.data()['createdAt'] as Timestamp?;

  final bTime = b.data()['createdAt'] as Timestamp?;

  if (aTime == null || bTime == null) {

    return 0;

  }

  return bTime.compareTo(aTime);

});

          if (notifications.isEmpty) {
            return const Center(
              child: Text(
                'No notifications yet',
                style: TextStyle(
                  color: Color(0xFF8B6B5A),
                  fontSize: 16,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final data = notifications[index].data();

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9E8D7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.notifications_none,
                        color: Color(0xFFE35336),
                        size: 24,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['title'] ?? 'Notification',
                            style: const TextStyle(
                              color: Color(0xFFA0522D),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            data['message'] ?? '',
                            style: const TextStyle(
                              color: Color(0xFF8B6B5A),
                              fontSize: 14,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            'Notification',
                            style: const TextStyle(
                              color: Color(0xFFB9A69A),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}