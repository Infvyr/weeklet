import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Terms & Conditions'),
    ),
    body: const SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Text(
        'Terms and Conditions content will be added before public release.',
      ),
    ),
  );
}
