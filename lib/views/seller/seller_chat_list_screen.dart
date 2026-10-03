import 'package:flutter/material.dart';
import '../buyer/chat_screen.dart';

class SellerChatListScreen extends StatelessWidget {
  const SellerChatListScreen({super.key});

  final List<Map<String, String>> chats = const [
    {
      'item': 'Engineering Mathematics',
      'buyer': 'Pratik',
      'message': 'Is this book still available?',
      'time': '10:30 AM',
    },
    {
      'item': 'Study Table',
      'buyer': 'Amit',
      'message': 'Can I collect it tomorrow?',
      'time': 'Yesterday',
    },
    {
      'item': 'Wireless Headphones',
      'buyer': 'Rohan',
      'message': 'Can you reduce the price?',
      'time': 'Mon',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5DC),
        elevation: 0,
        title: const Text(
          'Chats',
          style: TextStyle(
            color: Color(0xFFA0522D),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: chats.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                16,
                10,
                16,
                20,
              ),
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];

                return _buildChatTile(
                  context,
                  chat,
                );
              },
            ),
    );
  }

  Widget _buildChatTile(
    BuildContext context,
    Map<String, String> chat,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              sellerName: chat['buyer']!,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [

            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: const Color(0xFFF4A460),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: Color(0xFFA0522D),
                size: 27,
              ),
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    chat['item']!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFA0522D),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'Buyer: ${chat['buyer']}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE35336),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    chat['message']!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8B6B5A),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Text(
              chat['time']!,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFFB9A69A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
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
              Icons.chat_bubble_outline,
              size: 48,
              color: Color(0xFFA0522D),
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'No Chats Yet',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Color(0xFFA0522D),
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            'Buyer conversations will appear here.',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF8B6B5A),
            ),
          ),
        ],
      ),
    );
  }
}