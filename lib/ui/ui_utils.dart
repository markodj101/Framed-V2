import 'package:flutter/material.dart';
import 'package:framed_v2/ui/crystal_loader.dart';

void showComingSoonDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.8),
    builder: (context) => GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CrystalLoader(),
              const SizedBox(height: 20),
              Text(
                "Coming Soon",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w200,
                    ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
