// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'details_profile_state.dart';

// **************************************************************************
// MatchExtensionGenerator
// **************************************************************************

extension DetailsProfileStatusMatch on DetailsProfileStatus {
  T match<T>(
      {required T Function() init,
      required T Function() loading,
      required T Function() success,
      required T Function() error,
      required T Function() updated}) {
    final v = this;
    if (v == DetailsProfileStatus.init) {
      return init();
    }

    if (v == DetailsProfileStatus.loading) {
      return loading();
    }

    if (v == DetailsProfileStatus.success) {
      return success();
    }

    if (v == DetailsProfileStatus.error) {
      return error();
    }

    if (v == DetailsProfileStatus.updated) {
      return updated();
    }

    throw Exception(
        'DetailsProfileStatus.match failed, found no match for: $this');
  }

  T matchAny<T>(
      {required T Function() any,
      T Function()? init,
      T Function()? loading,
      T Function()? success,
      T Function()? error,
      T Function()? updated}) {
    final v = this;
    if (v == DetailsProfileStatus.init && init != null) {
      return init();
    }

    if (v == DetailsProfileStatus.loading && loading != null) {
      return loading();
    }

    if (v == DetailsProfileStatus.success && success != null) {
      return success();
    }

    if (v == DetailsProfileStatus.error && error != null) {
      return error();
    }

    if (v == DetailsProfileStatus.updated && updated != null) {
      return updated();
    }

    return any();
  }
}
