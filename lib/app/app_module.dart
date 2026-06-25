import 'package:flutter_modular/flutter_modular.dart';
import 'package:mundi_flutter_platform_client_app/app/core/helpers/environments.dart';
import 'package:mundi_flutter_platform_client_app/app/core/rest/dio/custom_dio.dart';
import 'package:mundi_flutter_platform_client_app/app/core/rest/http/http_rest_client.dart';
import 'package:mundi_flutter_platform_client_app/app/core/rest/rest_client.dart';
import 'package:mundi_flutter_platform_client_app/app/core/storage/local_storage.dart';
import 'package:mundi_flutter_platform_client_app/app/core/storage/shared_preferences/sp_local_storage.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/auth/auth_module.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/category/category_repository.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/category/i_category_repository.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/profile/modules/details/details_profile_module.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/profile/profile_module.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/splash/splash_module.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/home_module.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/notifications/notifications_module.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [NotificationsModule()];

  @override
  void exportedBinds(Injector i) {
    i.addLazySingleton<LocalStorage>(SpLocalStorage.new);
    i.addLazySingleton<RestClient>(CustomDio.new);
    i.addLazySingleton<ICategoryRepository>(
      () => CategoryRepository(rest: Modular.get<RestClient>()),
    );
  }

  @override
  void binds(Injector i) {
    i.addLazySingleton<RestClient>(CustomDio.new);
    i.addLazySingleton<LocalStorage>(SpLocalStorage.new);
    i.addLazySingleton<ICategoryRepository>(
      () => CategoryRepository(rest: Modular.get<RestClient>()),
    );
  }

  @override
  void routes(RouteManager r) {
    super.routes(r);
    r.module(
      '/splash',
      module: SplashModule(),
    );
    r.module(
      '/auth',
      module: AuthModule(),
    );
    r.module(
      '/home',
      module: HomeModule(),
    );
    r.module("/profile", module: ProfileModule());
    r.module("/detail", module: DetailsProfileModule());
  }
}
