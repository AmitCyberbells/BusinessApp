import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({Key? key}) : super(key: key);

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _featureController = TextEditingController();
  
  // Map to track expanded/collapsed state of FAQ items
  final Map<String, bool> _expandedItems = {};
  
  // FAQ data
  final List<Map<String, String>> _faqItems = [
    {'title': 'What is Frequenters', 'content': ''},
    {'title': 'What kind of rewards can I redeem my points for?', 'content': ''},
    {'title': 'Can I discover events and offers near me?', 'content': ''},
    {'title': 'How do I get started with Frequenters?', 'content': ''},
    {'title': 'How do I earn rewards on Frequenters?', 'content': ''},
  ];
  
  // Guides data
  final List<Map<String, String>> _guideItems = [
    {'title': 'How do I earn rewards on Frequenters?', 'content': ''},
    {'title': 'How do I get started with Frequenters?', 'content': ''},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _featureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Help Center",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
           icon: Icon(LucideIcons.arrowLeft),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                "What's popping? How can we assist?",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              // Search bar
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // FAQs section
              const Text(
                "FAQ's",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              // FAQ items
              ..._buildFaqItems(_faqItems),
              
              const SizedBox(height: 24),
              // How to "Guides" section
              const Text(
                "How to \"Guides\"",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              // Guide items
              ..._buildFaqItems(_guideItems),
              
              const SizedBox(height: 24),
              // Support options
              Row(
                children: [
                  Expanded(
                    child: _buildSupportOption(
                      icon: Icons.chat_bubble_outline,
                      title: "Chat with us",
                      subtitle: "Get an instant reply",
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSupportOption(
                      icon: Icons.confirmation_number_outlined,
                      title: "Raise a Ticket",
                      subtitle: "Lorem Ipsum text",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Feature suggestion
              const Text(
                "Tell us what new features you want?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _featureController,
                  decoration: const InputDecoration(
                    hintText: 'Suggest a Feature',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                  maxLines: 6,
                ),
              ),
              const SizedBox(height: 24),
              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle submission
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C7A9C),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFaqItems(List<Map<String, String>> items) {
    return items.map((item) {
      final title = item['title'] ?? '';
      _expandedItems.putIfAbsent(title, () => false);
      
      return Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _expandedItems[title] = !(_expandedItems[title] ?? false);
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    _expandedItems[title] ?? false
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
          if (_expandedItems[title] ?? false)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                item['content'] ?? 'Content not available',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
        
        ],
      );
    }).toList();
  }

  Widget _buildSupportOption({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF2C7A9C), size: 28),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}