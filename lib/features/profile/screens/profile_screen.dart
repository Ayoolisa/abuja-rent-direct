import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String currentRole;
  final Function(String) onRoleChanged;

  const ProfileScreen({
    super.key,
    this.currentRole = 'tenant',
    required this.onRoleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              'Guest User',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              'Current Role: ${currentRole.toUpperCase()}',
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),

            const SizedBox(height: 40),

            const Text('Switch Role:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => onRoleChanged('tenant'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentRole == 'tenant' ? Colors.blue : Colors.blueGrey,
                    ),
                    child: const Text('Tenant'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => onRoleChanged('landlord'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentRole == 'landlord' ? Colors.orange : Colors.blueGrey,
                    ),
                    child: const Text('Landlord'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            ListTile(
              leading: const Icon(Icons.verified_user_outlined),
              title: const Text('Verify Identity (Upload ID)'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ID Verification coming soon')),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {},
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logout coming soon')),
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}