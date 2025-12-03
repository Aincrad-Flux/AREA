import 'package:flutter/material.dart';

import '../constants/palette.dart';
import '../constants/shadows.dart';
import '../models/models.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static final _areas = [
    const AreaWorkflow('GitHub → Discord', nodes: 2, active: true),
    const AreaWorkflow('Daily Email Report', nodes: 3, active: true),
    const AreaWorkflow('File Backup', nodes: 2, active: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('My Automations', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 4),
          Text(
            'Manage your AREA workflows',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppPalette.primary),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {},
            style: FilledButton.styleFrom(
              backgroundColor: AppPalette.accent,
              foregroundColor: AppPalette.dark,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            icon: const Icon(Icons.add),
            label: const Text('New AREA'),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                final area = _areas[index];
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: AppShadows.card,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(area.name, style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            Text(
                              '${area.nodes} nodes • ${area.active ? 'Active' : 'Inactive'}',
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppPalette.surfaceText),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: area.active ? Colors.green : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemCount: _areas.length,
            ),
          ),
        ],
      ),
    );
  }
}

