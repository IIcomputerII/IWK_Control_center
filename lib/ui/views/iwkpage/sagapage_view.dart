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
    // Determine the data to display: the latest log if available
    // Note: logs are inserted at index 0, so .first is the newest
    final String? latestLogData = viewModel.logs.isNotEmpty
        ? viewModel.logs.first
        : null;
    final Map<String, String> cardData = latestLogData != null
        ? _parseRFIDData(latestLogData)
        : {};

    // Check if we have data to populate the fields
    final bool hasData = cardData.isNotEmpty;

    return Scaffold(
      backgroundColor:
          Colors.white, // Changed background to white to match images
      appBar: AppBar(
        title: const Text(
          'Smartcard Saga',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          // The black dot from the image
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.circle, size: 10.0),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: _buildProfileCard(context, cardData, hasData),
      ),
    );
  }

  // Widget to build the profile-style card
  Widget _buildProfileCard(
    BuildContext context,
    Map<String, String> cardData,
    bool hasData,
  ) {
    return Column(
      children: [
        // Circular Image Placeholder
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade300,
          ),
          margin: const EdgeInsets.only(top: 20, bottom: 40),
        ),

        // Information Fields
        _buildProfileInfoField(
          'Nama Lengkap',
          cardData['nama'] ?? 'Waiting...', // Default value when no data
          hasData,
        ),
        _buildProfileInfoField('MAC', cardData['mac'] ?? 'Waiting...', hasData),
        _buildProfileInfoField('Jam', cardData['jam'] ?? 'Waiting...', hasData),
        _buildProfileInfoField(
          'Tanggal',
          cardData['tanggal'] ?? 'Waiting...',
          hasData,
        ),
        _buildProfileInfoField(
          'Sekolah',
          cardData['sekolah'] ?? 'Waiting...',
          hasData,
        ),
        _buildProfileInfoField('ID', cardData['id'] ?? 'Waiting...', hasData),
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
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16, // Font size matching label in image
            ),
          ),
          // Show the data field only if data is available (Image 2 state)
          if (hasData) ...[
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],

          const SizedBox(height: 8),
          const Divider(
            color: Colors.black, // Darker divider to match the image
            thickness: 0.5,
            height: 1,
          ),
        ],
      ),
    );
  }

  // The original log parsing function is kept as is.
  Map<String, String> _parseRFIDData(String logData) {
    final result = <String, String>{};

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

    if (logData.contains('[') && logData.contains(']')) {
      // Basic extraction of time and date
      result['jam'] = logData.substring(
        logData.indexOf('[') + 1,
        logData.indexOf(']'),
      );
      result['tanggal'] = DateTime.now().toString().split(' ')[0];
    }

    // Placeholder data for demonstration
    result.putIfAbsent('nama', () => 'Dummy Full Name');
    result.putIfAbsent('sekolah', () => 'PPTIK ITB');

    return result;
  }

  @override
  SagaPageViewModel viewModelBuilder(BuildContext context) =>
      SagaPageViewModel();
}
