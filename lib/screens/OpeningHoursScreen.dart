import 'package:flutter/material.dart';

class OpeningHoursScreen extends StatefulWidget {
  const OpeningHoursScreen({super.key});

  @override
  State<OpeningHoursScreen> createState() => _OpeningHoursScreenState();
}

class _OpeningHoursScreenState extends State<OpeningHoursScreen> {
  final List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  final Map<String, bool> isOpen = {};
  final Map<String, bool> isExpanded = {};

  @override
  void initState() {
    super.initState();
    for (var day in weekdays) {
      isOpen[day] = day != 'Saturday' && day != 'Sunday';
      isExpanded[day] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Opening Hours',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Manage Your Operating Hours',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
            child: const Divider(height: 30),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: weekdays.length,
              itemBuilder: (context, index) {
                final day = weekdays[index];
                final open = isOpen[day]!;
                final expanded = isExpanded[day]!;

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () =>
                                setState(() => isExpanded[day] = !expanded),
                            child: Icon(
                              expanded ? Icons.expand_less : Icons.expand_more,
                              size: 22,
                            ),
                          ),
                          Text(
                            day,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          const Text("Open"),
                          Switch(
                            value: open,
                            onChanged: (val) {
                              setState(() => isOpen[day] = val);
                            },
                            activeColor: const Color(0xFF1A5C77),
                            activeTrackColor:
                                const Color(0xFF1A5C77).withOpacity(0.4),
                            thumbColor: MaterialStateProperty.all(Colors.white),
                            inactiveTrackColor: Colors.deepPurple.shade100,
                          ),
                        ],
                      ),

                      if (expanded)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.only(left: 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (open)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    const Text(
                                      "Slot 1",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "09:15 AM to 06:30 PM",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          children: const [
                                            Icon(Icons.access_time, size: 16),
                                            SizedBox(width: 4),
                                            Text(
                                              "09 hrs 15 mins",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 6),
                              GestureDetector(
                                onTap: () {
                                  // Handle add/edit logic
                                },
                                child: const Text(
                                  "+ Add/Edit Time",
                                  style: TextStyle(
                                    color: Color(0xFF1A5C77),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Divider(),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A5C77),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // Handle continue
                },
                child: const Text("Continue"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
