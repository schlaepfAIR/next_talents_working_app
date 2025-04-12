import 'package:flutter/material.dart';
import 'package:next_talents_working_app/home/widgets/header.dart';
import 'package:next_talents_working_app/home/widgets/footer.dart';

class AppLayout extends StatelessWidget {
  final Widget child;

  const AppLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [const Header(), Expanded(child: child), const Footer()],
      ),
    );
  }
}
