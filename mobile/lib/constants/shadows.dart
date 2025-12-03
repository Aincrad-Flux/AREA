import 'package:flutter/material.dart';

class AppShadows {
  static final card = [
    BoxShadow(
      color: Colors.black.withOpacity(.08),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];

  static final appBar = [
    BoxShadow(
      color: Colors.black.withOpacity(.3),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];
}

