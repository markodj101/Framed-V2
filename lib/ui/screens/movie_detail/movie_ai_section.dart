import 'package:flutter/material.dart';
import 'package:framed_v2/ui/ui_utils.dart';
import 'package:glass_kit/glass_kit.dart';

class MovieAiSection extends StatelessWidget {
  const MovieAiSection({super.key});

  @override
  Widget build(BuildContext context) {
    final questions = [
      "Is there a post-credits scene?",
      "Who is the main villain?",
      "What are the main themes?",
      "Is it worth watching in IMAX?",
    ];

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ask Framed:",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: questions.map((q) => _buildQuestionTag(context, q)).toList(),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => showComingSoonDialog(context),
              child: GlassContainer.frostedGlass(
                height: 60,
                width: double.infinity,
                borderRadius: BorderRadius.circular(15),
                borderWidth: 1,
                borderColor: Colors.white.withOpacity(0.1),
                blur: 20,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.white.withOpacity(0.7), size: 20),
                      const SizedBox(width: 12),
                      Text(
                        "Ask AI something about this movie...",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.send_rounded, color: Colors.white.withOpacity(0.7), size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionTag(BuildContext context, String question) {
    return GestureDetector(
      onTap: () => showComingSoonDialog(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Text(
          question,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
