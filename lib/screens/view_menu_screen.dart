import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'addmenu1.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewMenuScreen extends StatefulWidget {
  final String businessId;
  const ViewMenuScreen({Key? key, required this.businessId}) : super(key: key);

  @override
  State<ViewMenuScreen> createState() => _ViewMenuScreenState();
}

class _ViewMenuScreenState extends State<ViewMenuScreen> {
  bool _isLoading = true;
  String? _error;
  List<dynamic> _menuItems = [];

  @override
  void initState() {
    super.initState();
    _fetchMenuItems();
  }

  Future<void> _fetchMenuItems() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) {
        print('No auth token found in SharedPreferences');
        setState(() {
          _error = 'Authentication token not found. Please login again.';
          _isLoading = false;
        });
        return;
      }
      final url =
          'https://dev.frequenters.com/api/customer/menu-list?business_id=${widget.businessId}';
      print('Fetching menu items from: ' + url);
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print('Response status: \\${response.statusCode}');
      print('Response body: \\${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final menuData = data['data'];
        if (menuData is Map && menuData['data'] is List) {
          _menuItems = menuData['data'];
        } else if (menuData is List) {
          _menuItems = menuData;
        } else if (menuData is Map) {
          _menuItems = [menuData];
        } else {
          _menuItems = [];
        }
        setState(() {
          _isLoading = false;
        });
      } else {
        print(
            'Failed to load menu items. Status: \\${response.statusCode}, Body: \\${response.body}');
        setState(() {
          _error = 'Failed to load menu items.';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching menu items: \\${e.toString()}');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text('Add Menu List',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child:
                      Text(_error!, style: const TextStyle(color: Colors.red)))
              : _menuItems.isEmpty
                  ? const Center(
                      child: Text(
                        "Looks empty here... Let's add your first item and get started!",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemCount: _menuItems.length,
                      itemBuilder: (context, index) {
                        final item = _menuItems[index];
                        return ListTile(
                          title: Text(item['name'] ?? 'Menu Item'),
                          subtitle: Text(item['description'] ?? ''),
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddMenu1Screen()),
          ).then((_) => _fetchMenuItems());
        },
        backgroundColor: const Color(0xFF176B82),
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }
}
