import 'package:flutter/material.dart';

import '../constants/palette.dart';
import '../models/models.dart';

class NodePicker extends StatelessWidget {
  const NodePicker({super.key, required this.type});

  final NodeType type;

  @override
  Widget build(BuildContext context) {
    final items = type == NodeType.action ? actionTemplates : reactionTemplates;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 6,
            decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(3)),
          ),
          const SizedBox(height: 20),
          Text(
            'Add ${type == NodeType.action ? 'Action' : 'Reaction'}',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(color: AppPalette.dark),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = items[index];
                final service = services[item.serviceId]!;
                return ListTile(
                  tileColor: Colors.grey.shade100,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  leading: CircleAvatar(backgroundColor: service.color, child: Icon(service.icon, color: Colors.white)),
                  title: Text(item.name),
                  subtitle: Text(item.description),
                  onTap: () => Navigator.of(context).pop(item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

