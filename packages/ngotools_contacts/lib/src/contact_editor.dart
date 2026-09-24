import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ngotools_design_system/ngotools_design_system.dart';

import 'contact_cache.dart';
import 'contact_draft_manager.dart';
import 'contact_labels.dart';
import 'contact_models.dart';

enum _ContactEditorStatus {
  editing,
  localSaved,
  submitting,
  saved,
  unsent,
  validationFailure,
  conflict,
  draftLimit,
  storageFailure,
}

/// Editor for an encrypted local draft with an explicit submit confirmation.
final class ContactEditorPage extends StatefulWidget {
  /// Creates a contact draft editor.
  const ContactEditorPage({
    required this.manager,
    required this.draft,
    required this.labels,
    super.key,
  });

  final ContactDraftManager manager;
  final ContactDraft draft;
  final ContactLabels labels;

  @override
  State<ContactEditorPage> createState() => _ContactEditorPageState();
}

final class _ContactEditorPageState extends State<ContactEditorPage> {
  final _formKey = GlobalKey<FormState>();
  late ContactDraft _draft;
  late ContactDraftKind _kind;
  late final TextEditingController _name;
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _email;
  late final TextEditingController _salutation;
  late final TextEditingController _title;
  late final TextEditingController _gender;
  late final TextEditingController _birthday;
  _ContactEditorStatus _status = _ContactEditorStatus.editing;
  ContactRecord? _savedContact;

  bool get _isEdit => _draft.contactId != null;
  bool get _isBusy =>
      _status == _ContactEditorStatus.submitting ||
      _status == _ContactEditorStatus.saved;

  @override
  void initState() {
    super.initState();
    _draft = widget.draft;
    _kind = _draft.kind;
    _name = TextEditingController(text: _draft.name);
    _firstName = TextEditingController(text: _draft.firstName);
    _lastName = TextEditingController(text: _draft.lastName);
    _email = TextEditingController(text: _draft.email);
    _salutation = TextEditingController(text: _draft.salutation);
    _title = TextEditingController(text: _draft.title);
    _gender = TextEditingController(text: _draft.gender);
    _birthday = TextEditingController(
      text: _draft.birthday?.toIso8601String().split('T').first,
    );
  }

