import 'package:flutter/material.dart';

import '../constants/palette.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(radius: 48, backgroundColor: AppPalette.surface, child: Icon(Icons.person, size: 48, color: Colors.white)),
          const SizedBox(height: 16),
          Text('You', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('team@area.app', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppPalette.primary)),
        ],
      ),
    );
  }
}

