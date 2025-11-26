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
    UniqueCredentialViewModel viewModel,
    Widget? child,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    final Color hintColor = config.primaryColor.withOpacity(0.7); 

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
              ..._buildHomeAutomationFields(viewModel, hintColor, config.backgroundColor, config.primaryColor)
            else if (config.name == 'Smart Saga')
              ..._buildSmartSagaFields(viewModel, hintColor, config.primaryColor)
            else 
              ..._buildDefaultFields(viewModel, hintColor, config.primaryColor),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: viewModel.submit, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: config.backgroundColor, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), 
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'CONNECT DEVICE', 
                  style: TextStyle(fontSize: 18, color: config.primaryColor, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: viewModel.requiresGuid
          ? Padding(
            padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
            child: FloatingActionButton.extended(
                onPressed: () async {
                  final result = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const QRScannerView(),
                    ),
                  );
                  if (result != null && result is String) {
                    viewModel.handleQrResult(result);
                  }
                },
                icon: const Icon(
                  Icons.qr_code_2,
                  color: Colors.black, 
                ),
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
          )
          : null,
    );
  }

  List<Widget> _buildHomeAutomationFields(
      UniqueCredentialViewModel viewModel,
      Color hintColor,
      Color sectionColor,
      Color textColor) {

    const IconData label = Icons.label;
    const IconData keyIcon = Icons.vpn_key_outlined;

    return [
      // --- Queues Settings (Outside Section Box) ---
      const Text(
        'Queues Settings',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 15),

      // Queue Field 1
      BorderTextField(
        controller: viewModel.keywordController,
        icon: label, 
        labelText: 'Queue Topic 1',
        color: hintColor,
      ),
      const SizedBox(height: 15),

      // Queue Field 2
      BorderTextField(
        controller: viewModel.guidController, // Using GUID controller for the second field for simplicity
        icon: label, 
        labelText: 'Queue Topic 2',
        color: hintColor,
      ),
      const SizedBox(height: 30),

      // --- Device Settings (Groups) ---
      const Text(
        'Device Settings',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 15),

      // Saklar Group
      CredentialGroup(
        title: 'Saklar',
        sectionColor: sectionColor,
        textColor: textColor,
        children: [
          BorderTextField(
            controller: TextEditingController(), // Placeholder controller
            icon: keyIcon, 
            labelText: 'Saklar GUID',
            color: hintColor,
          ),
          const SizedBox(height: 15),
          BorderTextField(
            controller: TextEditingController(), // Placeholder controller
            icon: label, 
            labelText: 'Saklar Topic',
            color: hintColor,
          ),
        ],
      ),
      const SizedBox(height: 20),

      // Steker Group
      CredentialGroup(
        title: 'Steker',
        sectionColor: sectionColor,
        textColor: textColor,
        children: [
          BorderTextField(
            controller: TextEditingController(), // Placeholder controller
            icon: keyIcon, 
            labelText: 'Steker GUID',
            color: hintColor,
          ),
          const SizedBox(height: 15),
          BorderTextField(
            controller: TextEditingController(), // Placeholder controller
            icon: label, 
            labelText: 'Steker Topic',
            color: hintColor,
          ),
        ],
      ),
      const SizedBox(height: 20),
      
      // Power Meter Group
      CredentialGroup(
        title: 'Power Meter',
        sectionColor: sectionColor,
        textColor: textColor,
        children: [
          BorderTextField(
            controller: TextEditingController(), // Placeholder controller
            icon: keyIcon, 
            labelText: 'Meter GUID',
            color: hintColor,
          ),
          const SizedBox(height: 15),
          BorderTextField(
            controller: TextEditingController(), // Placeholder controller
            icon: label, 
            labelText: 'Meter Topic',
            color: hintColor,
          ),
        ],
      ),
      const SizedBox(height: 40),
    ];
  }

  List<Widget> _buildSmartSagaFields(
      UniqueCredentialViewModel viewModel, Color hintColor, Color textColor) {
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
      UniqueCredentialViewModel viewModel, Color hintColor, Color textColor) {
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

      // GUID Field
      BorderTextField(
        controller: viewModel.guidController,
        icon: Icons.vpn_key,
        labelText: 'GUID',
        color: hintColor,
      ),
      const SizedBox(height: 40),
    ];
  }


  @override
  UniqueCredentialViewModel viewModelBuilder(BuildContext context) =>
      UniqueCredentialViewModel();
}