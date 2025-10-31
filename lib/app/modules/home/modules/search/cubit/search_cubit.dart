import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:mundi_flutter_platform_client_app/app/core/exception/connection_exception.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/search/cubit/search_state.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/address/i_address_repository.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/entrepeneur/i_entrepreneur_repository.dart';
import 'package:mundi_flutter_platform_client_app/app/models/entrepreneur.dart';

class SearchCubit extends Cubit<SearchState> {
  final IEntrepreneurRepository repository;
  final IAddressRepository addressRepository;

  List<Entrepreneur>? _originalEntrepreneurs; // Dados originais (nunca muda)
  List<Entrepreneur>? _currentEntrepreneurs; // Dados após busca por texto

  // Filtros ativos
  List<int>? _activeSpecialtyIds;
  double? _activeMaxDistance;
  double? _activeMinRating;

  SearchCubit({required this.repository, required this.addressRepository})
    : super(const SearchState.initial());

  Future<void> loadData() async {
    emit(state.copyWith(status: SearchStateStatus.loading));
    try {
      List<Entrepreneur>? entrepreneurs = await repository.searchAll();
      entrepreneurs = await _insertDistance(entrepreneurs ?? []);
      _originalEntrepreneurs = entrepreneurs;
      _currentEntrepreneurs = entrepreneurs;

      emit(
        state.copyWith(
          status: SearchStateStatus.loaded,
          entrepreneurs: entrepreneurs,
        ),
      );
    } on ConnectionException {
      emit(state.copyWith(status: SearchStateStatus.error));
    }
  }

  Future<List<Entrepreneur>> _insertDistance(List<Entrepreneur> entrepreneurs) async {
    final result = await addressRepository.calculateDistante(
      entrepreneurs ?? [],
    );

    return result;
  }

  Future<void> applyFilter(String filterText) async {
    try {
      emit(state.copyWith(status: SearchStateStatus.loading));

      final filteredEntrepreneurs = await repository.searchAll(filterText);
      _currentEntrepreneurs = filteredEntrepreneurs;

      final result = _applyAdvancedFiltersToList(_currentEntrepreneurs!);

      emit(
        state.copyWith(entrepreneurs: result, status: SearchStateStatus.loaded),
      );
    } catch (e) {
      log('Erro ao aplicar filtro de texto: $e');
      emit(
        state.copyWith(
          entrepreneurs: state.entrepreneurs,
          status: SearchStateStatus.error,
        ),
      );
    }
  }

  void applyAdvancedFilters({
    List<int>? specialtyIds,
    double? maxDistance,
    double? minRating,
  }) {
    if (_currentEntrepreneurs == null || _currentEntrepreneurs!.isEmpty) {
      return;
    }

    emit(state.copyWith(status: SearchStateStatus.loading));

    try {
      // Salvar os filtros ativos
      _activeSpecialtyIds = specialtyIds;
      _activeMaxDistance = maxDistance;
      _activeMinRating = minRating;

      final filtered = _applyAdvancedFiltersToList(_currentEntrepreneurs!);

      emit(
        state.copyWith(
          status: SearchStateStatus.loaded,
          entrepreneurs: filtered,
        ),
      );
    } catch (e) {
      log('Erro ao aplicar filtros avançados: $e');
      emit(state.copyWith(status: SearchStateStatus.error));
    }
  }

  List<Entrepreneur> _applyAdvancedFiltersToList(
    List<Entrepreneur> entrepreneurs,
  ) {
    List<Entrepreneur> filtered = List.from(entrepreneurs);

    // Filtrar por especialidades
    if (_activeSpecialtyIds != null && _activeSpecialtyIds!.isNotEmpty) {
      filtered =
          filtered.where((entrepreneur) {
            return entrepreneur.category?.any(
                  (cat) => _activeSpecialtyIds!.contains(cat.id),
                ) ??
                false;
          }).toList();
    }

    // Filtrar por distância máxima
    if (_activeMaxDistance != null && _activeMaxDistance! < 50) {
      print('tá pegando distância por nada, por');
      filtered =
          filtered.where((entrepreneur) {
            return (entrepreneur.distance ?? double.infinity) <=
                _activeMaxDistance!;
          }).toList();
    }

    // Filtrar por avaliação mínima
    if (_activeMinRating != null && _activeMinRating! > 0) {
      filtered =
          filtered.where((entrepreneur) {
            if (entrepreneur.ratings == null || entrepreneur.ratings!.isEmpty) {
              return false;
            }

            final sum = entrepreneur.ratings!.fold<double>(
              0,
              (prev, rating) => prev + (rating.rating ?? 0),
            );
            final average = sum / entrepreneur.ratings!.length;

            return average >= _activeMinRating!;
          }).toList();
    }

    // Ordenar por distância (mais próximo primeiro)
    filtered.sort((a, b) {
      final distanceA = a.distance ?? double.infinity;
      final distanceB = b.distance ?? double.infinity;
      return distanceA.compareTo(distanceB);
    });
    print(_currentEntrepreneurs?.length);
    print(filtered.length);

    return filtered;
  }

  void clearFilters() {
    if (_currentEntrepreneurs == null) {
      return;
    }

    // Limpar os filtros ativos
    _activeSpecialtyIds = null;
    _activeMaxDistance = null;
    _activeMinRating = null;

    emit(
      state.copyWith(
        status: SearchStateStatus.loaded,
        entrepreneurs: _currentEntrepreneurs,
      ),
    );
  }

  bool get hasActiveFilters {
    return (_activeSpecialtyIds != null && _activeSpecialtyIds!.isNotEmpty) ||
        (_activeMaxDistance != null && _activeMaxDistance! < 50) ||
        (_activeMinRating != null && _activeMinRating! > 0);
  }
}
