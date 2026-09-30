import 'dart:async';

import 'package:flutter/widgets.dart';

import 'chat_client.dart';
import 'chat_connection_state.dart';
import 'chat_connector.dart';

/// Follows the app lifecycle for the chat: pauses syncing in the background
/// (on iOS this frees the store for the notification extension) and, back in
/// the foreground, resumes it and renews the session if needed.
final class ChatAppLifecycle with WidgetsBindingObserver {
  /// Creates the observer for [connector]; call [attach] to start.
  ChatAppLifecycle(this.connector);

  /// The chat connection.
  final ChatConnector connector;

  bool _paused = false;
  Future<void> _pending = Future.value();

  /// Starts following the app lifecycle.
  void attach() => WidgetsBinding.instance.addObserver(this);

  /// Stops following the app lifecycle.
  void detach() => WidgetsBinding.instance.removeObserver(this);

  /// Completes once all transitions so far are applied.
  Future<void> get settled => _pending;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.hidden ||
          AppLifecycleState.paused ||
          AppLifecycleState.detached:
        if (!_paused) {
          _paused = true;
          _enqueue(() => _client()?.pause());
        }
      case AppLifecycleState.resumed:
        if (_paused) {
          _paused = false;
          _enqueue(() async {
            await _client()?.resume();
            await connector.refresh();
          });
        }
      case AppLifecycleState.inactive:
        break;
    }
  }

  ChatClient? _client() {
    final state = connector.state;

    return state is ChatConnected ? state.client : null;
  }

  void _enqueue(Future<void>? Function() transition) {
    _pending = _pending.then((_) async {
      try {
        await transition();
      } on Object {
        // An expired or locked session shows up in the connection state.
      }
    });
  }
}