  @override
  void dispose() {
    for (final controller in [
      _name,
      _firstName,
      _lastName,
      _email,
      _salutation,
      _title,
      _gender,
      _birthday,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        _isEdit ? widget.labels.editContact : widget.labels.newContact,
      ),
    ),
    body: SafeArea(
      child: _status == _ContactEditorStatus.saved
          ? _SuccessView(
              contact: _savedContact!,
              labels: widget.labels,
              onDone: () => Navigator.of(context).pop(_savedContact),
            )
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(NgoToolsLayout.sectionSpacing),
                children: [
                  if (_messageForStatus() case final message?) ...[
                    NgoToolsStatusBanner(
                      status: _bannerStatus(),
                      message: message,
                    ),
                    const SizedBox(height: NgoToolsLayout.spacing),
                  ],
                  if (!_isEdit)
                    DropdownButtonFormField<ContactDraftKind>(
                      initialValue: _kind,
                      decoration: InputDecoration(
                        labelText: widget.labels.name,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: ContactDraftKind.person,
                          child: Text(widget.labels.person),
                        ),
                        DropdownMenuItem(
                          value: ContactDraftKind.organization,
                          child: Text(widget.labels.organization),
                        ),
                      ],
                      onChanged: _isBusy
                          ? null
                          : (kind) {
                              if (kind != null) {
                                setState(() => _kind = kind);
                              }
                            },
                    ),
                  if (!_isEdit) const SizedBox(height: NgoToolsLayout.spacing),
                  if (_kind == ContactDraftKind.organization)
                    TextFormField(
                      controller: _name,
                      enabled: !_isBusy,
                      decoration: InputDecoration(
                        labelText: widget.labels.name,
                      ),
                      validator: (value) => _required(value),
                    )
                  else
                    Column(
                      children: [
                        TextFormField(
                          key: const ValueKey('contact-first-name'),
                          controller: _firstName,
                          enabled: !_isBusy,
                          decoration: InputDecoration(
                            labelText: widget.labels.firstName,
                          ),
                          validator: (_) => _personNameRequired(),
                        ),
                        const SizedBox(height: NgoToolsLayout.spacing),
                        TextFormField(
                          key: const ValueKey('contact-last-name'),
                          controller: _lastName,
                          enabled: !_isBusy,
                          decoration: InputDecoration(
                            labelText: widget.labels.lastName,
                          ),
                          validator: (_) => _personNameRequired(),
                        ),
                      ],
                    ),
                  const SizedBox(height: NgoToolsLayout.spacing),
                  TextFormField(
                    key: const ValueKey('contact-email'),
                    controller: _email,
                    enabled: !_isBusy,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    decoration: InputDecoration(labelText: widget.labels.email),
                  ),
                  const SizedBox(height: NgoToolsLayout.spacing),
                  Column(
                    children: [
                      TextFormField(
                        controller: _salutation,
                        enabled: !_isBusy,
                        decoration: InputDecoration(
                          labelText: widget.labels.salutation,
                        ),
                      ),
                      const SizedBox(height: NgoToolsLayout.spacing),
                      TextFormField(
                        controller: _title,
                        enabled: !_isBusy,
                        decoration: InputDecoration(
                          labelText: widget.labels.titleField,
                        ),
                      ),
                      const SizedBox(height: NgoToolsLayout.spacing),
                      DropdownButtonFormField<String>(
                        initialValue:
                            const {
                              'male',
                              'female',
                              'diverse',
                            }.contains(_gender.text)
                            ? _gender.text
                            : '',
                        decoration: InputDecoration(
                          labelText: widget.labels.gender,
                        ),
                        items: [
                          DropdownMenuItem(
                            value: '',
                            child: Text(widget.labels.genderNotSpecified),
                          ),
                          DropdownMenuItem(
                            value: 'male',
                            child: Text(widget.labels.genderMale),
                          ),
                          DropdownMenuItem(
                            value: 'female',
                            child: Text(widget.labels.genderFemale),
                          ),
                          DropdownMenuItem(
                            value: 'diverse',
                            child: Text(widget.labels.genderDiverse),
                          ),
                        ],
                        onChanged: _isBusy
                            ? null
                            : (value) => _gender.text = value ?? '',
                      ),
                      const SizedBox(height: NgoToolsLayout.spacing),
                      TextFormField(
                        controller: _birthday,
                        enabled: !_isBusy,
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          labelText: '${widget.labels.birthday} (YYYY-MM-DD)',
                        ),
                        validator: _validateBirthday,
                      ),
                    ],
                  ),
                  const SizedBox(height: NgoToolsLayout.sectionSpacing),
                  Wrap(
                    spacing: NgoToolsLayout.spacing,
                    runSpacing: NgoToolsLayout.compactSpacing,
                    children: [
                      OutlinedButton.icon(
                        onPressed: _isBusy ? null : () => unawaited(_save()),
                        icon: const Icon(Icons.save_outlined),
                        label: Text(widget.labels.saveDraft),
                      ),
                      FilledButton.icon(
                        onPressed: _isBusy ? null : () => unawaited(_submit()),
                        icon: _status == _ContactEditorStatus.submitting
                            ? const SizedBox.square(
                                dimension: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.cloud_upload_outlined),
                        label: Text(widget.labels.submitDraft),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    ),
  );

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    try {
      _draft = await widget.manager.saveDraft(_fromForm());
      _setStatus(_ContactEditorStatus.localSaved);
    } on ContactDraftLimitExceeded {
      _setStatus(_ContactEditorStatus.draftLimit);
    } on Object {
      _setStatus(_ContactEditorStatus.storageFailure);
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    try {
      _draft = await widget.manager.saveDraft(_fromForm());
    } on ContactDraftLimitExceeded {
      _setStatus(_ContactEditorStatus.draftLimit);

      return;
    } on Object {
      _setStatus(_ContactEditorStatus.storageFailure);

      return;
    }

    if (!mounted || !await _confirmSubmission()) {
      return;
    }

    _setStatus(_ContactEditorStatus.submitting);

    try {
      final result = await widget.manager.submitDraft(_draft);

      if (!mounted) {
        return;
      }

      switch (result) {
        case ContactDraftSubmissionSuccess(:final contact):
          setState(() {
            _savedContact = contact;
            _status = _ContactEditorStatus.saved;
          });
        case ContactDraftSubmissionUnsent():
          _setStatus(_ContactEditorStatus.unsent);
        case ContactDraftSubmissionValidationFailure():
          _setStatus(_ContactEditorStatus.validationFailure);
        case ContactDraftSubmissionConflict():
          _setStatus(_ContactEditorStatus.conflict);
      }
    } on Object {
      if (mounted) {
        _setStatus(_ContactEditorStatus.storageFailure);
      }
    }
  }

  Future<bool> _confirmSubmission() async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(widget.labels.confirmTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.labels.confirmMessage),
              const SizedBox(height: NgoToolsLayout.spacing),
              Text(_summary(), style: Theme.of(context).textTheme.titleMedium),
              if (_email.text.trim().isNotEmpty) Text(_email.text.trim()),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(widget.labels.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(widget.labels.confirm),
            ),
          ],
        ),
      ) ??
      false;

  ContactDraft _fromForm() => _draft.copyWith(
    kind: _kind,
    name: _nullable(_name.text),
    firstName: _nullable(_firstName.text),
    lastName: _nullable(_lastName.text),
    email: _nullable(_email.text),
    salutation: _nullable(_salutation.text),
    title: _nullable(_title.text),
    gender: _nullable(_gender.text),
    birthday: _birthday.text.trim().isEmpty
        ? null
        : DateTime.parse(_birthday.text.trim()),
  );

  String _summary() => _kind == ContactDraftKind.organization
      ? _name.text.trim()
      : [
          _firstName.text.trim(),
          _lastName.text.trim(),
        ].where((value) => value.isNotEmpty).join(' ');

  String? _personNameRequired() =>
      _firstName.text.trim().isEmpty && _lastName.text.trim().isEmpty
      ? widget.labels.validationFailure
      : null;

  String? _required(String? value) => value == null || value.trim().isEmpty
      ? widget.labels.validationFailure
      : null;

  String? _validateBirthday(String? value) {
    final normalized = value?.trim() ?? '';

    if (normalized.isEmpty) {
      return null;
    }

    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(normalized)) {
      return widget.labels.validationFailure;
    }

    final parsed = DateTime.tryParse(normalized);

    return parsed == null ||
            parsed.toIso8601String().split('T').first != normalized
        ? widget.labels.validationFailure
        : null;
  }

  String? _messageForStatus() => switch (_status) {
    _ContactEditorStatus.editing => null,
    _ContactEditorStatus.localSaved => widget.labels.localSaved,
    _ContactEditorStatus.submitting => widget.labels.submitting,
    _ContactEditorStatus.saved => widget.labels.saved,
    _ContactEditorStatus.unsent => widget.labels.unsent,
    _ContactEditorStatus.validationFailure => widget.labels.validationFailure,
    _ContactEditorStatus.conflict => widget.labels.versionConflict,
    _ContactEditorStatus.draftLimit => widget.labels.draftLimit,
    _ContactEditorStatus.storageFailure => widget.labels.storageError,
  };

  NgoToolsStatus _bannerStatus() => switch (_status) {
    _ContactEditorStatus.localSaved => NgoToolsStatus.success,
    _ContactEditorStatus.submitting => NgoToolsStatus.info,
    _ContactEditorStatus.editing ||
    _ContactEditorStatus.saved => NgoToolsStatus.success,
    _ContactEditorStatus.unsent ||
    _ContactEditorStatus.conflict => NgoToolsStatus.warning,
    _ContactEditorStatus.validationFailure ||
    _ContactEditorStatus.draftLimit ||
    _ContactEditorStatus.storageFailure => NgoToolsStatus.error,
  };

  void _setStatus(_ContactEditorStatus status) {
    if (mounted) {
      setState(() => _status = status);
    }
  }

  static String? _nullable(String value) {
    final normalized = value.trim();

    return normalized.isEmpty ? null : normalized;
  }
}

