import 'package:flutter/material.dart';
import 'package:invoicely/features/clients/data/client_model.dart';

class ClientViewScreen extends StatefulWidget {
  final ClientModel client;
  const ClientViewScreen({super.key, required this.client});

  @override
  State<ClientViewScreen> createState() => _ClientViewScreenState();
}

class _ClientViewScreenState extends State<ClientViewScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
