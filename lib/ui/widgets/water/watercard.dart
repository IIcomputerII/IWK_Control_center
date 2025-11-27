import 'package:flutter/material.dart';

class MonitoringCard extends StatelessWidget {
  final String date;
  final String clock;
  final String statusPompa;
  final String statusSoil;
  final String kelembaban;
  final String deviceId;

  const MonitoringCard({
    super.key,
    required this.date,
    required this.clock,
    required this.statusPompa,
    required this.statusSoil,
    required this.kelembaban,
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

                // 2. Status Pompa and Status Soil (Side-by-Side)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    // --- Status Pompa Column ---
                    _buildStatusColumn(
                      icon: Icons.water_damage_outlined, // Icon for pump/water
                      title: 'Status Pompa',
                      status: statusPompa,
                    ),

                    // --- Status Soil Column ---
                    _buildStatusColumn(
                      icon: Icons.eco_outlined, // Icon for soil/plant
                      title: 'Status Soil',
                      status: statusSoil,
                    ),
                  ],
                ),
                const SizedBox(height: 35),

                // 3. Kelembaban (Humidity)
                Text(
                  'Kelembaban : $kelembaban RH',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 30),

                // 4. Device ID
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

  // Helper method to build the status columns (Pompa/Soil)
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