import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../viewmodels/uniquecredential_view_modal.dart';
import 'qr_scanner_view.dart';

class UniqueCredentialView extends StackedView<UniqueCredentialViewModel> {
  final String iwkType;
  const UniqueCredentialView({Key? key, required this.iwkType})
    : super(key: key);

  @override
  void onViewModelReady(UniqueCredentialViewModel viewModel) {
    viewModel.init(iwkType);
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(
    BuildContext context,
    UniqueCredentialViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(title: Text('Setup $iwkType')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.qr_code_scanner, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            Text(
              'Enter GUID for $iwkType',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Please enter the unique identifier for your device or scan QR code.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            if (viewModel.requiresGuid) ...[
              TextField(
                controller: viewModel.guidController,
                decoration: const InputDecoration(
                  labelText: 'GUID',
                  hintText: 'e.g. 1234-5678-90ab',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.vpn_key),
                ),
              ),
              const SizedBox(height: 20),
            ],
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => viewModel.submit(iwkType),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Connect to Module',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: viewModel.requiresGuid
          ? FloatingActionButton.extended(
              onPressed: () async {
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const QRScannerView(),
                  ),
                );
                if (result != null && result is String) {
                  viewModel.guidController.text = result;
                }
              },
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Scan QR'),
              backgroundColor: Colors.blue,
            )
          : null,
    );
  }

  @override
  UniqueCredentialViewModel viewModelBuilder(BuildContext context) =>
      UniqueCredentialViewModel();
}
