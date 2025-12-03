import 'package:flutter/material.dart';

import '../constants/palette.dart';
import '../constants/shadows.dart';
import '../models/models.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Connected Services', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: services.values.map((service) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: AppShadows.card,
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: service.color,
                    radius: 28,
                    child: Icon(service.icon, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(service.name, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
                  const SizedBox(height: 4),
                  const Text('Connected', style: TextStyle(color: Colors.green, fontSize: 12)),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

