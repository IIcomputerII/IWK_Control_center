import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import '../ui/views/login_view.dart';
import '../ui/views/dashboard_view.dart';
import '../ui/views/chooseiwk_view.dart';
import '../ui/views/uniquecredential_view.dart';
import '../ui/views/iwkpage/waterpage_view.dart';
import '../ui/views/iwkpage/sagapage_view.dart';
import '../ui/views/iwkpage/envpage_view.dart';
import '../ui/views/iwkpage/gravity_view.dart';
import '../ui/views/iwkpage/homepage._view.dart';
import '../services/message_broker_service.dart';
import '../services/storage_service.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: LoginView, initial: true),
    MaterialRoute(page: DashboardView),
    MaterialRoute(page: ChooseIwkView),
    MaterialRoute(page: UniqueCredentialView),
    MaterialRoute(page: WaterPageView),
    MaterialRoute(page: SagaPageView),
    MaterialRoute(page: EnvPageView),
    MaterialRoute(page: GravityView),
    MaterialRoute(page: HomePageView),
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: MessageBrokerService),
    LazySingleton(classType: StorageService),
  ],
)
class App {}
