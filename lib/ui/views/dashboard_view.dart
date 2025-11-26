import 'package:flutter/material.dart';
import 'package:iwk_control_center/ui/widgets/dashboard/IWKCard.dart';
import 'package:stacked/stacked.dart';
import '../../viewmodels/dashboard_view_modal.dart';

class DashboardView extends StackedView<DashboardViewModel> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    DashboardViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'IWK Control Center',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade700,
        elevation: 0,
        actions: [
          TextButton.icon(

            label: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: viewModel.logout,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.95,
            ),
            itemCount: viewModel.cardConfigs.length, 
            itemBuilder: (context, index) {
              final config = viewModel.cardConfigs[index];
              return Iwkcard(
                config: config, 
                onTap: () => viewModel.selectModule(config),
              );
            }
          ),
        ),
      ),
    );
  }

  @override
  DashboardViewModel viewModelBuilder(BuildContext context) =>
      DashboardViewModel();
}
