import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../viewmodels/iwkpage/envpage_view_modal.dart';
import '../../../app/app.locator.dart';

class EnvPageView extends StackedView<EnvPageViewModel> {
  final String? topic;
  final String? guid;
  const EnvPageView({Key? key, this.topic, this.guid}) : super(key: key);

  @override
  void onViewModelReady(EnvPageViewModel viewModel) {
    viewModel.init(guid);
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(
    BuildContext context,
    EnvPageViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Colors.orange.shade100,
      appBar: AppBar(
        title: const Text(
          'ENVIROMENTAL SENSOR',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange.shade700,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: viewModel.logs.length,
        itemBuilder: (context, index) {
          return _buildEnvCard(viewModel.logs[index], guid);
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'scroll_up',
            mini: true,
            backgroundColor: Colors.white,
            onPressed: () {
              // Scroll to top
            },
            child: const Icon(Icons.arrow_upward, color: Colors.orange),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: 'reset',
            backgroundColor: Colors.red,
            onPressed: () {
              // Navigate back to Dashboard
              locator<NavigationService>().back();
              locator<NavigationService>().back();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('RESET'),
          ),
        ],
      ),
    );
  }

  Widget _buildEnvCard(String logData, String? guid) {
    final sensorData = _parseSensorData(logData);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      color: Colors.orange.shade400,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timestamp
            Text(
              _extractTimestamp(logData),
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                // House + Sensor Icon
                Icon(
                  Icons.home,
                  size: 40,
                  color: Colors.white.withOpacity(0.8),
                ),
                Icon(
                  Icons.sensors,
                  size: 30,
                  color: Colors.white.withOpacity(0.8),
                ),
                const SizedBox(width: 16),
                // Temperature readings
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${sensorData['tempC']}°C',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${sensorData['tempK']} K',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        '${sensorData['tempF']}°F',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        '${sensorData['humidity']} RH',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              guid ?? '',
              style: const TextStyle(fontSize: 9, color: Colors.white60),
            ),
          ],
        ),
      ),
    );
  }

  String _extractTimestamp(String logData) {
    if (logData.contains('[') && logData.contains(']')) {
      final time = logData.substring(
        logData.indexOf('[') + 1,
        logData.indexOf(']'),
      );
      final date = DateTime.now();
      return '${date.day} ${_getMonthName(date.month)} ${date.year} $time';
    }
    return '';
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  Map<String, String> _parseSensorData(String logData) {
    final result = {
      'tempC': '23.80',
      'tempK': '296.95',
      'tempF': '74.84',
      'humidity': '19.04',
    };

    // Try to parse values from log data
    final tempCMatch = RegExp(
      r'temp[cerature]*["\s:]+(\d+\.?\d*)',
      caseSensitive: false,
    ).firstMatch(logData.toLowerCase());
    if (tempCMatch != null) {
      final tempC = double.tryParse(tempCMatch.group(1) ?? '0') ?? 0;
      result['tempC'] = tempC.toStringAsFixed(2);
      result['tempK'] = (tempC + 273.15).toStringAsFixed(2);
      result['tempF'] = ((tempC * 9 / 5) + 32).toStringAsFixed(2);
    }

    final humMatch = RegExp(
      r'hum[idity]*["\s:]+(\d+\.?\d*)',
      caseSensitive: false,
    ).firstMatch(logData.toLowerCase());
    if (humMatch != null) {
      result['humidity'] = humMatch.group(1) ?? '0';
    }

    return result;
  }

  @override
  EnvPageViewModel viewModelBuilder(BuildContext context) => EnvPageViewModel();
}
