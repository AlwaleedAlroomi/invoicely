import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/core/constants/countries.dart';
import 'package:invoicely/core/utils/fade_through_route.dart';
import 'package:invoicely/features/clients/data/client_model.dart';
import 'package:invoicely/features/clients/providers/client_providers.dart';
import 'package:invoicely/features/clients/view/client_form_screen.dart';
import 'package:invoicely/features/clients/widgets/header_section.dart';

class ClientViewScreen extends ConsumerStatefulWidget {
  final ClientModel initClient;
  const ClientViewScreen({super.key, required this.initClient});

  @override
  ConsumerState<ClientViewScreen> createState() => _ClientViewScreenState();
}

class _ClientViewScreenState extends ConsumerState<ClientViewScreen> {
  late ClientModel client;

  @override
  void initState() {
    super.initState();
    client = widget.initClient;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderSection(client: client),
            QuickActions(client: client),
            const Divider(height: 1),
            InfoSection(
              title: 'Contact Info',
              icon: Icons.person_outline,
              tiles: [
                if (client.email.isNotEmpty)
                  InfoTile(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: client.email,
                  ),
                if (client.phone != null)
                  InfoTile(
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: client.phone!,
                  ),
                if (client.website != null)
                  InfoTile(
                    icon: Icons.language_outlined,
                    label: 'Website',
                    value: client.website!,
                  ),
              ],
            ),
            InfoSection(
              title: 'Billing Address',
              icon: Icons.location_on_outlined,
              tiles: [
                if (client.addressLine1 != null)
                  InfoTile(
                    icon: Icons.home_outlined,
                    label: 'Address',
                    value: [
                      client.addressLine1,
                      client.addressLine2,
                    ].whereType<String>().join(', '),
                  ),
                if (client.city != null)
                  InfoTile(
                    icon: Icons.location_city_outlined,
                    label: 'City',
                    value: client.city!,
                  ),
                if (client.state != null)
                  InfoTile(
                    icon: Icons.map_outlined,
                    label: 'State',
                    value: client.state!,
                  ),
                if (client.zipCode != null)
                  InfoTile(
                    icon: Icons.markunread_mailbox_outlined,
                    label: 'ZIP Code',
                    value: client.zipCode!,
                  ),
                if (client.country != null)
                  InfoTile(
                    icon: Icons.flag_outlined,
                    label: 'Country',
                    value:
                        '${getFlagEmoji(client.country!)}  ${client.country!}',
                  ),
              ],
            ),
            InfoSection(
              title: 'Business Info',
              icon: Icons.business_outlined,
              tiles: [
                if (client.taxNumber != null)
                  InfoTile(
                    icon: Icons.numbers_outlined,
                    label: 'Tax Number',
                    value: client.taxNumber!,
                  ),
                InfoTile(
                  icon: Icons.currency_exchange_outlined,
                  label: 'Currency',
                  value: client.currency,
                ),
              ],
            ),
            if (client.notes != null)
              InfoSection(
                title: 'Notes',
                icon: Icons.notes_outlined,
                tiles: [
                  InfoTile(
                    icon: Icons.sticky_note_2_outlined,
                    label: '',
                    value: client.notes!,
                  ),
                ],
              ),
            RecentInvoicesSection(clientId: client.isarId!),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Client Details'),
      actions: [
        PopupMenuButton(
          itemBuilder: (_) => [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit_outlined),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'archive',
              child: Row(
                children: [
                  Icon(Icons.archive_outlined),
                  SizedBox(width: 8),
                  Text('Archive'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_outline, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) async {
            switch (value) {
              case 'edit':
                final updatedClient = await Navigator.of(context)
                    .push<ClientModel>(
                      FadeThroughRoute(
                        page: ClientFormScreen(initialClient: client),
                      ),
                    );
                if (updatedClient != null) {
                  setState(() {
                    client = updatedClient;
                  });
                }
                break;
              case 'archive':
                await ref
                    .read(clientControllerProvider.notifier)
                    .archiveClient(client);
                if (!context.mounted) return;
                Navigator.pop(context);
                break;
              case 'delete':
                await ref
                    .read(clientControllerProvider.notifier)
                    .deleteClient(client);
                if (!context.mounted) return;
                Navigator.pop(context);
                break;
            }
          },
        ),
      ],
    );
  }
}
