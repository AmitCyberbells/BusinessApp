import 'package:business_app/screens/constants.dart';
import 'package:flutter/material.dart';

class CreateContestScreen extends StatelessWidget {
  const CreateContestScreen({super.key});

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
                        AlwaysStoppedAnimation<Color>(Color(0xFF0D5C6C)),
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
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 16),
            const Text("Contest Name",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 8),
            customTextField(
              hintText: 'Contest Name',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Contest Name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            const Text("Contest Description",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 8),
            customTextField(
              hintText: 'Type Description',
              // controller: _businessNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Type Description';
                }
                return null;
              },
            ),
            const SizedBox(height: 4),
            const Text("0/120 characters used",
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 20),
            const Text("Contest Banner/Image",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {},
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Image(
                        image: AssetImage('assets/images/upload.png'),
                        width: 32,
                        height: 32,
                        color: Color(0xFF0D5C6C),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Upload Image\n500*500",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _buildDateField(context, "Start Date")),
                const SizedBox(width: 16),
                Expanded(child: _buildDateField(context, "End Date")),
              ],
            ),
            const SizedBox(height: 4),
            Text(
                "Your promo will start on 1 March, 2025. You can stop this offer at any time.",
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
            const SizedBox(height: 4),
            Text(
                "Your promo will end on 1 May, 2025. You can stop this offer at any time.",
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildTimeField(context, "Start Time")),
                const SizedBox(width: 16),
                Expanded(child: _buildTimeField(context, "End Time")),
              ],
            ),
            const SizedBox(height: 4),
            Text("Your promo will start on 1 March, 2025 at 04:00 pm.",
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
            const SizedBox(height: 4),
            Text("Your promo will end on 1 May, 2025 at 04:30 pm.",
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
            const SizedBox(height: 20),
            customTextField(
              hintText: 'Participation Criteria',
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Participation Criteria';
                }
                return null;
              },
            ),
            const SizedBox(height: 4),
            const Text("0/120 characters used",
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 20),
            customTextField(
              hintText: 'Limit how many people can join',
              maxLines: 1,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Limit';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: "All",
              items: ["All", "Members", "Guests"]
                  .map((e) => DropdownMenuItem(child: Text(e), value: e))
                  .toList(),
              onChanged: (val) {},
              decoration: InputDecoration(
                labelText: "Who Can participate",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D6E82),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                child: const Text("Continue", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField(BuildContext context, String label) {
    return TextField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: Icon(Icons.calendar_today),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onTap: () {
        // showDatePicker here if needed
      },
    );
  }

  Widget _buildTimeField(BuildContext context, String label) {
    return TextField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: Icon(Icons.access_time),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onTap: () {
        // showTimePicker here if needed
      },
    );
  }
}
