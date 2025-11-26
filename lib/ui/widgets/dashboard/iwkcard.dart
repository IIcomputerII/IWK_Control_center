import 'package:flutter/material.dart';
import 'package:iwk_control_center/model/data_model.dart';

class Iwkcard extends StatelessWidget {
  final IWKConfig config;
  final VoidCallback onTap;

  const Iwkcard({
    Key? key,
    required this.config,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: config.primaryColor.withOpacity(0.35),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40, // Adjust the radius as needed for the size of the circle
                backgroundColor: config.backgroundColor, // Set the background color to white
                child: Image.asset(
                  config.image, // Your image asset
                  width: 70, // Adjust the width of the image inside the circle
                  height: 70, // Adjust the height of the image inside the circle
                  fit: BoxFit.contain, // Ensures the whole image is visible inside the circle
                ),
              ),
              const SizedBox(height: 16),
              Text(
                config.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.5)
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  } 
}