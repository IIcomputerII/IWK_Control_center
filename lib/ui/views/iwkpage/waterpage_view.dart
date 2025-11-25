import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../viewmodels/iwkpage/waterpage_view_modal.dart';
import '../../../app/app.locator.dart';

class WaterPageView extends StackedView<WaterPageViewModel> {
  final String? topic;
  final String? guid;
  const WaterPageView({Key? key, this.topic, this.guid}) : super(key: key);

  @override
  void onViewModelReady(WaterPageViewModel viewModel) {
    viewModel.init(guid, topic);
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(
    BuildContext context,
    WaterPageViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: const Text(
          'SMART WATERING',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade700,
      ),
      body: Column(
        children: [
          // GUID Display
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Text(
              guid ?? 'No GUID',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: viewModel.logs.length,
              itemBuilder: (context, index) {
                // Parse log data (assuming format: timestamp + data)
                return _buildWaterCard(viewModel.logs[index], guid);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'scroll_up',
            mini: true,
            backgroundColor: Colors.blue,
            onPressed: () {
              // Scroll to top functionality
            },
            child: const Icon(Icons.arrow_upward),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: 'reset',
            backgroundColor: Colors.red,
            onPressed: () {
              // Navigate back to Dashboard
              locator<NavigationService>().back();
              locator<NavigationService>()
                  .back(); // Back to dashboard from guid screen
            },
            icon: const Icon(Icons.refresh),
            label: const Text('RESET'),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterCard(String logData, String? guid) {
    // Parse the log data
    // Expected format: [timestamp] data
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Timestamp
            Text(
              _extractTimestamp(logData),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // POMPA Status
                Expanded(
                  child: Column(
                    children: [
                      Icon(
                        Icons.settings,
                        size: 40,
                        color: Colors.green.shade700,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'POMPA',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getPompaStatus(logData),
                        style: TextStyle(
                          color: _getPompaStatus(logData) == 'On'
                              ? Colors.green
                              : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                // SENSOR SOIL Status
                Expanded(
                  child: Column(
                    children: [
                      Icon(
                        Icons.water_drop,
                        size: 40,
                        color: Colors.blue.shade700,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'SENSOR SOIL',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getSoilStatus(logData),
                        style: TextStyle(
                          color: _getSoilStatus(logData) == 'Normal'
                              ? Colors.green
                              : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_getRHValue(logData)} RH',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              guid ?? '',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  String _extractTimestamp(String logData) {
    // Extract timestamp from [HH:MM:SS] format
    if (logData.contains('[') && logData.contains(']')) {
      return logData.substring(logData.indexOf('[') + 1, logData.indexOf(']'));
    }
    return '';
  }

  String _getPompaStatus(String logData) {
    // Parse pompa status from log data
    if (logData.toLowerCase().contains('pompa on') ||
        logData.toLowerCase().contains('"pompa":"on"')) {
      return 'On';
    }
    return 'Off';
  }

  String _getSoilStatus(String logData) {
    // Parse soil sensor status
    if (logData.toLowerCase().contains('kering') ||
        logData.toLowerCase().contains('dry')) {
      return 'Kering';
    }
    return 'Normal';
  }

  String _getRHValue(String logData) {
    // Try to extract RH value from data
    // Look for patterns like "484" or "rh":484
    final rhMatch = RegExp(
      r'(\d{3,4})\s*rh',
      caseSensitive: false,
    ).firstMatch(logData.toLowerCase());
    if (rhMatch != null) {
      return rhMatch.group(1) ?? '0';
    }
    // Try JSON format
    final jsonMatch = RegExp(
      r'"rh"\s*:\s*(\d+)',
      caseSensitive: false,
    ).firstMatch(logData.toLowerCase());
    if (jsonMatch != null) {
      return jsonMatch.group(1) ?? '0';
    }
    return '0';
  }

  @override
  WaterPageViewModel viewModelBuilder(BuildContext context) =>
      WaterPageViewModel();
}
