import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../viewmodels/chooseiwk_view_modal.dart';

class ChooseIwkView extends StackedView<ChooseIwkViewModel> {
  const ChooseIwkView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ChooseIwkViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose IWK Device')),
      body: ListView.builder(
        itemCount: viewModel.options.length,
        itemBuilder: (context, index) {
          final option = viewModel.options[index];
          return ListTile(
            title: Text(option),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => viewModel.selectOption(option),
          );
        },
      ),
    );
  }

  @override
  ChooseIwkViewModel viewModelBuilder(BuildContext context) =>
      ChooseIwkViewModel();
}
