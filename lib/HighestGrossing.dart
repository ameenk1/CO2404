import 'package:flutter/material.dart';

class HighestGrossing extends StatefulWidget {
  const HighestGrossing({super.key});

  @override
  State<HighestGrossing> createState() => _HighestGrossingState();
}

class _HighestGrossingState extends State<HighestGrossing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Highest Gross Movies")
      ),
    );
  }
}