import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_list_app/provider/user_provider.dart';
import 'package:user_list_app/screens/search_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Fetch users when the screen initializes
    Provider.of<UserProvider>(context, listen: false).fetchUsers();
  }

  Future<void> _refreshUsers() async {
    await Provider.of<UserProvider>(context, listen: false).fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final users = userProvider.users
        .where((user) =>
            user['name'].toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User List',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () async {
              final query = await showSearch<String>(
                context: context,
                delegate: CustomSearchDelegate(screenWidth: screenWidth),
              );
              if (query != null) {
                setState(() {
                  _searchQuery = query;
                });
              }
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.blueGrey[50],
        padding: const EdgeInsets.all(8.0),
        child: userProvider.isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.blueAccent,
                  strokeWidth: 5,
                ),
              )
            : userProvider.errorMessage.isNotEmpty
                ? Center(
                    child: Text(
                      userProvider.errorMessage,
                      style: const TextStyle(fontSize: 18, color: Colors.red),
                    ),
                  )
                : users.isEmpty
                    ? const Center(
                        child: Text(
                          "No users found.",
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _refreshUsers,
                        child: ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (ctx, index) {
                            final user = users[index];
                            return Card(
                              color: Colors.lightBlue[100],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 4,
                              margin: EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: screenWidth * 0.05),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(12.0),
                                leading: const CircleAvatar(
                                  backgroundImage: AssetImage(
                                    'assets/women.jpg',
                                  ),
                                  radius: 30,
                                ),
                                title: Text(
                                  user['name'],
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87),
                                ),
                                subtitle: Text(
                                  user['email'],
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.blueGrey),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          setState(() {
            _searchQuery = ''; // Reset search query
          });
          userProvider.fetchUsers(); // Refresh user data
        },
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}