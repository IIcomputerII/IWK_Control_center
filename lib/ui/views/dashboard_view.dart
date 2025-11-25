import 'package:flutter/material.dart';
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
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade700,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo.shade700, Colors.indigo.shade200],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.95,
            ),
            itemCount: viewModel.modules.length,
            itemBuilder: (context, index) {
              final module = viewModel.modules[index];
              return _buildModuleCard(module, viewModel, context);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildModuleCard(
    String module,
    DashboardViewModel viewModel,
    BuildContext context,
  ) {
    IconData iconData;
    Color primaryColor;
    Color backgroundColor;
    String emoji;

    switch (module) {
      case 'Smart Watering':
        iconData = Icons.water_drop;
        primaryColor = Colors.green.shade700;
        backgroundColor = Colors.green.shade50;
        emoji = '💧';
        break;
      case 'Smart Saga':
        iconData = Icons.credit_card;
        primaryColor = Colors.purple.shade700;
        backgroundColor = Colors.purple.shade50;
        emoji = '🎴';
        break;
      case 'Environmental Sensor':
        iconData = Icons.thermostat;
        primaryColor = Colors.orange.shade700;
        backgroundColor = Colors.orange.shade50;
        emoji = '🌡️';
        break;
      case 'Center of Gravity':
        iconData = Icons.scale;
        primaryColor = Colors.blue.shade800;
        backgroundColor = Colors.blue.shade50;
        emoji = '⚖️';
        break;
      case 'Home Automation':
        iconData = Icons.home_outlined;
        primaryColor = Colors.cyan.shade700;
        backgroundColor = Colors.cyan.shade50;
        emoji = '🏠';
        break;
      default:
        iconData = Icons.devices;
        primaryColor = Colors.grey.shade700;
        backgroundColor = Colors.grey.shade50;
        emoji = '📱';
    }

    return Card(
      elevation: 8,
      shadowColor: primaryColor.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () => viewModel.selectModule(module),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [backgroundColor, primaryColor.withOpacity(0.1)],
            ),
            border: Border.all(color: primaryColor.withOpacity(0.3), width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with background
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: primaryColor.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Icon(iconData, size: 40, color: primaryColor),
              ),
              const SizedBox(height: 12),
              // Module name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  module,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              // Emoji
              Text(emoji, style: const TextStyle(fontSize: 24)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  DashboardViewModel viewModelBuilder(BuildContext context) =>
      DashboardViewModel();
}
