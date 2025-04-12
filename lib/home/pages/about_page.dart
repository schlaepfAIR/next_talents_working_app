// how_it_works_page.dart
import 'package:flutter/material.dart';
import 'package:next_talents_working_app/home/widgets/app_layout.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Page-specific content here
          ],
        ),
      ),
    );
  }
}
