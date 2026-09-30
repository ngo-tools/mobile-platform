import 'dart:async';

import 'package:flutter/widgets.dart';

import 'chat_exception.dart';
import 'chat_session.dart';

/// Pauses syncing while the app is in the background and resumes it in the
/// foreground. On iOS this frees the store for the notification extension.
///
/// `inactive` (e.g. control center, incoming call) keeps the sync running.
class ChatLifecycleObserver with WidgetsBindingObserver {
  ChatLifecycleObserver(ChatSession session)
    : this.fromCallbacks(pause: session.pause, resume: session.resume);

  @visibleForTesting
  ChatLifecycleObserver.fromCallbacks({
    required Future<void> Function() pause,
    required Future<void> Function() resume,
  }) : _pause = pause,
       _resume = resume;

  final Future<void> Function() _pause;
  final Future<void> Function() _resume;
  bool _paused = false;
  Future<void> _pending = Future.value();

  /// Starts following the app lifecycle.
  void attach() => WidgetsBinding.instance.addObserver(this);

  void detach() => WidgetsBinding.instance.removeObserver(this);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.hidden ||
          AppLifecycleState.paused ||
          AppLifecycleState.detached:
        if (!_paused) {
          _paused = true;
          _enqueue(_pause);
        }
      case AppLifecycleState.resumed:
        if (_paused) {
          _paused = false;
          _enqueue(_resume);
        }
      case AppLifecycleState.inactive:
        break;
    }
  }

  /// Completes once all lifecycle transitions so far are applied.
  Future<void> get settled => _pending;

  /// Transitions run one after another; a failed resume (session expired or
  /// locked) is reported through the session state, not here.
  void _enqueue(Future<void> Function() transition) {
    _pending = _pending.then((_) async {
      try {
        await transition();
      } on ChatException catch (error) {
        debugPrint('Chat lifecycle transition failed: $error');
      }
    });
  }
}
