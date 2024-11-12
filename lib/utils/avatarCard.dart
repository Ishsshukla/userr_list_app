import 'package:flutter/material.dart';

class AvatarCard extends StatelessWidget {
  final Map<String, String> user;
  final double screenWidth;

  const AvatarCard({required this.user, required this.screenWidth, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlue[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      margin:
          EdgeInsets.symmetric(vertical: 8.0, horizontal: screenWidth * 0.05),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12.0),
        leading: const CircleAvatar(
          backgroundImage: AssetImage(
            'assets/women.png',
          ),
          radius: 30,
        ),
        title: Text(
          user['name']!,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        subtitle: Text(
          user['email']!,
          style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
        ),
      ),
    );
  }
}