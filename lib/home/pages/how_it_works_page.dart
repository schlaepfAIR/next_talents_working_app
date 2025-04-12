import 'package:flutter/material.dart';
import 'package:next_talents_working_app/home/widgets/app_layout.dart';
import 'package:next_talents_working_app/theme.dart';

class HowItWorksPage extends StatelessWidget {
  const HowItWorksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;
    final horizontalPadding = isMobile ? 3.0 : 0.0;

    return AppLayout(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 25),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Center(
            child: Container(
              width: isMobile ? double.infinity : 800,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(30),
              ),
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TabBar(
                        indicator: BoxDecoration(
                          color: AppColors.electricBlue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: Colors.white,
                        unselectedLabelColor: AppColors.darkGrey,
                        tabs: const [
                          Tab(text: 'Bewerber'),
                          Tab(text: 'Firmen'),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: const SizedBox(
                        height: 600, // oder je nach Inhalt dynamisch
                        child: TabBarView(
                          children: [_ApplicantContent(), _CompanyContent()],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ApplicantContent extends StatelessWidget {
  const _ApplicantContent();

  @override
  Widget build(BuildContext context) {
    return const Text('Infos für Bewerber...', style: TextStyle(fontSize: 16));
  }
}

class _CompanyContent extends StatelessWidget {
  const _CompanyContent();

  @override
  Widget build(BuildContext context) {
    return const Text('Infos für Firmen...', style: TextStyle(fontSize: 16));
  }
}
