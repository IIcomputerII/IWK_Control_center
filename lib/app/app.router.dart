// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i11;
import 'package:flutter/material.dart';
import 'package:iwk_control_center/ui/views/chooseiwk_view.dart' as _i4;
import 'package:iwk_control_center/ui/views/dashboard_view.dart' as _i3;
import 'package:iwk_control_center/ui/views/iwkpage/envpage_view.dart' as _i8;
import 'package:iwk_control_center/ui/views/iwkpage/gravity_view.dart' as _i9;
import 'package:iwk_control_center/ui/views/iwkpage/homepage._view.dart'
    as _i10;
import 'package:iwk_control_center/ui/views/iwkpage/sagapage_view.dart' as _i7;
import 'package:iwk_control_center/ui/views/iwkpage/waterpage_view.dart' as _i6;
import 'package:iwk_control_center/ui/views/login_view.dart' as _i2;
import 'package:iwk_control_center/ui/views/uniquecredential_view.dart' as _i5;
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i12;

class Routes {
  static const loginView = '/';

  static const dashboardView = '/dashboard-view';

  static const chooseIwkView = '/choose-iwk-view';

  static const uniqueCredentialView = '/unique-credential-view';

  static const waterPageView = '/water-page-view';

  static const sagaPageView = '/saga-page-view';

  static const envPageView = '/env-page-view';

  static const gravityView = '/gravity-view';

  static const homePageView = '/home-page-view';

