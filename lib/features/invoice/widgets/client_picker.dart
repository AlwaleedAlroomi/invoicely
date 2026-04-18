import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/features/clients/data/client_model.dart';
import 'package:invoicely/features/clients/providers/client_providers.dart';
import 'package:invoicely/features/invoice/providers/invoice_provider.dart';

class ClientPickerSection extends StatelessWidget {
  final ClientModel? selectedClient;
  final VoidCallback onTap;

  const ClientPickerSection({
    super.key,
    required this.selectedClient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: selectedClient == null
            ? Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.person_add_outlined,
                      color: Colors.blue.shade400,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Select Client',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              )
            : Row(
                children: [
                  CircleAvatar(
                    child: Text(selectedClient!.name[0].toUpperCase()),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedClient!.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          selectedClient!.email,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
      ),
    );
  }
}

class ClientPickerSheet extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  const ClientPickerSheet({super.key, required this.scrollController});

  @override
  ConsumerState<ClientPickerSheet> createState() => ClientPickerSheetState();
}

class ClientPickerSheetState extends ConsumerState<ClientPickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final clientsAsync = ref.watch(allClientsProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Text(
            'Select Client',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search clients...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (q) => setState(() => _query = q),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: clientsAsync.when(
              data: (clients) {
                final filtered = clients
                    .where(
                      (c) =>
                          c.name.toLowerCase().contains(_query.toLowerCase()) ||
                          c.email.toLowerCase().contains(_query.toLowerCase()),
                    )
                    .toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('No clients found'));
                }

                return ListView.builder(
                  controller: widget.scrollController,
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final client = filtered[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(client.name[0].toUpperCase()),
                      ),
                      title: Text(client.name),
                      subtitle: Text(client.email),
                      onTap: () {
                        ref
                            .read(invoiceFormControllerProvider.notifier)
                            .selectClient(client);
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
