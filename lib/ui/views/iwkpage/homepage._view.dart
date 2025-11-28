import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../viewmodels/iwkpage/homepage._view_modal.dart';
import '../../../app/app.locator.dart';

class HomePageView extends StackedView<HomePageViewModel> {
  final String? topic;
  final String? guid;
  const HomePageView({Key? key, this.topic, this.guid}) : super(key: key);

  @override
  void onViewModelReady(HomePageViewModel viewModel) {
    viewModel.init(guid, topic);
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(
    BuildContext context,
    HomePageViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Colors.cyan.shade700,
      appBar: AppBar(
        title: Text(
          viewModel.deviceName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.cyan.shade800,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Connection Status Banner (only show when no data)
            if (!viewModel.isDeviceOnline)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Waiting for sensor data...',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade900,
                            ),
                          ),
                          Text(
                            'GUID: ${viewModel.deviceGuid ?? "N/A"}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Power Meter Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Power Meter',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildPowerRow('Voltage', '${viewModel.voltage} V'),
                    _buildPowerRow('Current', '${viewModel.current} A'),
                    _buildPowerRow('Power', '${viewModel.power} W'),
                    _buildPowerRow('Energy', '${viewModel.energy} kWh'),
                    _buildPowerRow('Frequency', '${viewModel.frequency} Hz'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Control Cards Row
            Row(
              children: [
                Expanded(
                  child: _buildControlCard(
                    'Lampu\nTrainer',
                    Icons.lightbulb_outline,
                    viewModel.isSaklarOn,
                    viewModel.toggleSaklar,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildControlCard(
                    'Steker\nTrainer',
                    Icons.flash_on,
                    viewModel.isStekerOn,
                    viewModel.toggleSteker,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Reset Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate back to Dashboard
                  locator<NavigationService>().back();
                  locator<NavigationService>().back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'RESET',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPowerRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlCard(
    String label,
    IconData icon,
    bool isOn,
    VoidCallback onToggle,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.scale(
                    scale: 0.8,
                    child: IgnorePointer(
                      // Disable drag/slide interaction on the switch itself
                      child: Switch(
                        value: isOn,
                        onChanged:
                            (_) {}, // Callback ignored due to IgnorePointer
                        activeColor: Colors.cyan,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(icon, size: 32, color: isOn ? Colors.cyan : Colors.grey),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  HomePageViewModel viewModelBuilder(BuildContext context) =>
      HomePageViewModel();
}
