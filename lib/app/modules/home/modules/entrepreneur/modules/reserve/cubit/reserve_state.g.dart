// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reserve_state.dart';

// **************************************************************************
// MatchExtensionGenerator
// **************************************************************************

extension ReserveStatusMatch on ReserveStatus {
  T match<T>(
      {required T Function() init,
      required T Function() loading,
      required T Function() loaded,
      required T Function() success,
      required T Function() error}) {
    final v = this;
    if (v == ReserveStatus.init) {
      return init();
    }

    if (v == ReserveStatus.loading) {
      return loading();
    }

    if (v == ReserveStatus.loaded) {
      return loaded();
    }

    if (v == ReserveStatus.success) {
      return success();
    }

    if (v == ReserveStatus.error) {
      return error();
    }

    throw Exception('ReserveStatus.match failed, found no match for: $this');
  }

  T matchAny<T>(
      {required T Function() any,
      T Function()? init,
      T Function()? loading,
      T Function()? loaded,
      T Function()? success,
      T Function()? error}) {
    final v = this;
    if (v == ReserveStatus.init && init != null) {
      return init();
    }

    if (v == ReserveStatus.loading && loading != null) {
      return loading();
    }

    if (v == ReserveStatus.loaded && loaded != null) {
      return loaded();
    }

    if (v == ReserveStatus.success && success != null) {
      return success();
    }

    if (v == ReserveStatus.error && error != null) {
      return error();
    }

    return any();
  }
}
