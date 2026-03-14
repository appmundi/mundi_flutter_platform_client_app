import 'package:flutter_modular/flutter_modular.dart';
import 'package:mundi_flutter_platform_client_app/app/core/rest/rest_client.dart';
import 'package:mundi_flutter_platform_client_app/app/core/storage/local_storage.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/profile/modules/details/details_profile_module.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/profile/profile_page.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/auth/auth_repository.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/auth/i_auth_repository.dart';

class ProfileModule extends Module {
  @override
  void exportedBinds(Injector i) {
    i.addLazySingleton<IAuthRepository>(
      () => AuthRepository(
        rest: Modular.get<RestClient>(),
        LocalStorage: Modular.get<LocalStorage>(),
      ),
    );
  }

  @override
  void binds(Injector i) {
    i.addLazySingleton<IAuthRepository>(
      () => AuthRepository(
        rest: Modular.get<RestClient>(),
        LocalStorage: Modular.get<LocalStorage>(),
      ),
    );
  }

  @override
  void routes(RouteManager r) {
    super.routes(r);
    r.child(
      '/',
        child: (context) =>  const ProfilePage(),
    );
    r.module(
      "/details",
      module: DetailsProfileModule(),
    );
  }
}
