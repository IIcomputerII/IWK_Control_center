import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../viewmodels/iwkpage/sagapage_view_modal.dart';
import '../../../app/app.locator.dart';
import 'dart:convert';

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
          ? const Center(
              child: Text(
                'Waiting for RFID scan...',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            )
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
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // RFID Logo Header
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.credit_card,
                    size: 48,
                    color: Colors.orange.shade700,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'RFID',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Divider(thickness: 1),

            // Nama Lengkap
            _buildInfoRow(
              'Nama Lengkap',
              cardData['nama'] ?? 'SMART CARD SAGA',
            ),
            const Divider(),

            // Mac
            _buildInfoRow('Mac', cardData['mac'] ?? '-'),
            const Divider(),

            // Jam
            _buildInfoRow('Jam', cardData['jam'] ?? '-'),
            const Divider(),

            // Tanggal
            _buildInfoRow('Tanggal', cardData['tanggal'] ?? '-'),
            const Divider(),

            // Sekolah
            _buildInfoRow('Sekolah', cardData['sekolah'] ?? 'PPTIK ITB'),
            const Divider(),

            // Id
            _buildInfoRow('Id', cardData['id'] ?? '-'),

            const SizedBox(height: 24),

            // Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Refresh action - could trigger re-read or update
                    },
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    label: const Text(
                      'Refresh',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade600,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Reset action - navigate back
                      locator<NavigationService>().back();
                      locator<NavigationService>().back();
                    },
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    label: const Text(
                      'Reset',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
              ],
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
    final result = <String, String>{};

    try {
      // Try to parse as JSON first
      final jsonData = jsonDecode(logData);
      if (jsonData is Map<String, dynamic>) {
        result['nama'] =
            jsonData['nama']?.toString() ?? jsonData['name']?.toString() ?? '';
        result['mac'] = jsonData['mac']?.toString() ?? '';
        result['jam'] =
            jsonData['jam']?.toString() ?? jsonData['time']?.toString() ?? '';
        result['tanggal'] =
            jsonData['tanggal']?.toString() ??
            jsonData['date']?.toString() ??
            '';
        result['sekolah'] =
            jsonData['sekolah']?.toString() ??
            jsonData['school']?.toString() ??
            '';
        result['id'] = jsonData['id']?.toString() ?? '';
        return result;
      }
    } catch (e) {
      // If JSON parsing fails, fall back to regex
    }

    // Regex-based parsing as fallback
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

    // Try to extract nama/name
    final namaMatch = RegExp(
      r'(?:nama|name)["\s:]+([^,"}\n]+)',
      caseSensitive: false,
    ).firstMatch(logData);
    if (namaMatch != null) {
      result['nama'] = namaMatch.group(1)?.trim() ?? '';
    }

    // Try to extract sekolah/school
    final sekolahMatch = RegExp(
      r'(?:sekolah|school)["\s:]+([^,"}\n]+)',
      caseSensitive: false,
    ).firstMatch(logData);
    if (sekolahMatch != null) {
      result['sekolah'] = sekolahMatch.group(1)?.trim() ?? '';
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
