import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ngotools_design_system/ngotools_design_system.dart';

import 'contact_details_cubit.dart';
import 'contact_draft_manager.dart';
import 'contact_editor.dart';
import 'contact_labels.dart';
import 'contact_models.dart';
import 'contacts_cubit.dart';
import 'contacts_repository.dart';

/// Searchable, adaptive read-only contact list.
final class ContactsView extends StatefulWidget {
  /// Creates a contact list backed by [repository].
  const ContactsView({
    required this.repository,
    required this.labels,
    this.draftManager,
    this.onContactSelected,
    super.key,
  });

  final ContactsRepository repository;
  final ContactLabels labels;
  final ContactDraftManager? draftManager;
  final ValueChanged<ContactRecord>? onContactSelected;

  @override
  State<ContactsView> createState() => _ContactsViewState();
}

final class _ContactsViewState extends State<ContactsView> {
  late final ContactsCubit _cubit;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _cubit = ContactsCubit(repository: widget.repository);
    _searchController = TextEditingController();
    unawaited(_cubit.load());
  }

  @override
  void dispose() {
    _searchController.dispose();
    unawaited(_cubit.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider.value(
    value: _cubit,
    child: BlocBuilder<ContactsCubit, ContactsState>(
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ContactsToolbar(
            controller: _searchController,
            labels: widget.labels,
            state: state,
            onCreate: widget.draftManager == null ? null : _openNewContact,
            onDrafts: widget.draftManager == null ? null : _openDrafts,
          ),
          Expanded(
            child: _ContactsBody(
              state: state,
              labels: widget.labels,
              onSelected: _openContact,
            ),
          ),
        ],
      ),
    ),
  );

  void _openContact(ContactRecord contact) {
    final onContactSelected = widget.onContactSelected;

    if (onContactSelected != null) {
      onContactSelected(contact);

      return;
    }

    unawaited(
      Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (_) => ContactDetailsPage(
            repository: widget.repository,
            contactId: contact.id,
            labels: widget.labels,
            draftManager: widget.draftManager,
          ),
        ),
      ),
    );
  }

  Future<void> _openNewContact() async {
    final manager = widget.draftManager;

    if (manager == null) {
      return;
    }

    final draft = await manager.createDraft();

    if (!mounted) {
      return;
    }

    final saved = await Navigator.of(context).push<ContactRecord>(
      MaterialPageRoute<ContactRecord>(
        builder: (_) => ContactEditorPage(
          manager: manager,
          draft: draft,
          labels: widget.labels,
        ),
      ),
    );

    if (saved != null) {
      await _cubit.retry();
    }
  }

  Future<void> _openDrafts() async {
    final manager = widget.draftManager;

    if (manager == null) {
      return;
    }

    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) =>
            ContactDraftsPage(manager: manager, labels: widget.labels),
      ),
    );

    if (mounted) {
      await _cubit.retry();
    }
  }
}

final class _ContactsToolbar extends StatelessWidget {
  const _ContactsToolbar({
    required this.controller,
    required this.labels,
    required this.state,
    this.onCreate,
    this.onDrafts,
  });

  final TextEditingController controller;
  final ContactLabels labels;
  final ContactsState state;
  final VoidCallback? onCreate;
  final VoidCallback? onDrafts;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      NgoToolsLayout.spacing,
      NgoToolsLayout.spacing,
      NgoToolsLayout.spacing,
      NgoToolsLayout.compactSpacing,
    ),
    child: Wrap(
      spacing: NgoToolsLayout.compactSpacing,
      runSpacing: NgoToolsLayout.compactSpacing,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) => SizedBox(
            width: 360,
            child: SearchBar(
              controller: controller,
              hintText: labels.searchHint,
              leading: const Icon(Icons.search),
              trailing: [
                if (value.text.isNotEmpty)
                  IconButton(
                    tooltip: labels.clearSearch,
                    onPressed: () {
                      controller.clear();
                      unawaited(context.read<ContactsCubit>().search(''));
                    },
                    icon: const Icon(Icons.clear),
                  ),
              ],
              onSubmitted: (query) =>
                  unawaited(context.read<ContactsCubit>().search(query)),
            ),
          ),
        ),
        DropdownMenu<ContactsSort>(
          key: ValueKey(state.sort),
          label: Text(labels.sortLabel),
          initialSelection: state.sort,
          dropdownMenuEntries: [
            for (final sort in ContactsSort.values)
              DropdownMenuEntry(value: sort, label: labels.sortNameFor(sort)),
          ],
          onSelected: (sort) {
            if (sort != null && sort != state.sort) {
              unawaited(context.read<ContactsCubit>().changeSort(sort));
            }
          },
        ),
        if (onDrafts case final callback?)
          OutlinedButton.icon(
            onPressed: callback,
            icon: const Icon(Icons.edit_note_outlined),
            label: Text(labels.drafts),
          ),
        if (onCreate case final callback?)
          FilledButton.icon(
            onPressed: callback,
            icon: const Icon(Icons.person_add_outlined),
            label: Text(labels.newContact),
          ),
      ],
    ),
  );
}

