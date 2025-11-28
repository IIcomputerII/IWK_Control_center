import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../viewmodels/iwkpage/sagapage_view_modal.dart';

class SagaPageView extends StackedView<SagaPageViewModel> {
  final String? topic;
  final String? guid;
  const SagaPageView({super.key, this.topic, this.guid});

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
    final String? latestLogData = viewModel.logs.isNotEmpty
        ? viewModel.logs.first
        : null;
    final Map<String, String> cardData = latestLogData != null
        ? _parseRFIDData(latestLogData)
        : {};

    final bool hasData = cardData.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Smartcard Saga',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        backgroundColor: Colors.red,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: _buildProfileCard(context, cardData, hasData),
      ),
    );
  }

  Widget _buildProfileCard(
    BuildContext context,
    Map<String, String> cardData,
    bool hasData,
  ) {
    return Column(
      children: [
        CircleAvatar(
          radius: 100,
          backgroundColor: Colors.white,
          child: Image.asset(
            'assets/saga/RFIDkit.png',
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
        ),

        // Information Fields
        _buildProfileInfoField(
          'Nama Lengkap',
          cardData['nama'] ?? 'Tidak ada data',
          hasData,
        ),
        _buildProfileInfoField(
          'MAC',
          cardData['mac'] ?? 'Tidak ada data',
          hasData,
        ),
        _buildProfileInfoField(
          'Jam',
          cardData['jam'] ?? 'Tidak ada data',
          hasData,
        ),
        _buildProfileInfoField(
          'Tanggal',
          cardData['tanggal'] ?? 'Tidak ada data',
          hasData,
        ),
        _buildProfileInfoField(
          'Sekolah',
          cardData['sekolah'] ?? 'Tidak ada data',
          hasData,
        ),
        _buildProfileInfoField(
          'ID',
          cardData['id'] ?? 'Tidak ada data',
          hasData,
        ),
      ],
    );
  }

  // Helper widget to build the profile information field with the label/data stack
  Widget _buildProfileInfoField(String label, String value, bool hasData) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
          // Show the data field only if data is available
          if (hasData) ...[
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],

          const SizedBox(height: 8),
          const Divider(color: Colors.black, thickness: 0.5, height: 1),
        ],
      ),
    );
  }

  // Parse RFID data from MQTT JSON payload
  Map<String, String> _parseRFIDData(String logData) {
    final result = <String, String>{};

    try {
      // Try to parse as JSON
      final jsonMatch = RegExp(r'\{.*\}').firstMatch(logData);
      if (jsonMatch != null) {
        final jsonString = jsonMatch.group(0);
        if (jsonString != null) {
          // Manual JSON parsing for common fields
          final jsonData = jsonString.toLowerCase();

          // Extract MAC address
          final macMatch = RegExp(r'"mac"[:\s]+"([^"]+)"').firstMatch(jsonData);
          if (macMatch != null) {
            result['mac'] = macMatch.group(1)?.toUpperCase() ?? '';
          }

          // Extract RF ID
          final rfidMatch = RegExp(
            r'"rf_id"[:\s]+"([^"]+)"',
          ).firstMatch(jsonData);
          if (rfidMatch != null) {
            result['id'] = rfidMatch.group(1)?.toUpperCase() ?? '';
          }

          // Extract timestamp/jam
          final jamMatch = RegExp(r'"jam"[:\s]+"([^"]+)"').firstMatch(jsonData);
          if (jamMatch != null) {
            result['jam'] = jamMatch.group(1) ?? '';
          }

          // Extract date/tanggal
          final tanggalMatch = RegExp(
            r'"tanggal"[:\s]+"([^"]+)"',
          ).firstMatch(jsonData);
          if (tanggalMatch != null) {
            result['tanggal'] = tanggalMatch.group(1) ?? '';
          }

          // Extract nama (name) - real data from MQTT
          final namaMatch = RegExp(
            r'"nama"[:\s]+"([^"]+)"',
          ).firstMatch(jsonData);
          if (namaMatch != null) {
            result['nama'] = namaMatch.group(1) ?? '';
          }

          // Extract sekolah (school) - real data from MQTT
          final sekolahMatch = RegExp(
            r'"sekolah"[:\s]+"([^"]+)"',
          ).firstMatch(jsonData);
          if (sekolahMatch != null) {
            result['sekolah'] = sekolahMatch.group(1) ?? '';
          }
        }
      }
    } catch (e) {
      debugPrint('[SAGA] Error parsing RFID data: $e');
    }

    // Fallback: extract timestamp from log format [HH:MM:SS]
    if (!result.containsKey('jam') &&
        logData.contains('[') &&
        logData.contains(']')) {
      result['jam'] = logData.substring(
        logData.indexOf('[') + 1,
        logData.indexOf(']'),
      );
    }

    return result;
  }

  @override
  SagaPageViewModel viewModelBuilder(BuildContext context) =>
      SagaPageViewModel();
}
