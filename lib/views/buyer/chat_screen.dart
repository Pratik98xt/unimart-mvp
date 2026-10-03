import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String sellerName;

  const ChatScreen({
    super.key,
    this.sellerName = 'Rahul',
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController =
      TextEditingController();

  final List<Map<String, dynamic>> messages = [
    {
      'message': 'Hi, is this book still available?',
      'isMe': true,
    },
    {
      'message': 'Yes, it is available.',
      'isMe': false,
    },
    {
      'message': 'Can I collect it tomorrow?',
      'isMe': true,
    },
  ];

  void sendMessage() {
    final message = messageController.text.trim();

    if (message.isEmpty) return;

    setState(() {
      messages.add({
        'message': message,
        'isMe': true,
      });
    });

    messageController.clear();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
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

        title: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFE35336),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),

            const SizedBox(width: 10),

            Text(
              widget.sellerName,
              style: const TextStyle(
                color: Color(0xFFA0522D),
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [

          // Messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                16,
                10,
                16,
                20,
              ),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];

                return _buildMessageBubble(
                  message['message'],
                  message['isMe'],
                );
              },
            ),
          ),

          // Message Input
          Container(
            padding: const EdgeInsets.fromLTRB(
              12,
              10,
              12,
              14,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              children: [

                Expanded(
                  child: TextField(
                    controller: messageController,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) {
                      sendMessage();
                    },
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: const TextStyle(
                        color: Color(0xFFB9A69A),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF9F5E9),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                GestureDetector(
                  onTap: sendMessage,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE35336),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 21,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(
    String message,
    bool isMe,
  ) {
    return Align(
      alignment:
          isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 280,
        ),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          color: isMe
              ? const Color(0xFFE35336)
              : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isMe ? 18 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 18),
          ),
          boxShadow: [
            if (!isMe)
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: Text(
          message,
          style: TextStyle(
            fontSize: 14,
            height: 1.4,
            color: isMe
                ? Colors.white
                : const Color(0xFFA0522D),
          ),
        ),
      ),
    );
  }
}