final class _ContactsBody extends StatelessWidget {
  const _ContactsBody({
    required this.state,
    required this.labels,
    required this.onSelected,
  });

  final ContactsState state;
  final ContactLabels labels;
  final ValueChanged<ContactRecord> onSelected;

  @override
  Widget build(BuildContext context) => switch (state.status) {
    ContactsStatus.initial || ContactsStatus.loading => Center(
      child: Semantics(
        label: labels.loading,
        child: const CircularProgressIndicator(),
      ),
    ),
    ContactsStatus.empty => NgoToolsEmptyState(
      title: state.query.isEmpty ? labels.emptyTitle : labels.noResultsTitle,
      message: state.query.isEmpty
          ? labels.emptyMessage
          : labels.noResultsMessage,
      icon: Icons.people_outline,
    ),
    ContactsStatus.failure when state.contacts.isEmpty => NgoToolsEmptyState(
      title: labels.errorMessage,
      message: _failureMessage(labels, state.failure),
      icon: Icons.cloud_off_outlined,
      action: FilledButton.icon(
        onPressed: () => unawaited(context.read<ContactsCubit>().retry()),
        icon: const Icon(Icons.refresh),
        label: Text(labels.retry),
      ),
    ),
    _ => Column(
      children: [
        if (state.source == ContactDataSource.cache)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              NgoToolsLayout.spacing,
              NgoToolsLayout.compactSpacing,
              NgoToolsLayout.spacing,
              0,
            ),
            child: NgoToolsStatusBanner(
              status: NgoToolsStatus.warning,
              message: labels.cachedMessage,
            ),
          ),
        Expanded(
          child: _ContactResults(
            state: state,
            labels: labels,
            onSelected: onSelected,
          ),
        ),
      ],
    ),
  };
}

final class _ContactResults extends StatelessWidget {
  const _ContactResults({
    required this.state,
    required this.labels,
    required this.onSelected,
  });

  final ContactsState state;
  final ContactLabels labels;
  final ValueChanged<ContactRecord> onSelected;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final itemCount = state.contacts.length + 1;

      if (constraints.maxWidth >= 720) {
        return GridView.builder(
          padding: const EdgeInsets.all(NgoToolsLayout.spacing),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 420,
            mainAxisExtent: 118,
            crossAxisSpacing: NgoToolsLayout.spacing,
            mainAxisSpacing: NgoToolsLayout.spacing,
          ),
          itemCount: itemCount,
          itemBuilder: (context, index) => index == state.contacts.length
              ? _PaginationFooter(state: state, labels: labels)
              : _ContactCard(
                  contact: state.contacts[index],
                  labels: labels,
                  onTap: () => onSelected(state.contacts[index]),
                ),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.all(NgoToolsLayout.spacing),
        itemCount: itemCount,
        separatorBuilder: (_, _) =>
            const SizedBox(height: NgoToolsLayout.compactSpacing),
        itemBuilder: (context, index) => index == state.contacts.length
            ? _PaginationFooter(state: state, labels: labels)
            : _ContactCard(
                contact: state.contacts[index],
                labels: labels,
                onTap: () => onSelected(state.contacts[index]),
              ),
      );
    },
  );
}

