import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Statistics'),
    ),
    body: const Center(
      child: Text('Stats Screen'),
    ),
  );
}
