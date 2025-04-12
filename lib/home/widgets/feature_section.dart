import 'package:flutter/material.dart';
import '../../theme.dart';

class FeatureSection extends StatelessWidget {
  final bool isMobile;
  const FeatureSection({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final items = [
      _Feature(icon: Icons.search, label: "Discover Talent"),
      _Feature(icon: Icons.star_border, label: "Saved Profiles"),
      _Feature(icon: Icons.message, label: "Messaging"),
    ];

    return Container(
      color: AppColors.secondary.withOpacity(0.2),
      padding: const EdgeInsets.symmetric(vertical: 40),
      child:
          isMobile
              ? Column(children: items)
              : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: items,
              ),
    );
  }
}

class _Feature extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Feature({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(icon, size: 40, color: AppColors.primary),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.darkGrey,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Lorem ipsum dolor sit amet, consectetur",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