/// Lists encrypted drafts so they can be resumed or explicitly discarded.
final class ContactDraftsPage extends StatefulWidget {
  /// Creates the retained-draft route.
  const ContactDraftsPage({
    required this.manager,
    required this.labels,
    super.key,
  });

  final ContactDraftManager manager;
  final ContactLabels labels;

  @override
  State<ContactDraftsPage> createState() => _ContactDraftsPageState();
}

final class _ContactDraftsPageState extends State<ContactDraftsPage> {
  late Future<List<ContactDraft>> _drafts;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.labels.drafts)),
    body: FutureBuilder<List<ContactDraft>>(
      future: _drafts,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(
            child: Semantics(
              label: widget.labels.loading,
              child: const CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return NgoToolsEmptyState(
            title: widget.labels.drafts,
            message: widget.labels.storageError,
            icon: Icons.error_outline,
          );
        }

        final drafts = snapshot.data ?? const [];

        if (drafts.isEmpty) {
          return NgoToolsEmptyState(
            title: widget.labels.drafts,
            message: widget.labels.noDrafts,
            icon: Icons.edit_note_outlined,
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(NgoToolsLayout.spacing),
          itemCount: drafts.length,
          separatorBuilder: (_, _) =>
              const SizedBox(height: NgoToolsLayout.compactSpacing),
          itemBuilder: (context, index) {
            final draft = drafts[index];

            return Card(
              margin: EdgeInsets.zero,
              child: ListTile(
                leading: Icon(
                  draft.kind == ContactDraftKind.person
                      ? Icons.person_outline
                      : Icons.business_outlined,
                ),
                title: Text(_draftName(draft, widget.labels)),
                subtitle: Text(_draftState(draft.state, widget.labels)),
                onTap: () => unawaited(_open(draft)),
                trailing: IconButton(
                  tooltip: widget.labels.discardDraft,
                  onPressed: () => unawaited(_discard(draft)),
                  icon: const Icon(Icons.delete_outline),
                ),
              ),
            );
          },
        );
      },
    ),
  );

  Future<void> _open(ContactDraft draft) async {
    await Navigator.of(context).push<ContactRecord>(
      MaterialPageRoute<ContactRecord>(
        builder: (_) => ContactEditorPage(
          manager: widget.manager,
          draft: draft,
          labels: widget.labels,
        ),
      ),
    );

    if (mounted) {
      setState(_reload);
    }
  }

  Future<void> _discard(ContactDraft draft) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.labels.discardDraft),
        content: Text(widget.labels.confirmDiscard),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(widget.labels.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(widget.labels.discardDraft),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    await widget.manager.discardDraft(draft.localId);

    if (mounted) {
      setState(_reload);
    }
  }

  void _reload() {
    _drafts = widget.manager.listDrafts();
  }

  static String _draftName(ContactDraft draft, ContactLabels labels) {
    final name = draft.kind == ContactDraftKind.organization
        ? draft.name?.trim()
        : [
            draft.firstName?.trim(),
            draft.lastName?.trim(),
          ].whereType<String>().where((value) => value.isNotEmpty).join(' ');

    return name == null || name.isEmpty ? labels.unknownContact : name;
  }

  static String _draftState(ContactDraftState state, ContactLabels labels) =>
      switch (state) {
        ContactDraftState.local => labels.localSaved,
        ContactDraftState.unsent => labels.unsent,
        ContactDraftState.validationFailure => labels.validationFailure,
        ContactDraftState.conflict => labels.versionConflict,
      };
}

final class _SuccessView extends StatelessWidget {
  const _SuccessView({
    required this.contact,
    required this.labels,
    required this.onDone,
  });

  final ContactRecord contact;
  final ContactLabels labels;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(NgoToolsLayout.sectionSpacing),
      child: NgoToolsSectionCard(
        title: labels.saved,
        leading: const Icon(Icons.check_circle_outline),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              contact.displayName(labels.unknownContact),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (contact.email case final email?) Text(email),
            const SizedBox(height: NgoToolsLayout.spacing),
            FilledButton(onPressed: onDone, child: Text(labels.done)),
          ],
        ),
      ),
    ),
  );
}
