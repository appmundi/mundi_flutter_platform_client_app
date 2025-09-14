// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_state.dart';

// **************************************************************************
// MatchExtensionGenerator
// **************************************************************************

extension SearchStateStatusMatch on SearchStateStatus {
  T match<T>(
      {required T Function() initial,
      required T Function() loading,
      required T Function() error,
      required T Function() loaded}) {
    final v = this;
    if (v == SearchStateStatus.initial) {
      return initial();
    }

    if (v == SearchStateStatus.loading) {
      return loading();
    }

    if (v == SearchStateStatus.error) {
      return error();
    }

    if (v == SearchStateStatus.loaded) {
      return loaded();
    }

    throw Exception(
        'SearchStateStatus.match failed, found no match for: $this');
  }

  T matchAny<T>(
      {required T Function() any,
      T Function()? initial,
      T Function()? loading,
      T Function()? error,
      T Function()? loaded}) {
    final v = this;
    if (v == SearchStateStatus.initial && initial != null) {
      return initial();
    }

    if (v == SearchStateStatus.loading && loading != null) {
      return loading();
    }

    if (v == SearchStateStatus.error && error != null) {
      return error();
    }

    if (v == SearchStateStatus.loaded && loaded != null) {
      return loaded();
    }

    return any();
  }
}
