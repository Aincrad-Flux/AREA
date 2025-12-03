import 'package:flutter/material.dart';

class ServiceDefinition {
  const ServiceDefinition({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
  });

  final String id;
  final String name;
  final Color color;
  final IconData icon;
}

final Map<String, ServiceDefinition> services = {
  'gmail': const ServiceDefinition(id: 'gmail', name: 'Gmail', color: Color(0xFFEA4335), icon: Icons.mail_outline),
  'timer': const ServiceDefinition(id: 'timer', name: 'Timer', color: Color(0xFF4285F4), icon: Icons.schedule),
  'github': const ServiceDefinition(id: 'github', name: 'GitHub', color: Color(0xFF6E40C9), icon: Icons.code),
  'discord': const ServiceDefinition(id: 'discord', name: 'Discord', color: Color(0xFF5865F2), icon: Icons.forum),
  'dropbox': const ServiceDefinition(id: 'dropbox', name: 'Dropbox', color: Color(0xFF0061FF), icon: Icons.cloud_outlined),
  'outlook': const ServiceDefinition(id: 'outlook', name: 'Outlook', color: Color(0xFF0078D4), icon: Icons.calendar_today),
};

