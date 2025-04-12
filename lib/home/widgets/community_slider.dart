import 'package:flutter/material.dart';
import '../../theme.dart';

class CommunitySlider extends StatefulWidget {
  const CommunitySlider({super.key});

  @override
  State<CommunitySlider> createState() => _CommunitySliderState();
}

class _CommunitySliderState extends State<CommunitySlider> {
  final ScrollController _controller = ScrollController();

  final List<Map<String, String>> partners = const [
    {'logo': '🌐', 'name': 'TechCorp'},
    {'logo': '💼', 'name': 'BizHub'},
    {'logo': '📦', 'name': 'Packly'},
    {'logo': '🚀', 'name': 'RocketHR'},
    {'logo': '💡', 'name': 'InnoSoft'},
    {'logo': '🏢', 'name': 'Corpora'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      if (!_controller.hasClients) return;

      final maxScroll = _controller.position.maxScrollExtent;
      final current = _controller.offset;
      final next = current + 260;

      if (next >= maxScroll) {
        _controller.jumpTo(0);
      } else {
        _controller.animateTo(
          next,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
        );
      }

      _startAutoScroll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Corporates of the Community",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGrey,
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          height: 220,
          child: ListView.builder(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            itemCount: partners.length,
            itemBuilder: (context, index) {
              final company = partners[index];
              return Container(
                width: 220,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.lightGrey),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      company['logo']!,
                      style: const TextStyle(fontSize: 48),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      company['name']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
