import 'package:flutter/material.dart';
import 'package:iwk_control_center/model/data_model.dart';

class Iwkcard extends StatelessWidget {
  final IWKConfig config;
  final VoidCallback onTap;

  const Iwkcard({Key? key, required this.config, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: config.primaryColor.withOpacity(0.35),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Padding(
          // Reduced padding to prevent overflow
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // Important: minimize height
            children: [
              // Icon circle
              CircleAvatar(
                radius: 35, // Reduced from 40
                backgroundColor: config.backgroundColor,
                child: Image.asset(
                  config.image,
                  width: 60, // Reduced from 70
                  height: 60, // Reduced from 70
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 12), // Reduced from 16
              // Title text
              Flexible(
                // Wrap in Flexible to prevent overflow
                child: Text(
                  config.name,
                  style: TextStyle(
                    fontSize: 15, // Slightly reduced
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.5),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2, // Allow max 2 lines
                  overflow: TextOverflow.ellipsis, // Handle long text
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