final class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.contact,
    required this.labels,
    required this.onTap,
  });

  final ContactRecord contact;
  final ContactLabels labels;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final city = contact.addresses.firstOrNull?.city;
    final subtitle = [
      contact.email,
      city,
    ].whereType<String>().where((value) => value.isNotEmpty).join(' · ');

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(child: Icon(_iconFor(contact.kind))),
        title: Text(
          contact.displayName(labels.unknownContact),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: subtitle.isEmpty
            ? null
            : Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

final class _PaginationFooter extends StatelessWidget {
  const _PaginationFooter({required this.state, required this.labels});

  final ContactsState state;
  final ContactLabels labels;

  @override
  Widget build(BuildContext context) {
    if (state.status == ContactsStatus.loadingMore) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(NgoToolsLayout.spacing),
          child: Semantics(
            label: labels.loading,
            child: const CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (state.status == ContactsStatus.failure) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(NgoToolsLayout.compactSpacing),
            child: NgoToolsStatusBanner(
              status: NgoToolsStatus.error,
              message: _failureMessage(labels, state.failure),
            ),
          ),
          OutlinedButton.icon(
            onPressed: () => unawaited(context.read<ContactsCubit>().retry()),
            icon: const Icon(Icons.refresh),
            label: Text(labels.retry),
          ),
        ],
      );
    }

    if (!state.hasNextPage) {
      return const SizedBox.shrink();
    }

    return Center(
      child: OutlinedButton.icon(
        onPressed: () => unawaited(context.read<ContactsCubit>().loadMore()),
        icon: const Icon(Icons.expand_more),
        label: Text(labels.loadMore),
      ),
    );
  }
}

/// Full-screen contact details route used by [ContactsView].
final class ContactDetailsPage extends StatelessWidget {
  /// Creates a contact details route.
  const ContactDetailsPage({
    required this.repository,
    required this.contactId,
    required this.labels,
    this.draftManager,
    super.key,
  });

  final ContactsRepository repository;
  final int contactId;
  final ContactLabels labels;
  final ContactDraftManager? draftManager;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(labels.detailsTitle)),
    body: ContactDetailsView(
      repository: repository,
      contactId: contactId,
      labels: labels,
      draftManager: draftManager,
    ),
  );
}

/// Read-only details for one contact.
final class ContactDetailsView extends StatefulWidget {
  /// Creates a contact detail view.
  const ContactDetailsView({
    required this.repository,
    required this.contactId,
    required this.labels,
    this.draftManager,
    super.key,
  });

  final ContactsRepository repository;
  final int contactId;
  final ContactLabels labels;
  final ContactDraftManager? draftManager;

  @override
  State<ContactDetailsView> createState() => _ContactDetailsViewState();
}