  static const all = <String>{
    loginView,
    dashboardView,
    chooseIwkView,
    uniqueCredentialView,
    waterPageView,
    sagaPageView,
    envPageView,
    gravityView,
    homePageView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(Routes.loginView, page: _i2.LoginView),
    _i1.RouteDef(Routes.dashboardView, page: _i3.DashboardView),
    _i1.RouteDef(Routes.chooseIwkView, page: _i4.ChooseIwkView),
    _i1.RouteDef(Routes.uniqueCredentialView, page: _i5.UniqueCredentialView),
    _i1.RouteDef(Routes.waterPageView, page: _i6.WaterPageView),
    _i1.RouteDef(Routes.sagaPageView, page: _i7.SagaPageView),
    _i1.RouteDef(Routes.envPageView, page: _i8.EnvPageView),
    _i1.RouteDef(Routes.gravityView, page: _i9.GravityView),
    _i1.RouteDef(Routes.homePageView, page: _i10.HomePageView),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.LoginView: (data) {
      final args = data.getArgs<LoginViewArguments>(
        orElse: () => const LoginViewArguments(),
      );
      return _i11.MaterialPageRoute<dynamic>(
        builder: (context) => _i2.LoginView(key: args.key),
        settings: data,
      );
    },
    _i3.DashboardView: (data) {
      final args = data.getArgs<DashboardViewArguments>(
        orElse: () => const DashboardViewArguments(),
      );
      return _i11.MaterialPageRoute<dynamic>(
        builder: (context) => _i3.DashboardView(key: args.key),
        settings: data,
      );
    },
    _i4.ChooseIwkView: (data) {
      final args = data.getArgs<ChooseIwkViewArguments>(
        orElse: () => const ChooseIwkViewArguments(),
      );
      return _i11.MaterialPageRoute<dynamic>(
        builder: (context) => _i4.ChooseIwkView(key: args.key),
        settings: data,
      );
    },
    _i5.UniqueCredentialView: (data) {
      final args = data.getArgs<UniqueCredentialViewArguments>(nullOk: false);
      return _i11.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i5.UniqueCredentialView(key: args.key, iwkType: args.iwkType),
        settings: data,
      );
    },
    _i6.WaterPageView: (data) {
      final args = data.getArgs<WaterPageViewArguments>(
        orElse: () => const WaterPageViewArguments(),
      );
      return _i11.MaterialPageRoute<dynamic>(
        builder: (context) => _i6.WaterPageView(
          key: args.key,
          topic: args.topic,
          guid: args.guid,
        ),
        settings: data,
      );
    },
    _i7.SagaPageView: (data) {
      final args = data.getArgs<SagaPageViewArguments>(
        orElse: () => const SagaPageViewArguments(),
      );
      return _i11.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i7.SagaPageView(key: args.key, topic: args.topic, guid: args.guid),
        settings: data,
      );
    },
    _i8.EnvPageView: (data) {
      final args = data.getArgs<EnvPageViewArguments>(
        orElse: () => const EnvPageViewArguments(),
      );
      return _i11.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i8.EnvPageView(key: args.key, topic: args.topic, guid: args.guid),
        settings: data,
      );
    },
    _i9.GravityView: (data) {
      final args = data.getArgs<GravityViewArguments>(
        orElse: () => const GravityViewArguments(),
      );
      return _i11.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i9.GravityView(key: args.key, topic: args.topic, guid: args.guid),
        settings: data,
      );
    },
    _i10.HomePageView: (data) {
      final args = data.getArgs<HomePageViewArguments>(
        orElse: () => const HomePageViewArguments(),
      );
      return _i11.MaterialPageRoute<dynamic>(
        builder: (context) => _i10.HomePageView(
          key: args.key,
          topic: args.topic,
          guid: args.guid,
        ),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class LoginViewArguments {
  const LoginViewArguments({this.key});

  final _i11.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant LoginViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class DashboardViewArguments {
  const DashboardViewArguments({this.key});

  final _i11.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant DashboardViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class ChooseIwkViewArguments {
  const ChooseIwkViewArguments({this.key});

  final _i11.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant ChooseIwkViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class UniqueCredentialViewArguments {
  const UniqueCredentialViewArguments({this.key, required this.iwkType});

  final _i11.Key? key;

  final String iwkType;

  @override
  String toString() {
    return '{"key": "$key", "iwkType": "$iwkType"}';
  }

  @override
  bool operator ==(covariant UniqueCredentialViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.iwkType == iwkType;
  }

  @override
  int get hashCode {
    return key.hashCode ^ iwkType.hashCode;
  }
}

class WaterPageViewArguments {
  const WaterPageViewArguments({this.key, this.topic, this.guid});

  final _i11.Key? key;

  final String? topic;

  final String? guid;

  @override
  String toString() {
    return '{"key": "$key", "topic": "$topic", "guid": "$guid"}';
  }

  @override
  bool operator ==(covariant WaterPageViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.topic == topic && other.guid == guid;
  }

  @override
  int get hashCode {
    return key.hashCode ^ topic.hashCode ^ guid.hashCode;
  }
}

class SagaPageViewArguments {
  const SagaPageViewArguments({this.key, this.topic, this.guid});

  final _i11.Key? key;

  final String? topic;

  final String? guid;

  @override
  String toString() {
    return '{"key": "$key", "topic": "$topic", "guid": "$guid"}';
  }

  @override
  bool operator ==(covariant SagaPageViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.topic == topic && other.guid == guid;
  }

  @override
  int get hashCode {
    return key.hashCode ^ topic.hashCode ^ guid.hashCode;
  }
}

class EnvPageViewArguments {
  const EnvPageViewArguments({this.key, this.topic, this.guid});

  final _i11.Key? key;

  final String? topic;

  final String? guid;

  @override
  String toString() {
    return '{"key": "$key", "topic": "$topic", "guid": "$guid"}';
  }

  @override
  bool operator ==(covariant EnvPageViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.topic == topic && other.guid == guid;
  }

  @override
  int get hashCode {
    return key.hashCode ^ topic.hashCode ^ guid.hashCode;
  }
}

class GravityViewArguments {
  const GravityViewArguments({this.key, this.topic, this.guid});

  final _i11.Key? key;

  final String? topic;

  final String? guid;

  @override
  String toString() {
    return '{"key": "$key", "topic": "$topic", "guid": "$guid"}';
  }

  @override
  bool operator ==(covariant GravityViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.topic == topic && other.guid == guid;
  }

  @override
  int get hashCode {
    return key.hashCode ^ topic.hashCode ^ guid.hashCode;
  }
}

class HomePageViewArguments {
  const HomePageViewArguments({this.key, this.topic, this.guid});

  final _i11.Key? key;

  final String? topic;

  final String? guid;

  @override
  String toString() {
    return '{"key": "$key", "topic": "$topic", "guid": "$guid"}';
  }

  @override
  bool operator ==(covariant HomePageViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.topic == topic && other.guid == guid;
  }

  @override
  int get hashCode {
    return key.hashCode ^ topic.hashCode ^ guid.hashCode;
  }
}

extension NavigatorStateExtension on _i12.NavigationService {
  Future<dynamic> navigateToLoginView({
    _i11.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.loginView,
      arguments: LoginViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToDashboardView({
    _i11.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.dashboardView,
      arguments: DashboardViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToChooseIwkView({
    _i11.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.chooseIwkView,
      arguments: ChooseIwkViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToUniqueCredentialView({
    _i11.Key? key,
    required String iwkType,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.uniqueCredentialView,
      arguments: UniqueCredentialViewArguments(key: key, iwkType: iwkType),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToWaterPageView({
    _i11.Key? key,
    String? topic,
    String? guid,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.waterPageView,
      arguments: WaterPageViewArguments(key: key, topic: topic, guid: guid),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToSagaPageView({
    _i11.Key? key,
    String? topic,
    String? guid,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.sagaPageView,
      arguments: SagaPageViewArguments(key: key, topic: topic, guid: guid),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToEnvPageView({
    _i11.Key? key,
    String? topic,
    String? guid,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.envPageView,
      arguments: EnvPageViewArguments(key: key, topic: topic, guid: guid),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToGravityView({
    _i11.Key? key,
    String? topic,
    String? guid,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.gravityView,
      arguments: GravityViewArguments(key: key, topic: topic, guid: guid),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToHomePageView({
    _i11.Key? key,
    String? topic,
    String? guid,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.homePageView,
      arguments: HomePageViewArguments(key: key, topic: topic, guid: guid),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithLoginView({
    _i11.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.loginView,
      arguments: LoginViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithDashboardView({
    _i11.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.dashboardView,
      arguments: DashboardViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithChooseIwkView({
    _i11.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.chooseIwkView,
      arguments: ChooseIwkViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithUniqueCredentialView({
    _i11.Key? key,
    required String iwkType,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.uniqueCredentialView,
      arguments: UniqueCredentialViewArguments(key: key, iwkType: iwkType),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithWaterPageView({
    _i11.Key? key,
    String? topic,
    String? guid,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.waterPageView,
      arguments: WaterPageViewArguments(key: key, topic: topic, guid: guid),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithSagaPageView({
    _i11.Key? key,
    String? topic,
    String? guid,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.sagaPageView,
      arguments: SagaPageViewArguments(key: key, topic: topic, guid: guid),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithEnvPageView({
    _i11.Key? key,
    String? topic,
    String? guid,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.envPageView,
      arguments: EnvPageViewArguments(key: key, topic: topic, guid: guid),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithGravityView({
    _i11.Key? key,
    String? topic,
    String? guid,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.gravityView,
      arguments: GravityViewArguments(key: key, topic: topic, guid: guid),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithHomePageView({
    _i11.Key? key,
    String? topic,
    String? guid,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.homePageView,
      arguments: HomePageViewArguments(key: key, topic: topic, guid: guid),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }
}
