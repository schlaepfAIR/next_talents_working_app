import 'package:flutter/material.dart';
import '../../theme.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Talente finden. Zukunft gestalten.",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: AppColors.darkGrey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const Text(
            "Find the right talent for your team",
            style: TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGrey,
            ),
            textAlign: TextAlign.center,
            softWrap: false,
            overflow: TextOverflow.fade,
          ),
          const SizedBox(height: 16),
          const Text(
            "Lorem ipsum dolor sit amet, consectetur",
            style: TextStyle(fontSize: 17, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 12,
            children: [
              ElevatedButton(
                onPressed: () {
                  // TODO: Navigiere zu Talente-Seite
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
                child: const Text("Mehr Info's für Talente"),
              ),
              ElevatedButton(
                onPressed: () {
                  // TODO: Navigiere zu Firmen-Seite
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
                child: const Text("Mehr Info's für Firmen"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
