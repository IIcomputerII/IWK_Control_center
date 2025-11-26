import 'package:flutter/material.dart';
import 'package:iwk_control_center/model/data_model.dart';

class Infocard extends StatelessWidget {
  final double width;
  final IWKConfig config;
  const Infocard({
    Key? key,
    required this.width,
    required this.config,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: config.backgroundColor.withOpacity(0.4), 
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Icon Box
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              config.image, 
              fit: BoxFit.contain,
              // Fallback if image asset fails (or just for design consistency)
              errorBuilder: (context, error, stackTrace) => 
                  Icon(Icons.devices_other, size: 30, color: config.primaryColor),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  config.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Enter credentials to connect',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
