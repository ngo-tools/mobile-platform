import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ngotools_api/ngotools_api.dart';
import 'package:ngotools_design_system/ngotools_design_system.dart';

import 'chat_gateway.dart';
import 'chat_labels.dart';

/// A direct chat started from the address book.
final class ChatStartedDirectChat {
  /// Creates the result.
  const ChatStartedDirectChat({required this.roomId, required this.name});

  /// Room of the direct chat.
  final String roomId;

  /// Name of the person.
  final String name;
}

/// Starts a direct chat with a person from the organization's address book.
/// Pops with a [ChatStartedDirectChat].
final class ChatNewChatPage extends StatefulWidget {
  /// Creates the page.
  const ChatNewChatPage({
    required this.api,
    required this.gateway,
    required this.labels,
    this.searchDelay = const Duration(milliseconds: 300),
    super.key,
  });

  /// NGO.Tools address book.
  final MobileChatApi api;

  /// Chat access.
  final ChatGateway gateway;

  /// Texts.
  final ChatLabels labels;

  /// Pause after typing before searching.
  final Duration searchDelay;

  @override
  State<ChatNewChatPage> createState() => _ChatNewChatPageState();
}

final class _ChatNewChatPageState extends State<ChatNewChatPage> {
  final _people = <MobileChatPerson>[];
  Timer? _debounce;
  String _query = '';
  int _page = 0;
  bool _hasMore = true;
  bool _loading = false;
  bool _failed = false;
  String? _opening;
  int _generation = 0;

  @override
  void initState() {
    super.initState();
    unawaited(_load(reset: true));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _load({required bool reset}) async {
    if (!reset && (_loading || !_hasMore)) {
      return;
    }

    final generation = reset ? ++_generation : _generation;
    final page = reset ? 1 : _page + 1;

    setState(() {
      _loading = true;
      _failed = false;

      if (reset) {
        _people.clear();
      }
    });

    try {
      final result = await widget.api.listChatPeople(
        search: _query,
        page: page,
        perPage: 30,
      );

      if (!mounted || generation != _generation) {
        return;
      }

      setState(() {
        _people.addAll(result.people);
        _page = result.page;
        _hasMore = result.hasMore;
      });
    } on Object {
      if (mounted && generation == _generation) {
        setState(() => _failed = true);
      }
    } finally {
      if (mounted && generation == _generation) {
        setState(() => _loading = false);
      }
    }
  }

  void _onQuery(String query) {
    _debounce?.cancel();
    _debounce = Timer(widget.searchDelay, () {
      _query = query.trim();
      unawaited(_load(reset: true));
    });
  }

  Future<void> _open(MobileChatPerson person) async {
    setState(() => _opening = person.matrixUserId);

    try {
      final roomId = await widget.gateway.createDirectChat(person.matrixUserId);

      if (mounted) {
        Navigator.of(
          context,
        ).pop(ChatStartedDirectChat(roomId: roomId, name: person.displayName));
      }
    } on Object {
      if (mounted) {
        ScaffoldMessenger.maybeOf(
          context,
        )?.showSnackBar(SnackBar(content: Text(widget.labels.actionFailed)));
      }
    } finally {
      if (mounted) {
        setState(() => _opening = null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final labels = widget.labels;

    return Scaffold(
      appBar: AppBar(title: Text(labels.newChat)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(NgoToolsLayout.spacing),
            child: TextField(
              autofocus: true,
              onChanged: _onQuery,
              decoration: InputDecoration(
                hintText: labels.peopleSearchHint,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          Expanded(child: _results(labels)),
        ],
      ),
    );
  }

  Widget _results(ChatLabels labels) {
    if (_failed && _people.isEmpty) {
      return NgoToolsEmptyState(
        icon: Icons.cloud_off_outlined,
        title: labels.peopleUnavailable,
        message: '',
        action: FilledButton(
          onPressed: () => _load(reset: true),
          child: Text(labels.retry),
        ),
      );
    }

    if (_people.isEmpty) {
      return _loading
          ? const Center(child: CircularProgressIndicator())
          : NgoToolsEmptyState(
              icon: Icons.person_search_outlined,
              title: labels.noPeople,
              message: '',
            );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.extentAfter < 400) {
          unawaited(_load(reset: false));
        }

        return false;
      },
      child: ListView.builder(
        itemCount: _people.length + (_loading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= _people.length) {
            return const Padding(
              padding: EdgeInsets.all(NgoToolsLayout.spacing),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final person = _people[index];
          final opening = _opening == person.matrixUserId;

          return ListTile(
            leading: NgoToolsAvatar(name: person.displayName),
            title: Text(person.displayName),
            subtitle: Text(
              person.kind == MobileChatPersonKind.teamMember
                  ? labels.teamMember
                  : labels.contact,
            ),
            trailing: opening
                ? const SizedBox.square(
                    dimension: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.chat_bubble_outline),
            enabled: _opening == null,
            onTap: () => _open(person),
          );
        },
      ),
    );
  }
}
