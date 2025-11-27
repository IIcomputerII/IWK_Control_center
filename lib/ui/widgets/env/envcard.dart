import 'package:flutter/material.dart';

class WeatherMonitoringCard extends StatelessWidget {
  // Example dummy data (replace with real data variables)
  final String date;
  final String clock;
  final String cuaca; // Cloudy
  final String temperature; // Temperature value
  final String deviceId ;

  const WeatherMonitoringCard({
    super.key,
    required this.date,
    required this.clock,
    required this.cuaca,
    required this.temperature,
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
                // 1. Date and Clock
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

                // 2. Cuaca and Temperatur (Side-by-Side)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    // --- Cuaca (Weather) Column ---
                    _buildStatusColumn(
                      icon: Icons.cloud_outlined, // Icon for weather/cloud
                      title: 'Cuaca',
                      status: cuaca,
                    ),

                    // --- Temperatur (Temperature) Column ---
                    _buildStatusColumn(
                      icon: Icons.thermostat_outlined, // Icon for thermometer
                      title: 'Temperatur',
                      status: '$temperature °C', // Include the unit
                    ),
                  ],
                ),
                const SizedBox(height: 55), // Space for lower section (like Kelembaban in the first card)

                // 3. Device ID
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

  // Helper method to build the status columns (Cuaca/Temperatur)
  Widget _buildStatusColumn({
    required IconData icon,
    required String title,
    required String status,
  }) {
    const Color textColor = Colors.black;
    return Column(
      children: <Widget>[
        Icon(
          icon,
          size: 50,
          color: textColor,
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            color: textColor,
          ),
        ),
        Text(
          status,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    );
  }
}