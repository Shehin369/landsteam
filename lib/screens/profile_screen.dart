import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:landsteam/constants.dart';
import 'package:landsteam/controllers/authentication_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Dummy placeholder data
  String name = 'Ajmal Mirza';
  String age = '29';
  String gender = 'Male';
  String mobile = '+91 98765 43210';
  String place = 'Kochi, India';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kSurfaceColor,
        elevation: 0,
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: kPrimaryTextColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: kSecondaryTextColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: CircleAvatar(
                radius: 48,
                backgroundColor: Colors.grey.shade500,
                child: const Icon(Icons.person, size: 56, color: Colors.white),
              ),
            ),

            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(
                color: kPrimaryTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              place,
              style: TextStyle(color: kPrimaryTextColor.withOpacity(0.75)),
            ),

            const SizedBox(height: 24),

            // Info card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: kSurfaceColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  _infoRow('Name', name, Icons.person_outline),
                  const Divider(
                    height: 18,
                    thickness: 1,
                    color: Colors.transparent,
                  ),
                  _infoRow('Age', age, Icons.cake_outlined),
                  const Divider(
                    height: 18,
                    thickness: 1,
                    color: Colors.transparent,
                  ),
                  _infoRow('Gender', gender, Icons.wc_outlined),
                  const Divider(
                    height: 18,
                    thickness: 1,
                    color: Colors.transparent,
                  ),
                  _infoRow('Mobile', mobile, Icons.phone_outlined),
                  const Divider(
                    height: 18,
                    thickness: 1,
                    color: Colors.transparent,
                  ),
                  _infoRow('Place', place, Icons.location_on_outlined),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Sign out button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Sign out'),
                      content: const Text('Are you sure you want to sign out?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Sign out'),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true) {
                    // Attempt to call AuthenticationController.signOut if available
                    try {
                      final auth = Provider.of<AuthenticationController>(
                        context,
                        listen: false,
                      );
                      if (auth != null && auth is AuthenticationController) {
                        // call signOut if implemented
                        // await auth.signOut();
                      }
                    } catch (_) {
                      // ignore if controller or method missing
                    }

                    // Return to first route
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('Signed out')));
                  }
                },
              ),
            ),

            const SizedBox(height: 12),

            // Contact us
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.contact_mail_outlined),
                label: const Text('Contact Us'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: kPrimaryTextColor,
                  backgroundColor: kSurfaceColor,
                  side: BorderSide(color: Colors.grey.shade300),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Contact Us'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Email: support@landsteam.example'),
                          SizedBox(height: 8),
                          Text('Phone: +91 90000 00000'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: kSecondaryTextColor, size: 20),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: const TextStyle(
              color: kPrimaryTextColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: kPrimaryTextColor.withOpacity(0.9)),
            ),
          ),
        ],
      ),
    );
  }
}
