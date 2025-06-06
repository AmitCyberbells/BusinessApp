import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';

class CreateContest2Screen extends StatefulWidget {
  final Map<String, dynamic> contestData;

  const CreateContest2Screen({Key? key, required this.contestData})
      : super(key: key);

  @override
  _CreateContest2ScreenState createState() => _CreateContest2ScreenState();
}

class _CreateContest2ScreenState extends State<CreateContest2Screen> {
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers = [];
  final TextEditingController _rewardForWinnerController =
      TextEditingController();
  final TextEditingController _rewardForParticipantsController =
      TextEditingController();
  final TextEditingController _rewardForShareController =
      TextEditingController();

  String questionType = 'Multiple Choice Questions';
  String rewardType = 'Points';
  bool isCustomerAnswer = false;

  @override
  void initState() {
    super.initState();
    // Initialize with 4 option controllers
    for (int i = 0; i < 4; i++) {
      _optionControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    _rewardForWinnerController.dispose();
    _rewardForParticipantsController.dispose();
    _rewardForShareController.dispose();
    super.dispose();
  }

  void _addOption() {
    if (_optionControllers.length < 6) {
      setState(() {
        _optionControllers.add(TextEditingController());
      });
    }
  }

  Widget _buildRewardFields() {
    switch (rewardType) {
      case 'Points':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Points for Winner',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _rewardForWinnerController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Example: 50',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Points for Participants',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _rewardForParticipantsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Example: 20',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Points for Share',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _rewardForShareController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Example: 5',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
          ],
        );
      case 'Discount':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Discount for Winner',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _rewardForWinnerController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Example: 20%',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Discount for Participants',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _rewardForParticipantsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Example: 10%',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Discount for Share',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _rewardForShareController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Example: 5%',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
          ],
        );
      case 'Free Item':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Free Item for Winner',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _rewardForWinnerController,
              decoration: InputDecoration(
                hintText: 'Example: Free Coffee',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Free Item for Participants',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _rewardForParticipantsController,
              decoration: InputDecoration(
                hintText: 'Example: Free Coffee',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Free Item for Share',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _rewardForShareController,
              decoration: InputDecoration(
                hintText: 'Example: Free Coffee',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
          ],
        );
      default:
        return Container();
    }
  }

  bool _validateForm() {
    if (_questionController.text.trim().isEmpty) {
      _showError('Please enter a question');
      return false;
    }

    if (!isCustomerAnswer) {
      bool hasEmptyOption = false;
      for (var controller in _optionControllers) {
        if (controller.text.trim().isEmpty) {
          hasEmptyOption = true;
          break;
        }
      }
      if (hasEmptyOption) {
        _showError('Please fill all options');
        return false;
      }
    }

    if (_rewardForWinnerController.text.trim().isEmpty) {
      _showError('Please enter reward for winner');
      return false;
    }

    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showLoading(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(message),
          ],
        ),
      ),
    );
  }

  Future<void> _createContest() async {
    if (!_validateForm()) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('auth_token');

      if (token == null) {
        _showError('Authentication token not found. Please log in.');
        return;
      }

      // Show loading indicator
      _showLoading('Creating contest...');

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://dev.frequenters.com/api/business/contests'),
      );

      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      print('Headers: ${request.headers}'); // Debug log

      // Prepare fields from both screens
      final fields = {
        'name': widget.contestData['name'],
        'description': widget.contestData['description'],
        'status': 'open',
        'start_date': widget.contestData['start_date']?.split('T')[0],
        'end_date': widget.contestData['end_date']?.split('T')[0],
        'start_time': widget.contestData['start_time'],
        'end_time': widget.contestData['end_time'],
        'max_participants': widget.contestData['max_participants'],
        'question_type': isCustomerAnswer ? 'text_answer' : 'multiple_choice',
        'question_field': _questionController.text,
      };

      print('Initial fields: $fields'); // Debug log

      // Add reward fields based on type
      switch (rewardType) {
        case 'Points':
          fields.addAll({
            'reward_type': 'points',
            'winner_points': _rewardForWinnerController.text,
            'participant_points': _rewardForParticipantsController.text,
            'voter_points': _rewardForShareController.text,
          });
          break;
        case 'Discount':
          fields.addAll({
            'reward_type': 'discount',
            'winner_discount': _rewardForWinnerController.text,
            'participant_discount': _rewardForParticipantsController.text,
            'voter_discount': _rewardForShareController.text,
          });
          break;
        case 'Free Item':
          fields.addAll({
            'reward_type': 'free_item',
            'winner_free_item': _rewardForWinnerController.text,
            'participant_free_item': _rewardForParticipantsController.text,
            'voter_free_item': _rewardForShareController.text,
          });
          break;
      }

      print('Fields after reward: $fields'); // Debug log

      // Add options if multiple choice
      if (!isCustomerAnswer) {
        final options = _optionControllers
            .where((controller) => controller.text.isNotEmpty)
            .map((controller) => controller.text)
            .toList();

        fields['options'] = json.encode(options); // Send as JSON string
      }

      print('Fields after options: $fields'); // Debug log

      // Add banner image
      if (widget.contestData['banner_image'] != null) {
        print(
            'Adding banner image: ${widget.contestData['banner_image']}'); // Debug log
        request.files.add(
          await http.MultipartFile.fromPath(
            'banner_image',
            widget.contestData['banner_image']!,
          ),
        );
      }

      // Add all fields to request
      request.fields.addAll(Map<String, String>.from(fields));

      print('Final request fields: ${request.fields}'); // Debug log

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print('Response status: ${response.statusCode}'); // Debug log
      print('Response body: $responseBody'); // Debug log

      // Hide loading indicator
      Navigator.of(context).pop();

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Just go back one screen
        Navigator.pop(context);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contest created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        final errorData = json.decode(responseBody);
        String errorMessage =
            errorData['message'] ?? 'Failed to create contest';
        if (errorData['errors'] != null) {
          errorMessage += '\n' +
              (errorData['errors'] as Map<String, dynamic>).values.join('\n');
        }
        _showError(errorMessage);
      }
    } catch (e, stackTrace) {
      print('Error creating contest: $e'); // Debug log
      print('Stack trace: $stackTrace'); // Debug log

      // Hide loading indicator if showing
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
      _showError('Error creating contest: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Contest Question',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: 3,
                    backgroundColor: Colors.grey.shade200,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Color(0xFF0D5C6C)),
                  ),
                ),
                const Text(
                  "2/2",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Business Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Question Type',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Radio<bool>(
                  value: false,
                  groupValue: isCustomerAnswer,
                  onChanged: (value) {
                    setState(() {
                      isCustomerAnswer = value!;
                    });
                  },
                  activeColor: const Color(0xFF0D5C6C),
                ),
                const Text('Multiple Choice Questions'),
                const SizedBox(width: 16),
                Radio<bool>(
                  value: true,
                  groupValue: isCustomerAnswer,
                  onChanged: (value) {
                    setState(() {
                      isCustomerAnswer = value!;
                    });
                  },
                  activeColor: const Color(0xFF0D5C6C),
                ),
                const Text('Customer can write their own answers'),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Question Field',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _questionController,
              decoration: InputDecoration(
                hintText: 'Example: "What\'s our best-selling coffee?"',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            if (!isCustomerAnswer) ...[
              const SizedBox(height: 16),
              const Text(
                'Answer Options',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              ...List.generate(
                _optionControllers.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TextField(
                    controller: _optionControllers[index],
                    decoration: InputDecoration(
                      hintText: 'Option ${index + 1}',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ),
              ),
              if (_optionControllers.length < 6)
                TextButton(
                  onPressed: _addOption,
                  child: const Text(
                    'Add More Option',
                    style: TextStyle(
                      color: Color(0xFF0D5C6C),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
            const SizedBox(height: 16),
            const Text(
              'Reward Type',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: rewardType,
                  isExpanded: true,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  items: ['Points', 'Discount', 'Free Item']
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      rewardType = value!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildRewardFields(),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Preview Contest',
                      style: TextStyle(
                        color: Color(0xFF0D5C6C),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_validateForm()) {
                        _createContest();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D5C6C),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Create Contest',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
