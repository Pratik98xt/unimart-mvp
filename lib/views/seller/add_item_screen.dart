import 'package:flutter/material.dart';
import '../payment/payment_screen.dart';
import 'my_listings_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final TextEditingController itemNameController =
      TextEditingController();

  final TextEditingController priceController =
      TextEditingController();

  final TextEditingController descriptionController =
      TextEditingController();

  String? selectedCategory;

  final List<String> categories = [
    'Books',
    'Furniture',
    'Electronics',
    'Clothing',
    'Bags & Accessories',
    'Hostel Essentials',
    'Other',
  ];

  @override
  void dispose() {
    itemNameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

//----------------------------- Payment Function --------------------------------
  Future<void> continueToPayment() async {
  if (itemNameController.text.trim().isEmpty ||
      priceController.text.trim().isEmpty ||
      selectedCategory == null ||
      descriptionController.text.trim().isEmpty || selectedImage == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please fill all the details and select an image'),
      ),
    );
    return;
  }

  final price = double.tryParse(
  priceController.text.trim(),
);

if (price == null || price <= 0) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Please enter a valid price'),
    ),
  );
  return;
}

  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please login again'),
      ),
    );
    return;
  }

  // Dummy ₹5 payment for now
  final paymentSuccessful = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const PaymentScreen(
        paymentType: 'seller',
      ),
    ),
  );

  if (paymentSuccessful != true || !mounted) {
    return;
  }

  try {
  // Create a Firestore document reference first
  final itemRef =

    FirebaseFirestore.instance.collection('items').doc();

  // Save item details in Firestore
  await itemRef.set({
    'sellerId': user.uid,
    'itemName': itemNameController.text.trim(),
    'price': price,
    'category': selectedCategory,
    'description': descriptionController.text.trim(),
    'imageAsset': selectedImage,
    'status': 'pending',
    'createdAt': FieldValue.serverTimestamp(),
  });

  if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Item submitted successfully for admin approval , Item will be listed in 24 Hours',
        ),
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MyListingsScreen(),
      ),
    );
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Failed to submit item: $e',
        ),
      ),
    );
  }
}

String? selectedImage;
final List<String> itemImages = [
  'assets/images/calculator.jpeg',
  'assets/images/books.jpeg',
  
  'assets/images/table.jpeg',
  
  'assets/images/calculator.jpeg',
  'assets/images/bag.webp',
];

void showImageSelector() {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFFF5F5DC),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25),
      ),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          itemCount: itemImages.length,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
          ),
          itemBuilder: (context, index) {
            final image = itemImages[index];

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedImage = image;
                });

                Navigator.pop(context);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      );
    },
  );
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
          'List an Item',
          style: TextStyle(
            color: Color(0xFFA0522D),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Image
            const Text(
              'Item Image',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFFA0522D),
              ),
            ),

            const SizedBox(height: 10),

            GestureDetector(
  onTap: showImageSelector,
  child: Container(
    width: double.infinity,
    height: 180,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: const Color(0xFFE5D8C8),
      ),
    ),
    child: selectedImage == null
        
    ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFFF4A460).withOpacity(0.25),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add_a_photo_outlined,
              size: 32,
              color: Color(0xFFA0522D),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Select an image',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFFA0522D),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Choose from available item images',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFFB9A69A),
            ),
          ),
        ],
      )
    : ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          selectedImage!,
          width: double.infinity,
          height: 180,
          fit: BoxFit.cover,
        ),
      ),
  ),
),

            const SizedBox(height: 22),

            // Item Name
            _buildLabel('Item Name'),

            const SizedBox(height: 8),

            _buildTextField(
              controller: itemNameController,
              hintText: 'e.g. Engineering Mathematics',
              icon: Icons.inventory_2_outlined,
            ),

            const SizedBox(height: 18),

            // Price
            _buildLabel('Price'),

            const SizedBox(height: 8),

            _buildTextField(
              controller: priceController,
              hintText: 'e.g. 250',
              icon: Icons.currency_rupee,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 18),

            // Category
            _buildLabel('Category'),

            const SizedBox(height: 8),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCategory,
                  hint: const Text(
                    'Select a category',
                    style: TextStyle(
                      color: Color(0xFFB9A69A),
                    ),
                  ),
                  isExpanded: true,
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFFA0522D),
                  ),
                  items: categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(
                        category,
                        style: const TextStyle(
                          color: Color(0xFFA0522D),
                          fontSize: 14,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Description
            _buildLabel('Description'),

            const SizedBox(height: 8),

            _buildTextField(
              controller: descriptionController,
              hintText: 'Describe the condition of your item...',
              icon: Icons.description_outlined,
              maxLines: 5,
            ),

            const SizedBox(height: 28),

            // Payment Information
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9E8D7),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Color(0xFFE35336),
                    size: 22,
                  ),

                  const SizedBox(width: 10),

                  const Expanded(
                    child: Text(
                      'A ₹5 listing fee is required before your item can be submitted for admin approval.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: Color(0xFFA0522D),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // Continue Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: continueToPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE35336),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'Continue to Pay ₹5',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Color(0xFFA0522D),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFFB9A69A),
          fontSize: 13,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(
            bottom: 0,
          ),
          child: Icon(
            icon,
            color: const Color(0xFFA0522D),
            size: 21,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
  
}