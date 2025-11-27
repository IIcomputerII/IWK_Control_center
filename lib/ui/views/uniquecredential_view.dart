import 'package:flutter/material.dart';
import 'package:iwk_control_center/model/data_model.dart';
import 'package:iwk_control_center/ui/widgets/uniquecredential/credentialgroup.dart';
import 'package:iwk_control_center/ui/widgets/uniquecredential/infocard.dart';
import 'package:stacked/stacked.dart';
import '../../viewmodels/uniquecredential_view_modal.dart';
import 'qr_scanner_view.dart';
import '../widgets/BorderTextField.dart';

class UniqueCredentialView extends StackedView<UniqueCredentialViewModel> {
  final IWKConfig config;
  const UniqueCredentialView({super.key, required this.config});

  @override
  void onViewModelReady(UniqueCredentialViewModel viewModel) {
    viewModel.init(config);
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(
    BuildContext context,
    UniqueCredentialViewModel vm,
    Widget? child,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final hintColor = config.primaryColor.withOpacity(0.7);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Device Credentials'),
        centerTitle: true,
        backgroundColor: config.primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Infocard(config: config, width: screenWidth),
            const SizedBox(height: 30),
            if (config.name == 'Home Automation')
              ..._buildHomeAutomationFields(
                viewModel,
                hintColor,
                config.backgroundColor,
                config.primaryColor,
              )
            else if (config.name == 'Smart Saga')
              ..._buildSmartSagaFields(
                viewModel,
                hintColor,
                config.primaryColor,
              )
            else
              ..._buildDefaultFields(viewModel, hintColor, config.primaryColor),

            // Tombol submit
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: vm.submitAndNavigate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: config.backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'CONNECT DEVICE',
                  style: TextStyle(
                    fontSize: 18,
                    color: config.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // FAB untuk scan QR (hanya tampil kalau butuh GUID)
      floatingActionButton: vm.needsGuid
          ? _buildQrScanButton(context, vm)
          : null,
    );
  }

  // Button QR scanner
  Widget _buildQrScanButton(
    BuildContext context,
    UniqueCredentialViewModel vm,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
      child: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const QRScannerView()));
          if (result != null && result is String) {
            vm.handleQrScan(result);
          }
        },
        icon: const Icon(Icons.qr_code_2, color: Colors.black),
        label: const Text(
          'SCAN QR',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: const BorderSide(color: Colors.black12, width: 1),
        ),
        elevation: 4,
      ),
    );
  }

  // Field untuk Home Automation (punya banyak input untuk tiap device)
  List<Widget> _buildHomeFields(
    UniqueCredentialViewModel vm,
    Color hintColor,
    IWKConfig config,
  ) {
    return [
      // Section header
      const Text(
        'Queues Settings',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 15),

      // Queue topics
      BorderTextField(
        controller: vm.queueTopic1,
        icon: Icons.label,
        labelText: 'Queue Topic 1',
        color: hintColor,
      ),
      const SizedBox(height: 15),
      BorderTextField(
        controller: vm.queueTopic2,
        icon: Icons.label,
        labelText: 'Queue Topic 2',
        color: hintColor,
      ),
      const SizedBox(height: 30),

      // Section device settings
      const Text(
        'Device Settings',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 15),

      // Saklar device
      CredentialGroup(
        title: 'Saklar',
        sectionColor: config.backgroundColor,
        textColor: config.primaryColor,
        children: [
          BorderTextField(
            controller: vm.saklarGuid,
            icon: Icons.vpn_key_outlined,
            labelText: 'Saklar GUID',
            color: hintColor,
          ),
          const SizedBox(height: 15),
          BorderTextField(
            controller: vm.saklarName, // Changed from saklarTopic
            icon: Icons.label,
            labelText: 'Saklar Name', // Changed from 'Saklar Topic'
            color: hintColor,
          ),
        ],
      ),
      const SizedBox(height: 20),

      // Steker device
      CredentialGroup(
        title: 'Steker',
        sectionColor: config.backgroundColor,
        textColor: config.primaryColor,
        children: [
          BorderTextField(
            controller: vm.stekerGuid,
            icon: Icons.vpn_key_outlined,
            labelText: 'Steker GUID',
            color: hintColor,
          ),
          const SizedBox(height: 15),
          BorderTextField(
            controller: vm.stekerName, // Changed from stekerTopic
            icon: Icons.label,
            labelText: 'Steker Name', // Changed from 'Steker Topic'
            color: hintColor,
          ),
        ],
      ),
      const SizedBox(height: 20),

      // Power Meter device
      CredentialGroup(
        title: 'Power Meter',
        sectionColor: config.backgroundColor,
        textColor: config.primaryColor,
        children: [
          BorderTextField(
            controller: vm.meterGuid,
            icon: Icons.vpn_key_outlined,
            labelText: 'Meter GUID',
            color: hintColor,
          ),
          const SizedBox(height: 15),
          BorderTextField(
            controller: vm.meterName, // Changed from meterTopic
            icon: Icons.label,
            labelText: 'Meter Name', // Changed from 'Meter Topic'
            color: hintColor,
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildSmartSagaFields(
    UniqueCredentialViewModel viewModel,
    Color hintColor,
    Color textColor,
  ) {
    return [
      Text(
        'Device Settings',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
      const SizedBox(height: 15),

      // Keyword/Topic Field (The only field for Smart Saga)
      BorderTextField(
        controller: viewModel.keywordController,
        icon: Icons.label,
        labelText: 'Keyword/Topic',
        color: hintColor,
      ),
      const SizedBox(height: 40), // Increased spacing before the button
    ];
  }

  // Layout for all other modules (simple GUID/Keyword inputs)
  List<Widget> _buildDefaultFields(
    UniqueCredentialViewModel viewModel,
    Color hintColor,
    Color textColor,
  ) {
    return [
      Text(
        'Device Settings',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
      const SizedBox(height: 15),

      // Keyword/Topic Field
      BorderTextField(
        controller: viewModel.keywordController,
        icon: Icons.label,
        labelText: 'Keyword/Topic',
        color: hintColor,
      ),
      const SizedBox(height: 15),
      BorderTextField(
        controller: vm.guidController,
        icon: Icons.vpn_key,
        labelText: 'GUID',
        color: hintColor,
      ),
    ];
  }

  @override
  UniqueCredentialViewModel viewModelBuilder(BuildContext context) {
    return UniqueCredentialViewModel();
  }
}
