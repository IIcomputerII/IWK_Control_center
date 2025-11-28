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
    final Color cardColor = Colors.blue.shade100; // A light gray
    final Color textColor = Colors.blue.shade800; // Dark text for contrast

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
                // 1. Date and Clock
                Text(
                  '$date | $clock',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 25),

                // 2. Weight Display (Icon and Value)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Scale Icon
                    Icon(
                      Icons
                          .balance_outlined, // A suitable Material Icon for a scale/weight
                      size: 50,
                      color: textColor,
                    ),
                    const SizedBox(width: 15),

                    // Weight Value and Unit (arranged in a Row for alignment)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        // Weight Value
                        Text(
                          weight,
                          style: TextStyle(
                            fontSize: 40, // Large font size for visibility
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            height:
                                1.0, // Adjust height to control vertical space
                          ),
                        ),
                        const SizedBox(width: 5),
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

                // 3. Device ID
                Center(
                  child: Text(
                    deviceId,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor.withOpacity(0.7), // Slightly dimmed
                    ),
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
