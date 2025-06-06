import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

Widget _buildDateField({
  required BuildContext context,
  required String label,
  required String value,
  VoidCallback? onTap,
}) {
  return TextField(
    readOnly: true,
    controller: TextEditingController(text: value),
    decoration: InputDecoration(
      labelText: label,
      suffixIcon: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Image.asset(
          'assets/images/calendar.png', // ← your asset icon
          width: 20,
          height: 20,
          color: Colors.grey[600],
        ),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    ),
    onTap: onTap,
  );
}

Widget customTextField({
  TextEditingController? controller,
  required String hintText,
  TextInputType keyboardType = TextInputType.text,
  bool obscureText = false,
  Widget? icon,
  VoidCallback? onIconTap,
  String? Function(String?)? validator,
  void Function(String)? onChanged,
  bool readOnly = false,
  VoidCallback? onTap,
  int maxLines = 1,
}) {
  return SizedBox(
    height: maxLines > 1 ? null : 56,
    child: TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      readOnly: readOnly,
      onTap: onTap,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color.fromRGBO(143, 144, 152, 1)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Color.fromRGBO(197, 198, 204, 1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: Color(0xFF1F5F6B),
            width: 1.5,
          ),
        ),
        suffixIcon: icon != null
            ? (onIconTap != null
                ? GestureDetector(onTap: onIconTap, child: icon)
                : icon)
            : null,
      ),
    ),
  );
}

Widget buildHelpButton({VoidCallback? onPressed}) {
  return Align(
    alignment: Alignment.bottomRight,
    child: SizedBox(
      height: 26,
      child: ElevatedButton.icon(
        icon: Icon(
          LucideIcons.helpCircle,
          color: Colors.white,
          size: 14,
        ),
        label: Text(
          'Help',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(11, 106, 136, 1),
          minimumSize: const Size(60, 26),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        onPressed: onPressed,
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
            Icon(isOpen ? LucideIcons.chevronUp : LucideIcons.chevronDown),
          ],
        ),
      ),
    );
  }
}

class CustomDropdownMenu extends StatelessWidget {
  final List<String> items;
  final String? selectedItem;
  final Function(String) onSelect;

  const CustomDropdownMenu({
    Key? key,
    required this.items,
    required this.selectedItem,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 60,
            offset: Offset(6, 6),
          ),
        ],
      ),
      child: ListView.separated(
        padding: const EdgeInsets.all(14),
        shrinkWrap: true,
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(height: 9),
        itemBuilder: (context, index) {
          final item = items[index];
          final isSelected = selectedItem == item;

          return InkWell(
            onTap: () => onSelect(item),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              decoration: BoxDecoration(
                color:
                    isSelected ? const Color(0xFFEAF5F7) : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  // Circular icon
                  Container(
                    width: 21,
                    height: 21,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF1F5F6B)
                            : Colors.grey.shade700,
                        width: 2.5,
                      ),
                    ),
                    child: isSelected
                        ? Center(
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF1F5F6B),
                              ),
                            ),
                          )
                        : null,
                  ),

                  const SizedBox(width: 10),

                  // Label text
                  Text(
                    item,
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFF1F5F6B)
                          : Colors.grey.shade700,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                      fontSize: isSelected ? 15 : 14,
                      letterSpacing: isSelected ? 0.1 : 0,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class AppConstants {
  // Reusable full-width button
  static Widget fullWidthButton({
    required VoidCallback onPressed,
    required String text,
    Color backgroundColor = const Color.fromRGBO(11, 106, 136, 1),
    Color textColor = Colors.white,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w500,
    double height = 46,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(12)),
  }) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }
}
