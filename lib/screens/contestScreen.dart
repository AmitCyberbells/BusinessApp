import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // For File handling

class AppConstants {
  static Widget fullWidthButton({
    required VoidCallback onPressed,
    required String text,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor:
              text == 'Create Contest' ? Colors.white : Colors.black,
          backgroundColor:
              text == 'Create Contest' ? Colors.blue : Colors.grey.shade200,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(text),
      ),
    );
  }
}

Widget customTextField({
  required String hintText,
  TextEditingController? controller,
  String? Function(String?)? validator,
  int maxLines = 1,
}) {
  return TextField(
    controller: controller,
    maxLines: maxLines,
    decoration: InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}

class CustomDropdown extends StatelessWidget {
  final String? selectedItem;
  final String hintText;
  final bool isOpen;
  final VoidCallback onTap;

  const CustomDropdown({
    Key? key,
    required this.selectedItem,
    required this.hintText,
    required this.isOpen,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedItem ?? hintText,
              style: TextStyle(
                color:
                    selectedItem != null ? Colors.black : Colors.grey.shade500,
                fontWeight:
                    selectedItem != null ? FontWeight.w500 : FontWeight.normal,
                fontSize: 16,
                letterSpacing: 0,
              ),
            ),
            Icon(isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}

class ContestScreen extends StatefulWidget {
  @override
  _ContestScreenState createState() => _ContestScreenState();
}

class _ContestScreenState extends State<ContestScreen> {
  String? _selectedQuestionType = 'Question Type';
  String? _selectedRewardType = 'Reward Type';
  bool _isQuestionTypeOpen = false;
  bool _isRewardTypeOpen = false;
  File? _bannerImageFile;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? closeStartDate;
  DateTime? closeEndDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  TimeOfDay? closeStartTime;
  TimeOfDay? closeEndTime;

  final TextEditingController _questionFieldController =
      TextEditingController();
  final TextEditingController _option1Controller = TextEditingController();
  final TextEditingController _option2Controller = TextEditingController();
  final TextEditingController _option3Controller = TextEditingController();
  final TextEditingController _option4Controller = TextEditingController();
  final TextEditingController _contestNameController = TextEditingController();
  final TextEditingController _contestDescriptionController =
      TextEditingController();
  final TextEditingController _closeContestNameController =
      TextEditingController();
  final TextEditingController _closeDescriptionController =
      TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _closeStartDateController =
      TextEditingController();
  final TextEditingController _closeEndDateController = TextEditingController();
  final TextEditingController _closeStartTimeController =
      TextEditingController();
  final TextEditingController _closeEndTimeController = TextEditingController();

  final TextEditingController _winnerPointsController = TextEditingController();
  final TextEditingController _participantPointsController =
      TextEditingController();
  final TextEditingController _voterPointsController = TextEditingController();
  final TextEditingController _winnerDiscountController =
      TextEditingController();
  final TextEditingController _participantDiscountController =
      TextEditingController();
  final TextEditingController _voterDiscountController =
      TextEditingController();
  final TextEditingController _winnerFreeItemController =
      TextEditingController();
  final TextEditingController _participantFreeItemController =
      TextEditingController();
  final TextEditingController _voterFreeItemController =
      TextEditingController();

  // Data from CreateContestScreen
  Map<String, dynamic>? _contestData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _contestData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (_contestData != null) {
      _contestNameController.text = _contestData!['name'] ?? '';
      _contestDescriptionController.text = _contestData!['description'] ?? '';

      // Handle dates
      startDate = _contestData!['start_date'] != null
          ? DateTime.parse(_contestData!['start_date'])
          : DateTime(2025, 3, 1);
      endDate = _contestData!['end_date'] != null
          ? DateTime.parse(_contestData!['end_date'])
          : DateTime(2025, 5, 1);

      // Handle times
      final startTimeStr = _contestData!['start_time'] as String? ?? "16:30";
      final endTimeStr = _contestData!['end_time'] as String? ?? "16:30";

      final startTimeParts = startTimeStr.split(':');
      final endTimeParts = endTimeStr.split(':');

      startTime = TimeOfDay(
          hour: int.parse(startTimeParts[0]),
          minute: int.parse(startTimeParts[1]));
      endTime = TimeOfDay(
          hour: int.parse(endTimeParts[0]), minute: int.parse(endTimeParts[1]));

      // Update controllers with formatted values
      _startDateController.text = DateFormat('d MMMM yyyy').format(startDate!);
      _endDateController.text = DateFormat('d MMMM yyyy').format(endDate!);
      _startTimeController.text = startTime!.format(context);
      _endTimeController.text = endTime!.format(context);

      // Set default values for closed contest
      closeStartDate = DateTime(2025, 3, 1);
      closeEndDate = DateTime(2025, 5, 1);
      closeStartTime = const TimeOfDay(hour: 16, minute: 30);
      closeEndTime = const TimeOfDay(hour: 16, minute: 30);
      _closeStartDateController.text = '1 March 2025';
      _closeEndDateController.text = '1 May 2025';
      _closeStartTimeController.text = closeStartTime!.format(context);
      _closeEndTimeController.text = closeEndTime!.format(context);
    }
  }

  @override
  void dispose() {
    _questionFieldController.dispose();
    _option1Controller.dispose();
    _option2Controller.dispose();
    _option3Controller.dispose();
    _option4Controller.dispose();
    _contestNameController.dispose();
    _contestDescriptionController.dispose();
    _closeContestNameController.dispose();
    _closeDescriptionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _closeStartDateController.dispose();
    _closeEndDateController.dispose();
    _closeStartTimeController.dispose();
    _closeEndTimeController.dispose();

    _winnerPointsController.dispose();
    _participantPointsController.dispose();
    _voterPointsController.dispose();
    _winnerDiscountController.dispose();
    _participantDiscountController.dispose();
    _voterDiscountController.dispose();
    _winnerFreeItemController.dispose();
    _participantFreeItemController.dispose();
    _voterFreeItemController.dispose();

    super.dispose();
  }

  String get promoStartText {
    if (startDate == null || startTime == null) return "";
    final formattedDate = DateFormat("d MMMM yyyy").format(startDate!);
    final formattedTime = startTime!.format(context);
    return "Your promo will start on $formattedDate at $formattedTime. You can stop this offer at any time.";
  }

  String get promoEndText {
    if (endDate == null || endTime == null) return "";
    final formattedDate = DateFormat("d MMMM yyyy").format(endDate!);
    final formattedTime = endTime!.format(context);
    return "Your promo will end on $formattedDate at $formattedTime. You can stop this offer at any time.";
  }

  String get closePromoStartText {
    if (closeStartDate == null || closeStartTime == null) return "";
    final formattedDate = DateFormat("d MMMM yyyy").format(closeStartDate!);
    final formattedTime = closeStartTime!.format(context);
    return "Your closed promo will start on $formattedDate at $formattedTime.";
  }

  String get closePromoEndText {
    if (closeEndDate == null || closeEndTime == null) return "";
    final formattedDate = DateFormat("d MMMM yyyy").format(closeEndDate!);
    final formattedTime = closeEndTime!.format(context);
    return "Your closed promo will end on $formattedDate at $formattedTime.";
  }

  Widget _buildDatePickerField(
      String label, TextEditingController controller, VoidCallback onTap) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child:
                Icon(Icons.calendar_today, color: Colors.grey[600], size: 20),
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildTimePickerField(
      String label, TextEditingController controller, VoidCallback onTap) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(Icons.access_time, color: Colors.grey[600], size: 20),
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _pickDate({required bool isStart, required bool isClose}) async {
    DateTime initialDate = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    String formatDate(DateTime date) {
      return DateFormat("d MMMM yyyy").format(date);
    }

    if (picked != null) {
      setState(() {
        if (isClose) {
          if (isStart) {
            closeStartDate = picked;
            _closeStartDateController.text = formatDate(picked);
          } else {
            closeEndDate = picked;
            _closeEndDateController.text = formatDate(picked);
          }
        } else {
          if (isStart) {
            startDate = picked;
            _startDateController.text = formatDate(picked);
          } else {
            endDate = picked;
            _endDateController.text = formatDate(picked);
          }
        }
      });
    }
  }

  Future<void> _pickTime({required bool isStart, required bool isClose}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        if (isClose) {
          if (isStart) {
            closeStartTime = picked;
            _closeStartTimeController.text = picked.format(context);
          } else {
            closeEndTime = picked;
            _closeEndTimeController.text = picked.format(context);
          }
        } else {
          if (isStart) {
            startTime = picked;
            _startTimeController.text = picked.format(context);
          } else {
            endTime = picked;
            _endTimeController.text = picked.format(context);
          }
        }
      });
    }
  }

  String _formatTimeOfDayTo24Hour(TimeOfDay? time) {
    if (time == null) return "16:30:00";
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute:00";
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _bannerImageFile = File(pickedFile.path);
        print('DEBUG: Image selected: ${pickedFile.path}');
      });
    } else {
      print('DEBUG: No image selected.');
    }
  }

  Future<void> _createContest() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('auth_token');

      if (token == null) {
        _showError('Authentication token not found. Please log in.');
        return;
      }

      if (_bannerImageFile == null) {
        _showError('Please select a banner image');
        return;
      }

      // Validate required fields
      if (_contestNameController.text.isEmpty) {
        _showError('Contest name is required');
        return;
      }

      if (_questionFieldController.text.isEmpty) {
        _showError('Question field is required');
        return;
      }

      if (_selectedQuestionType == null) {
        _showError('Please select a question type');
        return;
      }

      if (_selectedRewardType == null) {
        _showError('Please select a reward type');
        return;
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://dev.frequenters.com/api/business/contests'),
      );

      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      // Log request headers in UI
      _showLog('Request Headers:', {
        'Authorization':
            'Bearer ${token.substring(0, 10)}...', // Show partial token for security
        'Accept': 'application/json',
      });

      // Prepare form fields
      final fields = {
        'name': _contestNameController.text,
        'description': _contestDescriptionController.text,
        'status': 'open',
        'start_date': DateFormat('yyyy-MM-dd').format(startDate!),
        'end_date': DateFormat('yyyy-MM-dd').format(endDate!),
        'start_time': _formatTimeOfDayTo24Hour(startTime),
        'end_time': _formatTimeOfDayTo24Hour(endTime),
        'max_participants':
            (_contestData?['max_participants'] ?? '100').toString(),
        'reward_type': _selectedRewardType?.toLowerCase() ?? 'points',
        'close_description': _closeDescriptionController.text,
        'close_start_date': DateFormat('yyyy-MM-dd').format(closeStartDate!),
        'close_end_date': DateFormat('yyyy-MM-dd').format(closeEndDate!),
        'close_start_time': _formatTimeOfDayTo24Hour(closeStartTime),
        'close_end_time': _formatTimeOfDayTo24Hour(closeEndTime),
        'question_type': _selectedQuestionType == 'Multiple Choice Questions'
            ? 'multiple_choice'
            : 'text_answer',
        'question_field': _questionFieldController.text,
        'business_id': '65', // This should come from user's business profile
      };

      // Add reward-specific fields based on type
      if (_selectedRewardType == 'Points') {
        fields.addAll({
          'winner_points': _winnerPointsController.text,
          'participant_points': _participantPointsController.text,
          'voter_points': _voterPointsController.text,
        });
      } else if (_selectedRewardType == 'Discount') {
        fields.addAll({
          'winner_discount': _winnerDiscountController.text,
          'participant_discount': _participantDiscountController.text,
          'voter_discount': _voterDiscountController.text,
        });
      } else if (_selectedRewardType == 'Free Item') {
        fields.addAll({
          'winner_free_item': _winnerFreeItemController.text,
          'participant_free_item': _participantFreeItemController.text,
          'voter_free_item': _voterFreeItemController.text,
        });
      }

      // Add options if multiple choice
      if (_selectedQuestionType == 'Multiple Choice Questions') {
        fields['options[0]'] = _option1Controller.text;
        fields['options[1]'] = _option2Controller.text;
        fields['options[2]'] = _option3Controller.text;
        fields['options[3]'] = _option4Controller.text;
      }

      // Add all fields to request
      request.fields.addAll(fields);

      // Log request fields in UI
      _showLog('Request Fields:', fields);

      // Add banner image
      request.files.add(
        await http.MultipartFile.fromPath(
          'banner_image',
          _bannerImageFile!.path,
        ),
      );

      _showLog('Uploading banner image:', {'path': _bannerImageFile!.path});

      // Show loading indicator
      _showLoading('Creating contest...');

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      // Hide loading indicator
      Navigator.of(context).pop(); // Remove loading dialog

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSuccess('Contest created successfully!');

        // Log success response
        _showLog('Response:', {
          'status': response.statusCode.toString(),
          'body': responseBody,
        });

        Navigator.pop(context); // Return to previous screen
      } else {
        final errorData = json.decode(responseBody);
        _showLog('Error Response:', {
          'status': response.statusCode.toString(),
          'error': errorData,
        });

        // Show detailed error dialog
        _showErrorDialog(
            'Contest Creation Failed',
            errorData is Map
                ? _formatErrorMessage(errorData)
                : 'Server returned status code: ${response.statusCode}');

        throw Exception(errorData['error'] ?? 'Failed to create contest');
      }
    } catch (e) {
      _showErrorDialog(
          'Error Creating Contest', e.toString().replaceAll('Exception: ', ''));
    }
  }

  String _formatErrorMessage(Map<dynamic, dynamic> errorData) {
    StringBuffer message = StringBuffer();

    // Add main error message if exists
    if (errorData['error'] != null) {
      message.writeln('Error: ${errorData['error']}');
    }

    // Add validation errors if they exist
    if (errorData['errors'] != null && errorData['errors'] is Map) {
      message.writeln('\nValidation Errors:');
      (errorData['errors'] as Map).forEach((key, value) {
        if (value is List) {
          message.writeln('• $key: ${value.join(', ')}');
        } else {
          message.writeln('• $key: $value');
        }
      });
    }

    // Add any additional details
    if (errorData['details'] != null) {
      message.writeln('\nDetails: ${errorData['details']}');
    }

    return message.toString();
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(color: Colors.red),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message),
                SizedBox(height: 16),
                Text(
                  'Please check the following:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('• All required fields are filled\n'
                    '• Image is properly selected\n'
                    '• Dates and times are valid\n'
                    '• Question type and options are properly set\n'
                    '• Reward type and values are properly set'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('View Details in Console'),
              onPressed: () {
                Navigator.of(context).pop();
                _showLog('Last Error Details:', {
                  'title': title,
                  'message': message,
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showLog(String title, Map<String, dynamic> data) {
    // First, print to console
    print('\n=== $title ===');
    data.forEach((key, value) {
      if (value is Map) {
        print('$key:');
        value.forEach((k, v) => print('  $k: $v'));
      } else {
        print('$key: $value');
      }
    });
    print('================\n');

    // Then show in UI if it's an error
    if (title.toLowerCase().contains('error')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$title - Check console for details'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
          action: SnackBarAction(
            label: 'DISMISS',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }

  void _showLoading(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text(message),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Contest Question'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Business Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Question Type',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            CustomDropdown(
              selectedItem: _selectedQuestionType,
              hintText: 'Question Type',
              isOpen: _isQuestionTypeOpen,
              onTap: () {
                setState(() {
                  _isQuestionTypeOpen = !_isQuestionTypeOpen;
                });
              },
            ),
            if (_isQuestionTypeOpen)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text('Multiple Choice Questions'),
                      onTap: () {
                        setState(() {
                          _selectedQuestionType = 'Multiple Choice Questions';
                          _isQuestionTypeOpen = false;
                        });
                      },
                    ),
                    ListTile(
                      title: Text('Customers can write their own answers'),
                      onTap: () {
                        setState(() {
                          _selectedQuestionType =
                              'Customers can write their own answers';
                          _isQuestionTypeOpen = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 10),
            Text(
              'Question Field',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            customTextField(
              hintText: 'What\'s our best-selling coffee?',
              controller: _questionFieldController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter question?';
                }
                return null;
              },
            ),
            // Show Answer Options only if "Multiple Choice Questions" is selected
            if (_selectedQuestionType == 'Multiple Choice Questions') ...[
              SizedBox(height: 10),
              Text(
                'Answer Options',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              customTextField(
                hintText: 'Option 1',
                controller: _option1Controller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter option?';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              customTextField(
                hintText: 'Option 2',
                controller: _option2Controller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter option?';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              customTextField(
                hintText: 'Option 3',
                controller: _option3Controller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter option?';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              customTextField(
                hintText: 'Option 4',
                controller: _option4Controller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter option?';
                  }
                  return null;
                },
              ),
              TextButton(
                onPressed: () {},
                child: Text('Add More Option'),
              ),
            ],
            SizedBox(height: 20),
            Text(
              'Reward Type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            CustomDropdown(
              selectedItem: _selectedRewardType,
              hintText: 'Reward Type',
              isOpen: _isRewardTypeOpen,
              onTap: () {
                setState(() {
                  _isRewardTypeOpen = !_isRewardTypeOpen;
                });
              },
            ),
            if (_isRewardTypeOpen)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text('Points'),
                      onTap: () {
                        setState(() {
                          _selectedRewardType = 'Points';
                          _isRewardTypeOpen = false;
                        });
                      },
                    ),
                    ListTile(
                      title: Text('Discount'),
                      onTap: () {
                        setState(() {
                          _selectedRewardType = 'Discount';
                          _isRewardTypeOpen = false;
                        });
                      },
                    ),
                    ListTile(
                      title: Text('Free Item'),
                      onTap: () {
                        setState(() {
                          _selectedRewardType = 'Free Item';
                          _isRewardTypeOpen = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            // Conditionally show reward fields based on selected reward type
            if (_selectedRewardType == 'Points') ...[
              SizedBox(height: 10),
              Text(
                'Points for Winner',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              customTextField(
                hintText: 'Example: 50',
                controller: _winnerPointsController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter points for winner?';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Text(
                'Points for Participants',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              customTextField(
                hintText: 'Example: 50',
                controller: _participantPointsController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter points for participants?';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Text(
                'Points for Voters',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              customTextField(
                hintText: 'Example: 50',
                controller: _voterPointsController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter points for voters?';
                  }
                  return null;
                },
              ),
            ],
            if (_selectedRewardType == 'Discount') ...[
              SizedBox(height: 10),
              Text(
                'Discount for Winner',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              customTextField(
                hintText: 'Example: 20%',
                controller: _winnerDiscountController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter discount for winner?';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Text(
                'Discount for Participants',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              customTextField(
                hintText: 'Example: 20%',
                controller: _participantDiscountController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter discount for participants?';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Text(
                'Discount for Voters',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              customTextField(
                hintText: 'Example: 20%',
                controller: _voterDiscountController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter discount for voters?';
                  }
                  return null;
                },
              ),
            ],
            if (_selectedRewardType == 'Free Item') ...[
              SizedBox(height: 10),
              Text(
                'Free Item for Winner',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              customTextField(
                hintText: 'Example: Free Coffee',
                controller: _winnerFreeItemController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter free item for winner?';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Text(
                'Free Item for Participants',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              customTextField(
                hintText: 'Example: Free Coffee',
                controller: _participantFreeItemController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter free item for participants?';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Text(
                'Free Item for Voters',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              customTextField(
                hintText: 'Example: Free Coffee',
                controller: _voterFreeItemController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter free item for voters?';
                  }
                  return null;
                },
              ),
            ],
            SizedBox(height: 20),
            Text(
              'Banner Image',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text(_bannerImageFile == null
                  ? 'Select Banner Image'
                  : 'Image Selected'),
            ),
            SizedBox(height: 10),
            if (_bannerImageFile != null)
              Text(
                'Selected Image: ${_bannerImageFile!.path.split('/').last}',
                style: TextStyle(fontSize: 14, color: Colors.green),
              ),
            SizedBox(height: 20),
            Text(
              'Closed Contest',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Contest Name',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            customTextField(
              hintText: 'Contest Name',
              controller: _closeContestNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter contest name?';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            Text(
              'Contest Description',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            customTextField(
              hintText: 'Type Description',
              maxLines: 4,
              controller: _closeDescriptionController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter description?';
                }
                return null;
              },
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDatePickerField(
                        "Start Date",
                        _closeStartDateController,
                        () => _pickDate(isStart: true, isClose: true),
                      ),
                      const SizedBox(height: 18),
                      _buildTimePickerField(
                        "Start Time",
                        _closeStartTimeController,
                        () => _pickTime(isStart: true, isClose: true),
                      ),
                      const SizedBox(height: 8),
                      if (closeStartDate != null)
                        SizedBox(
                          width: (MediaQuery.of(context).size.width - 48) / 2,
                          child: Text(
                            closePromoStartText,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDatePickerField(
                        "End Date",
                        _closeEndDateController,
                        () => _pickDate(isStart: false, isClose: true),
                      ),
                      const SizedBox(height: 18),
                      _buildTimePickerField(
                        "End Time",
                        _closeEndTimeController,
                        () => _pickTime(isStart: false, isClose: true),
                      ),
                      const SizedBox(height: 8),
                      if (closeEndDate != null)
                        SizedBox(
                          width: (MediaQuery.of(context).size.width - 48) / 2,
                          child: Text(
                            closePromoEndText,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            AppConstants.fullWidthButton(
              onPressed: () {},
              text: 'Preview Contest',
            ),
            const SizedBox(height: 16),
            AppConstants.fullWidthButton(
              onPressed: _createContest,
              text: 'Create Contest',
            ),
          ],
        ),
      ),
    );
  }
}
