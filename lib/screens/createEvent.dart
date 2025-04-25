import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({super.key});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  String formatDate(DateTime date) {
    return DateFormat("d MMMM yyyy").format(date);
  }

  String get promoStartText {
    if (startDate == null) return "";
    final formatted = DateFormat("d MMMM, yyyy").format(startDate!);
    return "Your promo will start on $formatted at 04:30 pm. You can stop this offer at any time.";
  }

  String get promoEndText {
    if (endDate == null) return "";
    final formatted = DateFormat("d MMMM, yyyy").format(endDate!);
    return "Your promo will end on $formatted at 04:30 pm. You can stop this offer at any time.";
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
          _startDateController.text = formatDate(picked);
        } else {
          endDate = picked;
          _endDateController.text = formatDate(picked);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title:
            const Text("Event Details", style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height -
                kToolbarHeight -
                16, // Adjust for app bar and padding
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Business Information",
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              _buildTextField("Event Name", initialValue: "Women's day"),
              const SizedBox(height: 16),
              _buildTextField("Event Description", maxLines: 4),
              const SizedBox(height: 24),
              const Text("Event Banner/Image",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.upload_rounded, color: Colors.teal),
                        SizedBox(height: 8),
                        Text("Upload Media",
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                      child: _buildDatePickerField(
                          "Start Date",
                          _startDateController,
                          () => _pickDate(isStart: true))),
                  const SizedBox(width: 16),
                  Expanded(
                      child: _buildDatePickerField("End Date",
                          _endDateController, () => _pickDate(isStart: false))),
                ],
              ),
              const SizedBox(height: 8),
              if (startDate != null)
                Row(
                  children: [
                    SizedBox(
                      width: (MediaQuery.of(context).size.width - 48) /
                          2, // 48 accounts for 16 padding + 16 spacing + 16 padding
                      child: Text(promoStartText,
                          style: const TextStyle(fontSize: 12)),
                    ),
                    if (endDate != null)
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 48) / 2,
                        child: Text(promoEndText,
                            style: const TextStyle(fontSize: 12)),
                      ),
                  ],
                ),
              const SizedBox(height: 8),

              _buildTextField("Venue Name"),
              const SizedBox(height: 16),
              _buildTextField("Venue Location",
                  suffixIcon: Icons.location_on_outlined),
              const SizedBox(height: 16),
              _buildTextField("Total Seats", initialValue: "50"),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D6E82),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    "Publish Event",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text("Preview Event",
                      style: TextStyle(color: Colors.black87)),
                ),
              ),
              // Add a spacer to ensure content overflows and enables scrolling
              const SizedBox(height: 100), // Adjust this value based on content
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label,
      {int maxLines = 1, String? initialValue, IconData? suffixIcon}) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: label,
        suffixIcon: suffixIcon != null ? Icon(suffixIcon, size: 20) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
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
          onTap: onTap, // Make the icon clickable
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(
              'assets/images/date.png',
              width: 20,
              height: 20,
              color: Colors.grey[600],
            ),
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
