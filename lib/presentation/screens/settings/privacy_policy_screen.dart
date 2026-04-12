import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Privacy Policy'),
    ),
    body: const SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Text(
        'Privacy Policy content will be added before public release.',
      ),
    ),
  );
}
