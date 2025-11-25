import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../app/app.locator.dart';
import '../app/app.router.dart';

class ChooseIwkViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  final List<String> options = ['Water', 'Saga', 'Env', 'Gravity', 'Home'];

  void selectOption(String option) {
    _navigationService.navigateToUniqueCredentialView(iwkType: option);
  }
}
