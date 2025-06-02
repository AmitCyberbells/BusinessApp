import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreateContestScreen extends StatefulWidget {
  const CreateContestScreen({super.key});

  @override
  _CreateContestScreenState createState() => _CreateContestScreenState();
}

class _CreateContestScreenState extends State<CreateContestScreen> {
  final TextEditingController _contestNameController = TextEditingController();
  final TextEditingController _contestDescriptionController =
      TextEditingController();
  final TextEditingController _participationCriteriaController =
      TextEditingController();
  final TextEditingController _maxParticipantsController =
      TextEditingController();
  DateTime? startDate = DateTime(2025, 3, 1);
  DateTime? endDate = DateTime(2025, 5, 1);
  TimeOfDay? startTime = const TimeOfDay(hour: 16, minute: 30);
  TimeOfDay? endTime = const TimeOfDay(hour: 16, minute: 30);
  File? bannerImage;
  String? whoCanParticipate = "All";
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 500,
      maxWidth: 500,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        bannerImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickDate({required bool isStart}) async {
    DateTime initialDate = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  Future<void> _pickTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "1 March 2025";
    final months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }

  String _formatTimeOfDay(TimeOfDay? timeOfDay) {
    if (timeOfDay == null) return "16:30";
    final hours = timeOfDay.hour.toString().padLeft(2, '0');
    final minutes = timeOfDay.minute.toString().padLeft(2, '0');
    return "$hours:$minutes";
  }

  String _formatTimeForDisplay(TimeOfDay? time) {
    if (time == null) return "04:30 PM";
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return "${time.hour > 12 ? time.hour - 12 : time.hour}:${time.minute.toString().padLeft(2, '0')} ${time.hour >= 12 ? 'PM' : 'AM'}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: const Text("Create a Contest",
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
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
                    value: 0.5,
                    strokeWidth: 3,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Color(0xFF0D5C6C)),
                    backgroundColor: Colors.grey.shade300,
                  ),
                ),
                const Text("1 of 2",
                    style: TextStyle(fontSize: 10, color: Colors.black)),
              ],
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text("Business Information",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 16)),
            const SizedBox(height: 16),
            const Text("Contest Name",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 8),
            TextField(
              controller: _contestNameController,
              decoration: InputDecoration(
                hintText: 'Contest Name',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade400)),
              ),
            ),
            const SizedBox(height: 16),
            const Text("Contest Description",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 8),
            TextField(
              controller: _contestDescriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Type Description',
                hintStyle:
                    const TextStyle(color: Color.fromARGB(255, 194, 81, 81)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade400)),
              ),
            ),
            const SizedBox(height: 4),
            const Text("0/120 characters used",
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 20),
            const Text("Contest Banner/Image",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: bannerImage == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.upload,
                                size: 32, color: Color(0xFF0D5C6C)),
                            SizedBox(height: 8),
                            Text(
                              "Upload Image\n500*500",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        )
                      : Image.file(
                          bannerImage!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 150,
                        ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Start Date",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      const SizedBox(height: 8),
                      TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: _formatDate(startDate),
                          hintStyle: const TextStyle(color: Colors.black),
                          suffixIcon:
                              const Icon(Icons.calendar_today, size: 20),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onTap: () => _pickDate(isStart: true),
                      ),
                      const SizedBox(height: 4),
                      Text(
                          "Your promo will start on ${_formatDate(startDate)}. You can stop this offer at any time.",
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("End Date",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      const SizedBox(height: 8),
                      TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: _formatDate(endDate),
                          hintStyle: const TextStyle(color: Colors.black),
                          suffixIcon:
                              const Icon(Icons.calendar_today, size: 20),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onTap: () => _pickDate(isStart: false),
                      ),
                      const SizedBox(height: 4),
                      Text(
                          "Your promo will end on ${_formatDate(endDate)}. You can stop this offer at any time.",
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Start Time",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      const SizedBox(height: 8),
                      TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: _formatTimeForDisplay(startTime),
                          hintStyle: const TextStyle(color: Colors.black),
                          suffixIcon: const Icon(Icons.access_time, size: 20),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onTap: () => _pickTime(isStart: true),
                      ),
                      const SizedBox(height: 4),
                      Text(
                          "Your promo will start on ${_formatDate(startDate)} at ${_formatTimeForDisplay(startTime)}. You can stop this offer at any time.",
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("End Time",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      const SizedBox(height: 8),
                      TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: _formatTimeForDisplay(endTime),
                          hintStyle: const TextStyle(color: Colors.black),
                          suffixIcon: const Icon(Icons.access_time, size: 20),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onTap: () => _pickTime(isStart: false),
                      ),
                      const SizedBox(height: 4),
                      Text(
                          "Your promo will end on ${_formatDate(endDate)} at ${_formatTimeForDisplay(endTime)}. You can stop this offer at any time.",
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text("Entry Rules",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 16)),
            const SizedBox(height: 16),
            const Text("Write the Participation Criteria",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 8),
            TextField(
              controller: _participationCriteriaController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Write the Participation Criteria',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade400)),
              ),
            ),
            const SizedBox(height: 4),
            const Text("0/120 characters used",
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 20),
            const Text("Max Participants",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 8),
            TextField(
              controller: _maxParticipantsController,
              decoration: InputDecoration(
                hintText: 'Limit how many can join ex. 10,20',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade400)),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Who Can Participate",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: whoCanParticipate,
              items: ["All", "Members", "Guests"]
                  .map((e) => DropdownMenuItem(child: Text(e), value: e))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  whoCanParticipate = val;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade400)),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Create the arguments map with explicit typing
                final Map<String, dynamic> arguments = {
                  'name': _contestNameController.text,
                  'description': _contestDescriptionController.text,
                  'start_date': startDate?.toIso8601String() ??
                      DateTime(2025, 3, 1).toIso8601String(),
                  'end_date': endDate?.toIso8601String() ??
                      DateTime(2025, 5, 1).toIso8601String(),
                  'start_time': _formatTimeOfDay(startTime),
                  'end_time': _formatTimeOfDay(endTime),
                  'max_participants':
                      int.tryParse(_maxParticipantsController.text) ?? 100,
                  'banner_image': bannerImage?.path ?? '',
                  'status': whoCanParticipate ?? 'All',
                };

                Navigator.pushNamed(
                  context,
                  '/createContest2',
                  arguments: arguments,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D5C6C),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
