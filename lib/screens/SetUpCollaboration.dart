import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';

class SetUpCollaboration extends StatefulWidget {
  @override
  _SetUpCollaborationState createState() => _SetUpCollaborationState();
}

class _SetUpCollaborationState extends State<SetUpCollaboration> {
  DateTime? startDate;
  DateTime? endDate;
  bool termsAccepted = false;
  String? selectedAudience = 'Demographics, Interests';

  // Function to show date picker
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime currentDate = DateTime.now();
    DateTime initialDate =
        isStartDate ? (startDate ?? currentDate) : (endDate ?? currentDate);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            // Wrap the entire Column in SingleChildScrollView
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with back button and title
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade100,
                      ),
                      child: IconButton(
                        icon: Icon(LucideIcons.arrowLeft),
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: const Text(
                          'Set Up Collaboration',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 40), // Empty space to balance the layout
                  ],
                ),

                SizedBox(height: 24),

                // Collaboration Details
                const Text(
                  'Collaboration Details',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(0, 0, 0, 0.541),
                  ),
                ),
                SizedBox(height: 24),

                // Content wrapped in a column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Describe your collaboration request',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'We are looking for ...',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                      ),
                      maxLines: 6,
                    ),

                    const SizedBox(height: 24),
                    const Text(
                      'Set Duration',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Date Row
                    Row(
                      children: [
                        // Start Date
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Campaign Start Date',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 50,
                                child: TextFormField(
                                  readOnly: true,
                                  controller: TextEditingController(
                                    text: startDate != null
                                        ? DateFormat('d MMMM yyyy')
                                            .format(startDate!)
                                        : 'Select Date',
                                       
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300),
                                    ),
                                    suffixIcon: const Icon(Icons.calendar_today,
                                        color: Colors.grey),
                                  ),
                                  onTap: () => _selectDate(context, true),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 16),

                        // End Date
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Campaign End Date',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 50,
                                child: TextFormField(
                                  readOnly: true,
                                  controller: TextEditingController(
                                    text: endDate != null
                                        ? DateFormat('d MMMM yyyy')
                                            .format(endDate!)
                                        : 'Select Date',
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300),
                                    ),
                                    suffixIcon: const Icon(Icons.calendar_today,
                                        color: Colors.grey),
                                  ),
                                  onTap: () => _selectDate(context, false),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Promo message (Only shows if both dates are selected)
                    if (startDate != null && endDate != null)
                      _buildPromoMessage(startDate!, endDate!),

                    const SizedBox(height: 24),

                    // Target Audience Dropdown
                    const Text(
                      'Target Audience',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color.from(alpha: 0.867, red: 0, green: 0, blue: 0)),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      value: selectedAudience,
                      items: ['Demographics, Interests']
                          .map((value) => DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedAudience = value;
                        });
                      },
                    ),

                    const SizedBox(height: 24),
                  ],
                ),

                // Create Button (Ensure it is always at the bottom)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: termsAccepted ? () {} : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1F6E8C),
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      disabledBackgroundColor: Colors.grey.shade400,
                    ),


                    
                    child: const Text(
                      'Create',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// Function to format the promo message
  Widget _buildPromoMessage(DateTime start, DateTime end) {
    String formattedStartDate = DateFormat('d MMMM, yyyy').format(start);
    String formattedEndDate = DateFormat('d MMMM, yyyy').format(end);
    String time = "04:30 pm"; // Static time as per your screenshot

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 14),
            children: [
              const TextSpan(text: 'Your promo will start on '),
              TextSpan(
                text: formattedStartDate,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: ' at ',
              ),
              TextSpan(
                text: time,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: '. You can stop this offer at any time.'),
            ],
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 14),
            children: [
              const TextSpan(text: 'Your promo will end on '),
              TextSpan(
                text: formattedEndDate,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: ' at ',
              ),
              TextSpan(
                text: time,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: '. You can stop this offer at any time.'),
            ],
          ),
        ),
      ],
    );
  }
}
