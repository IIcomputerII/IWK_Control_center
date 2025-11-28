import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../viewmodels/iwkpage/gravity_view_modal.dart';
import '../../../app/app.locator.dart';
import '../../widgets/gravity/gravitycard.dart'; // NEW: Import Gravitycard widget

class GravityView extends StackedView<GravityViewModel> {
  final String? topic;
  final String? guid;
  const GravityView({Key? key, this.topic, this.guid}) : super(key: key);

  @override
  void onViewModelReady(GravityViewModel viewModel) {
    viewModel.init(guid, topic);
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(
    BuildContext context,
    GravityViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text(
          'Center of Gravity',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Column(
        children: [
          // Empty header space
          Container(height: 60, color: Colors.grey.shade300),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: viewModel.logs.length,
              itemBuilder: (context, index) {
                // NEW: Using Gravitycard widget instead of inline builder
                final logData = viewModel.logs[index];
                final weightData = _parseWeightData(logData);
                return Gravitycard(
                  date: _extractDate(logData),
                  clock: _extractTime(logData),
                  weight: weightData['weight'] ?? '0.00',
                  deviceId: guid ?? 'd663da48-0c97-452b-97ab-35b1cb531385',
                );
                // OLD: return _buildGravityCard(viewModel.logs[index], guid);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'scroll_up',
            mini: true,
            backgroundColor: Colors.blue,
            onPressed: () {
              // Scroll to top
            },
            child: const Icon(Icons.arrow_upward),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: 'reset',
            backgroundColor: Colors.red,
            onPressed: () {
              // Navigate back to Dashboard
              locator<NavigationService>().back();
              locator<NavigationService>().back();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('RESET'),
          ),
        ],
      ),
    );
  }

  // OLD CODE: Commented out - using Gravitycard widget instead
  // Widget _buildGravityCard(String logData, String? guid) {
  //   final weightData = _parseWeightData(logData);
  //
  //   return Card(
  //     margin: const EdgeInsets.only(bottom: 16),
  //     color: Colors.grey.shade200,
  //     elevation: 1,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16),
  //       child: Column(
  //         children: [
  //           Row(
  //             children: [
  //               Icon(Icons.scale, size: 40, color: Colors.grey.shade600),
  //               const SizedBox(width: 16),
  //               Expanded(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     const Text('TIMBANGAN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
  //                     const SizedBox(height: 4),
  //                     Text(guid ?? 'd663da48-0c97-452b-97ab-35b1cb531385',
  //                       style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
  //                   ],
  //                 ),
  //               ),
  //               Column(
  //                 crossAxisAlignment: CrossAxisAlignment.end,
  //                 children: [
  //                   Text(_extractDate(logData), style: const TextStyle(fontSize: 11)),
  //                   Text(_extractTime(logData), style: const TextStyle(fontSize: 11)),
  //                 ],
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 20),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             crossAxisAlignment: CrossAxisAlignment.baseline,
  //             textBaseline: TextBaseline.alphabetic,
  //             children: [
  //               Text(weightData['weight'] ?? '0.00',
  //                 style: TextStyle(fontSize: 50, fontWeight: FontWeight.w300, color: Colors.grey.shade700)),
  //               Text('gram',
  //                 style: TextStyle(fontSize: 28, fontWeight: FontWeight.w300, color: Colors.grey.shade600)),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Map<String, String> _parseWeightData(String logData) {
    final result = {'weight': '0.00'};

    // Extract weight from GUID#Weight format
    // Log format: "[15:39:54] ae4fc711-2715-4615-b68e-ab5b527e2a76#0.02"
    if (logData.contains('#')) {
      final hashIndex = logData.indexOf('#');
      final weightPart = logData.substring(hashIndex + 1).trim();
      // Remove any non-numeric characters except dot and minus
      final cleanWeight = weightPart.replaceAll(RegExp(r'[^\d\.\-]'), '');
      if (cleanWeight.isNotEmpty) {
        result['weight'] = cleanWeight;
      }
    }

    return result;
  }

  String _extractDate(String logData) {
    if (logData.contains('[') && logData.contains(']')) {
      final date = DateTime.now();
      return '${date.day} June ${date.year}';
    }
    return '27 June 2022';
  }

  String _extractTime(String logData) {
    if (logData.contains('[') && logData.contains(']')) {
      return logData.substring(logData.indexOf('[') + 1, logData.indexOf(']'));
    }
    return '23:33:52';
  }

  @override
  GravityViewModel viewModelBuilder(BuildContext context) => GravityViewModel();
}
