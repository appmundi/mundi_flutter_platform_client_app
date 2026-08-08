import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mundi_flutter_platform_client_app/app/core/rest/rest_client.dart';
import 'package:mundi_flutter_platform_client_app/app/core/storage/local_storage.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/addresses/addresses_page.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/addresses/cubit/addresses_cubit.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/cep_lookup/cep_lookup_repository.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/cep_lookup/i_cep_lookup_repository.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/user_address/i_user_address_repository.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/user_address/user_address_repository.dart';

class AddressesModule extends Module {
  @override
  void binds(Injector i) {
    i.addLazySingleton<ICepLookupRepository>(CepLookupRepository.new);
    i.addLazySingleton<IUserAddressRepository>(
      () => UserAddressRepository(
        rest: Modular.get<RestClient>(),
        localStorage: Modular.get<LocalStorage>(),
      ),
    );
  }

  @override
  void routes(RouteManager r) {
    super.routes(r);
    r.child(
      '/',
      child: (context) {
        final args = r.args.data;
        final selectMode =
            args is Map ? (args['selectMode'] as bool? ?? true) : true;
        final currentAddressId =
            args is Map ? args['currentAddressId'] as int? : null;
        return BlocProvider(
          create: (context) => AddressesCubit(
            userAddressRepository: Modular.get<IUserAddressRepository>(),
          ),
          child: AddressesPage(
            selectMode: selectMode,
            currentAddressId: currentAddressId,
          ),
        );
      },
    );
  }
}
