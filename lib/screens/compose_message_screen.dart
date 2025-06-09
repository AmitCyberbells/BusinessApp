import 'package:flutter/material.dart';
import 'package:business_app/screens/chat_detail_screen.dart';
import 'package:business_app/services/chat_service.dart';

class ComposeMessageScreen extends StatefulWidget {
  const ComposeMessageScreen({Key? key}) : super(key: key);

  @override
  State<ComposeMessageScreen> createState() => _ComposeMessageScreenState();
}

class _ComposeMessageScreenState extends State<ComposeMessageScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _allowChat = false;
  bool _enableButtons = false;
  String _selectedAudience = 'FREQUENT'; // Default selected audience
  bool _isSending = false;

  // Map UI audience values to API values
  String _getGroupTarget() {
    switch (_selectedAudience) {
      case 'NEW':
        return 'new';
      case 'REGULAR':
        return 'regular';
      case 'FREQUENT':
        return 'daily';
      default:
        return 'daily';
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  String _getMessageText() {
    return '🎉 Special Offer Just for You!\n'
        'Flat 20% off your next coffee order!\n\n'
        'Claim it now and make your next visit extra special! 💥';
  }

  Future<void> _sendMessage() async {
    if (_isSending) return;

    setState(() {
      _isSending = true;
    });

    try {
      final success = await ChatService.sendMessage(
        messageText: _getMessageText(),
        groupTarget: _getGroupTarget(),
        chatEnabled: _allowChat,
        enableButtons: _enableButtons,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Message sent successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back to previous screen after successful send
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to send message. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send message: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2F6D88),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Write your message here',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Write you message',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: '🎉 Special Offer Just for You!\n',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: 'Flat 20% off your next coffee order!\n\n',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text:
                                'Claim it now and make your next visit extra special! 💥',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Send to',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildAudienceChip('NEW', _selectedAudience == 'NEW'),
                  const SizedBox(width: 8),
                  _buildAudienceChip('REGULAR', _selectedAudience == 'REGULAR'),
                  const SizedBox(width: 8),
                  _buildAudienceChip(
                      'FREQUENT', _selectedAudience == 'FREQUENT'),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Allow chat',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Switch(
                    value: _allowChat,
                    onChanged: (value) {
                      setState(() {
                        _allowChat = value;
                      });
                    },
                    activeColor: const Color(0xFF2F6D88),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Enable Buttons',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Switch(
                    value: _enableButtons,
                    onChanged: (value) {
                      setState(() {
                        _enableButtons = value;
                      });
                    },
                    activeColor: const Color(0xFF2F6D88),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (_enableButtons) ...[
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle Accept Offer
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2F6D88),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Accept Offer',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle Decline
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDC3545),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Decline',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
              OutlinedButton(
                onPressed: () {
                  // Handle Preview
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF2F6D88),
                  side: const BorderSide(color: Color(0xFF2F6D88)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Preview'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isSending ? null : _sendMessage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2F6D88),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isSending
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Send Message',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAudienceChip(String label, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedAudience = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2F6D88) : const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
