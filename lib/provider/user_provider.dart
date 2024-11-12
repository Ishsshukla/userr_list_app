import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserProvider with ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  List<dynamic> _users = [];

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<dynamic> get users => _users;

  Future<void> fetchUsers() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    print("Fetching users..."); // Debugging line
    try {
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

      if (response.statusCode == 200) {
        // Successfully fetched data
        print('response================$response');
        final List<dynamic> userData = json.decode(response.body);
        _users = userData;
        print('userData================$userData');
      } else {
        // Handle server errors
        _errorMessage =
            'Failed to load data: Server error with status code ${response.statusCode}';
      }
    } catch (error) {
      // Handle network errors
      _errorMessage = 'No Internet Connection';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}