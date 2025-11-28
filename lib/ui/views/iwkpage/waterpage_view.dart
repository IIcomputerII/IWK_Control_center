import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../viewmodels/iwkpage/waterpage_view_modal.dart';
import '../../../app/app.locator.dart';
import '../../widgets/water/watercard.dart';

class WaterPageView extends StackedView<WaterPageViewModel> {
  final String? topic;
  final String? guid;
  const WaterPageView({Key? key, this.topic, this.guid}) : super(key: key);

  @override
  void onViewModelReady(WaterPageViewModel viewModel) {
    viewModel.init(guid, topic);
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(
    BuildContext context,
    WaterPageViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: const Text(
          'SMART WATERING',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade700,
      ),
      body: viewModel.dataList.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: viewModel.dataList.length,
              itemBuilder: (context, index) {
                final data = viewModel.dataList[index];
                return Watercard(
                  date: data.date,
                  clock: data.clock,
                  statusPompa: data.statusPompa,
                  statusSoil: data.statusSoil,
                  kelembaban: data.kelembaban,
                  deviceId: data.deviceId,
                );
              },
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.water_drop_outlined,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Waiting for data from device...',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'GUID: ${guid ?? "N/A"}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  if (topic != null)
                    Text(
                      'Topic: $topic',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.red,
        onPressed: () {
          locator<NavigationService>().back();
          locator<NavigationService>().back();
        },
        icon: const Icon(Icons.refresh),
        label: const Text('RESET'),
      ),
    );
  }

  @override
  WaterPageViewModel viewModelBuilder(BuildContext context) =>
      WaterPageViewModel();
}
