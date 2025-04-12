import 'package:flutter/material.dart';
import '../theme.dart';
import 'widgets/community_slider.dart';
import 'widgets/footer.dart';
import 'widgets/header.dart';
import 'widgets/hero_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: Column(
        children: [
          const Header(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  HeroSection(),
                  SizedBox(height: 48),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: CommunitySlider(),
                  ),
                  SizedBox(height: 48),
                ],
              ),
            ),
          ),
          const Footer(),
        ],
      ),
    );
  }
}
