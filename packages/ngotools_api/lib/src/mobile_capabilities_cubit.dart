import 'dart:async';

import 'package:bloc/bloc.dart';

import 'mobile_api_problem.dart';
import 'mobile_runtime_capabilities.dart';
import 'ngo_tools_mobile_api.dart';

/// Lifecycle of the effective server capability snapshot.
enum MobileCapabilitiesStatus { initial, loading, ready, refreshing, failed }

/// Immutable state exposed by [MobileCapabilitiesCubit].
final class MobileCapabilitiesState {
  /// Creates capability state without raw transport data.
  const MobileCapabilitiesState({
    this.status = MobileCapabilitiesStatus.initial,
    this.capabilities,
    this.problem,
  });

  /// Current loading lifecycle.
  final MobileCapabilitiesStatus status;

  /// Last successfully loaded snapshot.
  final MobileRuntimeCapabilities? capabilities;

  /// Last sanitized loading failure.
  final MobileApiProblem? problem;
}

/// Keeps effective capabilities current for navigation and feature gates.
final class MobileCapabilitiesCubit extends Cubit<MobileCapabilitiesState> {
  /// Creates a capability store and listens for access invalidations.
  MobileCapabilitiesCubit(this._api) : super(const MobileCapabilitiesState()) {
    _invalidationSubscription = _api.capabilityInvalidations.listen((_) {
      unawaited(refresh());
    });
  }

  final NgoToolsMobileApi _api;
  late final StreamSubscription<void> _invalidationSubscription;
  Future<void>? _activeLoad;
  bool _refreshQueued = false;

  /// Loads capabilities when no snapshot exists yet.
  Future<void> load() async {
    if (state.capabilities != null) {
      return;
    }

    await _startLoad(refreshing: false);
  }

  /// Refreshes capabilities while preserving the last successful snapshot.
  Future<void> refresh() async {
    if (_activeLoad != null) {
      _refreshQueued = true;
      await _activeLoad;

      return;
    }

    await _startLoad(refreshing: state.capabilities != null);
  }

  Future<void> _startLoad({required bool refreshing}) {
    final active = _activeLoad;

    if (active != null) {
      return active;
    }

    final operation = _performLoad(refreshing: refreshing);
    _activeLoad = operation;

    return operation;
  }

  Future<void> _performLoad({required bool refreshing}) async {
    emit(
      MobileCapabilitiesState(
        status: refreshing
            ? MobileCapabilitiesStatus.refreshing
            : MobileCapabilitiesStatus.loading,
        capabilities: state.capabilities,
      ),
    );

    try {
      final capabilities = await _api.fetchCapabilities();
      emit(
        MobileCapabilitiesState(
          status: MobileCapabilitiesStatus.ready,
          capabilities: capabilities,
        ),
      );
    } on MobileApiException catch (error) {
      emit(
        MobileCapabilitiesState(
          status: MobileCapabilitiesStatus.failed,
          capabilities: state.capabilities,
          problem: error.problem,
        ),
      );
    } finally {
      _activeLoad = null;

      if (_refreshQueued) {
        _refreshQueued = false;
        unawaited(_startLoad(refreshing: state.capabilities != null));
      }
    }
  }

  @override
  Future<void> close() async {
    await _invalidationSubscription.cancel();
    await super.close();
  }
}
