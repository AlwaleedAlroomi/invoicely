import 'package:flutter/material.dart';
import 'package:invoicely/core/constants/countries.dart';
import 'package:invoicely/core/utils/fade_through_route.dart';
import 'package:invoicely/features/clients/data/client_model.dart';
import 'package:invoicely/features/invoice/view/invoice_form_screen.dart';
import 'package:invoicely/features/invoice/widgets/invoice_history.dart';
import 'package:url_launcher/url_launcher.dart';

class HeaderSection extends StatelessWidget {
  final ClientModel client;
  const HeaderSection({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text(
              client.name[0].toUpperCase(),
              style: const TextStyle(fontSize: 32),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            client.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(client.email, style: TextStyle(color: Colors.grey.shade600)),
          if (client.country != null) ...[
            const SizedBox(height: 4),
            Text(
              '${getFlagEmoji(client.country!)}  ${client.country}',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
          if (!client.isActive) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Text(
                'Archived',
                style: TextStyle(color: Colors.red.shade700, fontSize: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ------------------------------------------------

class QuickActions extends StatelessWidget {
  final ClientModel client;
  const QuickActions({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ActionButton(
            icon: Icons.email_outlined,
            label: 'Email',
            onTap: () async {
              Uri url = Uri(
                scheme: 'mailto',
                path: client.email,
                queryParameters: {'subject': 'News', 'body': 'New'},
              );
              await launchUrl(url);
            },
          ),
          if (client.phone != null)
            _ActionButton(
              icon: Icons.phone_outlined,
              label: 'Call',
              onTap: () async {
                Uri url = Uri(scheme: "tel", path: client.phone);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  // TODO: handle the error
                  print('not opening dial');
                }
              },
            ),
          _ActionButton(
            icon: Icons.receipt_long_outlined,
            label: 'Invoice',
            onTap: () async {
              await Navigator.of(context).push(
                FadeThroughRoute(
                  page: InvoiceFormScreen(preSelectedClient: client),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Icon(icon),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------

class InfoSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<InfoTile> tiles;

  const InfoSection({
    super.key,
    required this.title,
    required this.icon,
    required this.tiles,
  });

  @override
  Widget build(BuildContext context) {
    if (tiles.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Card(
            margin: EdgeInsets.zero,
            child: Column(
              children:
                  tiles
                      .map((tile) => tile)
                      .expand((tile) => [tile, const Divider(height: 1)])
                      .toList()
                    ..removeLast(), // remove trailing divider
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 20),
      title: label.isNotEmpty
          ? Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            )
          : null,
      subtitle: Text(value),
      dense: true,
    );
  }
}

// ------------------------------------------------

class RecentInvoicesSection extends StatelessWidget {
  final int clientId;
  const RecentInvoicesSection({super.key, required this.clientId});

  @override
  Widget build(BuildContext context) {
    // hook this up to your invoice provider later
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 18,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Recent Invoices',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {}, // navigate to all invoices filtered by client
                child: const Text('See all'),
              ),
            ],
          ),
          // const Center(
          //   child: Padding(
          //     padding: EdgeInsets.all(16),
          //     child: Text(
          //       'No invoices yet',
          //       style: TextStyle(color: Colors.grey),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
