import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_list_app/provider/user_provider.dart';

class CustomSearchDelegate extends SearchDelegate<String> {
  final double screenWidth;
  List<dynamic> _filteredData = [];

  CustomSearchDelegate({required this.screenWidth});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, color: Colors.black54),
        onPressed: () {
          query = '';
          showSuggestions(context);  // Reset suggestions on clear
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.black54),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    close(context, query);  // Close search on submit
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    // Show all data when query is empty
    _filteredData = query.isEmpty
        ? userProvider.users
        : userProvider.users.where((user) {
            return user['name']
                .toLowerCase()
                .contains(query.toLowerCase());
          }).toList();

    if (userProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: _filteredData.length,
      itemBuilder: (ctx, index) {
        final user = _filteredData[index];

        return Card(
          color: Colors.lightBlue[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 4,
          margin: EdgeInsets.symmetric(
              vertical: 8.0, horizontal: screenWidth * 0.05),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12.0),
            leading: const CircleAvatar(
              backgroundImage: AssetImage('assets/women.jpg'),
              radius: 30,
            ),
            title: Text(
              user['name'],
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
            subtitle: Text(
              user['email'],
              style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
            ),
          ),
        );
      },
    );
  }
}