final class _ContactDetailsViewState extends State<ContactDetailsView> {
  late final ContactDetailsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ContactDetailsCubit(
      repository: widget.repository,
      contactId: widget.contactId,
    );
    unawaited(_cubit.load());
  }

  @override
  void dispose() {
    unawaited(_cubit.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider.value(
    value: _cubit,
    child: BlocBuilder<ContactDetailsCubit, ContactDetailsState>(
      builder: (context, state) => switch (state.status) {
        ContactDetailsStatus.initial || ContactDetailsStatus.loading => Center(
          child: Semantics(
            label: widget.labels.loading,
            child: const CircularProgressIndicator(),
          ),
        ),
        ContactDetailsStatus.failure => NgoToolsEmptyState(
          title: widget.labels.errorMessage,
          message: _failureMessage(widget.labels, state.failure),
          icon: Icons.cloud_off_outlined,
          action: FilledButton.icon(
            onPressed: () => unawaited(_cubit.load()),
            icon: const Icon(Icons.refresh),
            label: Text(widget.labels.retry),
          ),
        ),
        ContactDetailsStatus.ready => Column(
          children: [
            if (state.source == ContactDataSource.cache)
              Padding(
                padding: const EdgeInsets.all(NgoToolsLayout.spacing),
                child: NgoToolsStatusBanner(
                  status: NgoToolsStatus.warning,
                  message: widget.labels.cachedMessage,
                ),
              ),
            Expanded(
              child: _ContactDetails(
                contact: state.contact!,
                labels: widget.labels,
                onEdit:
                    widget.draftManager != null &&
                        (state.contact!.kind == ContactKind.person ||
                            state.contact!.kind == ContactKind.organization)
                    ? () => unawaited(_edit(state.contact!))
                    : null,
              ),
            ),
          ],
        ),
      },
    ),
  );

  Future<void> _edit(ContactRecord contact) async {
    final manager = widget.draftManager;

    if (manager == null) {
      return;
    }

    final draft = await manager.createEditDraft(contact);

    if (!mounted) {
      return;
    }

    final saved = await Navigator.of(context).push<ContactRecord>(
      MaterialPageRoute<ContactRecord>(
        builder: (_) => ContactEditorPage(
          manager: manager,
          draft: draft,
          labels: widget.labels,
        ),
      ),
    );

    if (saved != null) {
      await _cubit.load();
    }
  }
}

final class _ContactDetails extends StatelessWidget {
  const _ContactDetails({
    required this.contact,
    required this.labels,
    this.onEdit,
  });

  final ContactRecord contact;
  final ContactLabels labels;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final information = <(IconData, String, String)>[
      if (contact.email case final email?)
        (Icons.email_outlined, labels.email, email),
      if (contact.birthday case final birthday?)
        (
          Icons.cake_outlined,
          labels.birthday,
          birthday.toIso8601String().split('T').first,
        ),
    ];

    return ListView(
      padding: const EdgeInsets.all(NgoToolsLayout.sectionSpacing),
      children: [
        Semantics(
          header: true,
          child: Text(
            contact.displayName(labels.unknownContact),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        const SizedBox(height: NgoToolsLayout.sectionSpacing),
        if (onEdit case final callback?) ...[
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: FilledButton.icon(
              onPressed: callback,
              icon: const Icon(Icons.edit_outlined),
              label: Text(labels.editContact),
            ),
          ),
          const SizedBox(height: NgoToolsLayout.sectionSpacing),
        ],
        if (information.isNotEmpty)
          NgoToolsSectionCard(
            title: labels.contactInformation,
            leading: const Icon(Icons.person_outline),
            child: Column(
              children: [
                for (final item in information)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(item.$1),
                    title: Text(item.$2),
                    subtitle: Text(item.$3),
                  ),
              ],
            ),
          ),
        if (information.isNotEmpty && contact.addresses.isNotEmpty)
          const SizedBox(height: NgoToolsLayout.spacing),
        if (contact.addresses.isNotEmpty)
          NgoToolsSectionCard(
            title: labels.addresses,
            leading: const Icon(Icons.location_on_outlined),
            child: Column(
              children: [
                for (final address in contact.addresses)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(_addressLine(address)),
                    subtitle: address.type == null ? null : Text(address.type!),
                  ),
              ],
            ),
          ),
        if (information.isEmpty && contact.addresses.isEmpty)
          NgoToolsEmptyState(
            title: labels.detailsTitle,
            message: labels.noDetails,
            icon: Icons.person_outline,
          ),
      ],
    );
  }
}

String _failureMessage(ContactLabels labels, ContactsFailureCode? failure) =>
    switch (failure) {
      ContactsFailureCode.unauthenticated => labels.errorMessage,
      ContactsFailureCode.forbidden ||
      ContactsFailureCode.unavailable => labels.emptyMessage,
      ContactsFailureCode.notFound => labels.noResultsMessage,
      ContactsFailureCode.network ||
      ContactsFailureCode.invalidResponse ||
      ContactsFailureCode.unknown ||
      null => labels.errorMessage,
    };

IconData _iconFor(ContactKind kind) => switch (kind) {
  ContactKind.person => Icons.person_outline,
  ContactKind.organization => Icons.business_outlined,
  ContactKind.couple => Icons.people_outline,
  ContactKind.unknown => Icons.contact_page_outlined,
};

String _addressLine(ContactAddress address) {
  final locality = [
    address.postalCode,
    address.city,
  ].whereType<String>().where((part) => part.isNotEmpty).join(' ');

  return [
    address.line1,
    address.line2,
    locality.isEmpty ? null : locality,
    address.country,
  ].whereType<String>().where((part) => part.isNotEmpty).join(', ');
}
