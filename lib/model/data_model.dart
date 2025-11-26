import 'package:flutter/material.dart';

class IWKConfig {
  final String name;
  final String image;
  final Color primaryColor;
  final Color backgroundColor;
  final bool requiresGuid;
  final String route;

  const IWKConfig({
    required this.name,
    required this.image,
    required this.primaryColor,
    required this.backgroundColor,
    required this.requiresGuid,
    required this.route,
  });
}