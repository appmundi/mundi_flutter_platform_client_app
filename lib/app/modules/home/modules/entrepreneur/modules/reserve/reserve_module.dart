import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mundi_flutter_platform_client_app/app/core/storage/local_storage.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/entrepreneur/modules/reserve/cubit/reserve_cubit.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/entrepreneur/modules/reserve/reserve_page.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/reserve/i_reserve_repository.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/reserve/reserve_repository.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/user_address/i_user_address_repository.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/user_address/user_address_repository.dart';

import '../../../../../../core/rest/rest_client.dart';

class ReserveModule extends Module {
  @override
  void binds(Injector i) {
    i.addInstance<IReserveRepository>(
      ReserveRepository(
        rest: Modular.get<RestClient>(),
        localStorage: Modular.get<LocalStorage>()
      ),
    );
    // A tela de reserva pré-carrega o endereço salvo mais recente pra
    // sugerir como padrão (ver ReservePage._loadDefaultAddress).
    i.addInstance<IUserAddressRepository>(
      UserAddressRepository(
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
      child: (context) => BlocProvider(
        create: (context) =>
            ReserveCubit(reserveRepository: Modular.get<IReserveRepository>()),
        child: ReservePage(
          reservePageArguments: r.args.data,
        ),
      ),
    );
  }
}
