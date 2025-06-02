import 'package:flutter/material.dart';

class CollaborationListScreen extends StatelessWidget {
  const CollaborationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF005B71),
        onPressed: () {},
        child: const Icon(Icons.add, size: 30),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Collaboration List', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sectionTitle('Collaborations Invite'),
            inviteCard(),

            const SizedBox(height: 16),
            sectionTitle('Ongoing Collaborations'),
            collaborationCard(),
            const SizedBox(height: 10),
            collaborationCard(),

            const SizedBox(height: 16),
            sectionTitle('Previous Collaborations'),
            collaborationCard(isPrevious: true),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget inviteCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'Business Name: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: 'Cafe Coffee Day\n'),
                      TextSpan(text: 'Owner Name: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: 'Joseph Clark'),
                    ],
                  ),
                ),
              ),
              Chip(
                backgroundColor: Color(0xFFE5F4F8),
                label: Text('Status: Pending', style: TextStyle(color: Color(0xFF007E9E))),
              )
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Description: Lorem Ipsum is simply dummy text of the printing and typesetting industry...',
            style: TextStyle(color: Colors.black87),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF005B71),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Center(child: Text('View Details')),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'Start Date\n', style: TextStyle(color: Colors.grey)),
                    TextSpan(text: '03Apr 25', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'End Date\n', style: TextStyle(color: Colors.grey)),
                    TextSpan(text: '03Apr 25', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget collaborationCard({bool isPrevious = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: 'Business Name: ', style: TextStyle(fontWeight: FontWeight.bold)),
                const TextSpan(text: 'Cafe Coffee Day\n'),
                TextSpan(
                  text: isPrevious ? 'Owner/partner Name: ' : 'Owner Name: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: 'Joseph Clark'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF005B71),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Center(child: Text('Collaborate Again')),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'Start Date\n', style: TextStyle(color: Colors.grey)),
                    TextSpan(text: '03Apr 25', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'End Date\n', style: TextStyle(color: Colors.grey)),
                    TextSpan(text: '03Apr 25', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
