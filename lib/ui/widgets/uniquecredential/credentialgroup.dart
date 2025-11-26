import 'package:flutter/material.dart';

class CredentialGroup extends StatelessWidget {
  final String title;
  final Color sectionColor;
  final Color textColor;
  final List<Widget> children;

  const CredentialGroup({
    super.key,
    required this.title,
    required this.sectionColor,
    required this.textColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: sectionColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const Divider(color: Colors.black12, height: 16, thickness: 1),
          ...children,
        ],
      ),
    );
  }
}