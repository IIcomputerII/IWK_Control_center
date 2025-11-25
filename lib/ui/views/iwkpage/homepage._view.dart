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
        title: const Text(
          'HOME AUTOMATION',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.cyan.shade800,
        actions: [
          IconButton(icon: const Icon(Icons.grid_view), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
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
                    _buildPowerRow('Voltage', 'V'),
                    _buildPowerRow('Current', 'A'),
                    _buildPowerRow('Power', 'W'),
                    _buildPowerRow('Energy', 'kWh'),
                    _buildPowerRow('Frequency', 'Hz'),
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
                    false,
                    () {},
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildControlCard(
                    'Steker\nTrainer',
                    Icons.flash_on,
                    false,
                    () {},
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Colors.cyan.shade700,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPowerRow(String label, String unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            unit,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: isOn,
                    onChanged: (value) => onToggle(),
                    activeColor: Colors.cyan,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(icon, size: 32, color: isOn ? Colors.cyan : Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  HomePageViewModel viewModelBuilder(BuildContext context) =>
      HomePageViewModel();
}
