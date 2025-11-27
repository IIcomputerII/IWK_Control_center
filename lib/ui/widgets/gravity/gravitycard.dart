import 'package:flutter/material.dart';

class Gravitycard extends StatelessWidget {
  final String date;
  final String clock;
  final String weight;
  final String deviceId;

  const Gravitycard({
    super.key, 
    required this.date,
    required this.clock,
    required this.weight,
    required this.deviceId,
  });

  @override
  Widget build(BuildContext context) {
    // Define the color based on the image (light gray background)
    const Color cardColor = Color(0xFFE0E0E0); // A light gray
    const Color textColor = Colors.black;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          // Set the color and rounded corners
          color: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Wrap content height
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // 1. Weight Display (Icon and Value)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '$date | $clock',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 25),
                    
                    // Scale Icon
                    const Icon(
                      Icons.balance_outlined, // A suitable Material Icon for a scale/weight
                      size: 60,
                      color: textColor,
                    ),
                    const SizedBox(width: 15),

                    // Weight Value and Unit (arranged in a Column for alignment)
                    Row(
                      // Use a Row here to keep 'weight' and 'gram' close
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        // Weight Value
                        Text(
                          weight,
                          style: const TextStyle(
                            fontSize: 55, // Large font size for visibility
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            height: 1.0, // Adjust height to control vertical space
                          ),
                        ),
                        // Unit (gram)
                        Text(
                          'gram',
                          style: TextStyle(
                            fontSize: 25, // Smaller font size for unit
                            color: textColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 35),

                // 2. Device ID
                Text(
                  'Device ID: $deviceId',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor.withOpacity(0.7), // Slightly dimmed
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}