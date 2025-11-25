import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../viewmodels/iwkpage/sagapage_view_modal.dart';
import '../../../app/app.locator.dart';

class SagaPageView extends StackedView<SagaPageViewModel> {
  final String? topic;
  final String? guid;
  const SagaPageView({Key? key, this.topic, this.guid}) : super(key: key);

  @override
  void onViewModelReady(SagaPageViewModel viewModel) {
    viewModel.init(guid, topic);
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(
    BuildContext context,
    SagaPageViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text(
          'SMART CARD SAGA',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple.shade700,
      ),
      body: viewModel.logs.isEmpty
          ? const Center(child: Text('Waiting for RFID scan...'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: viewModel.logs.length,
              itemBuilder: (context, index) {
                return _buildRFIDCard(viewModel.logs[index]);
              },
            ),
    );
  }

  Widget _buildRFIDCard(String logData) {
    final cardData = _parseRFIDData(logData);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // RFID Logo
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.credit_card,
                    size: 50,
                    color: Colors.orange.shade700,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'RFID',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoRow(
              'Nama Lengkap',
              cardData['nama'] ?? 'SMART CARD SAGA',
            ),
            const Divider(),
            _buildInfoRow('Mac', cardData['mac'] ?? '-'),
            const Divider(),
            _buildInfoRow('Jam', cardData['jam'] ?? '-'),
            const Divider(),
            _buildInfoRow('Tanggal', cardData['tanggal'] ?? '-'),
            const Divider(),
            _buildInfoRow('Sekolah', cardData['sekolah'] ?? 'PPTIK ITB'),
            const Divider(),
            _buildInfoRow('Id', cardData['id'] ?? '-'),
            const SizedBox(height: 20),
            // Refresh Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Refresh action
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.orange.shade700,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Map<String, String> _parseRFIDData(String logData) {
    // Parse RFID data from log
    // Expected JSON format or key-value pairs
    final result = <String, String>{};

    // Try to extract data using regex
    final macMatch = RegExp(
      r'mac["\s:]+([a-f0-9:]+)',
      caseSensitive: false,
    ).firstMatch(logData.toLowerCase());
    if (macMatch != null) {
      result['mac'] = macMatch.group(1) ?? '';
    }

    final idMatch = RegExp(
      r'id["\s:]+([a-f0-9]+)',
      caseSensitive: false,
    ).firstMatch(logData.toLowerCase());
    if (idMatch != null) {
      result['id'] = idMatch.group(1) ?? '';
    }

    // Extract timestamp from log prefix [HH:MM:SS]
    if (logData.contains('[') && logData.contains(']')) {
      result['jam'] = logData.substring(
        logData.indexOf('[') + 1,
        logData.indexOf(']'),
      );
      result['tanggal'] = DateTime.now().toString().split(' ')[0];
    }

    return result;
  }

  @override
  SagaPageViewModel viewModelBuilder(BuildContext context) =>
      SagaPageViewModel();
}
