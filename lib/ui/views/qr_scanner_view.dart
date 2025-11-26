import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerView extends StatefulWidget {
  const QRScannerView({super.key});

  @override
  State<QRScannerView> createState() => _QRScannerViewState();
}

class _QRScannerViewState extends State<QRScannerView> {
  final MobileScannerController cameraController = MobileScannerController();
  bool _hasScanned = false; // Prevent multiple scans

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _handleBarcode(String code) {
    if (_hasScanned) return; // Prevent duplicate scans

    _hasScanned = true;

    // Dispose camera before navigating
    cameraController.stop();

    // Navigate back with result after a short delay to ensure camera cleanup
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        Navigator.of(context).pop(code);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            iconSize: 32.0,
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              if (_hasScanned) return; // Extra safety check

              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                final String? code = barcode.rawValue;
                if (code != null && code.isNotEmpty) {
                  _handleBarcode(code);
                  return;
                }
              }
            },
          ),
          // Overlay with scanning frame
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 3),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          // Instructions
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.black54,
              child: const Text(
                'Position the QR code within the frame',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
