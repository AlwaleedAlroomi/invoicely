import 'package:invoicely/core/enum/invoice_status.dart';
import 'package:invoicely/core/models/sortable_entity.dart';
import 'package:invoicely/features/clients/data/client_model.dart';
import 'package:invoicely/features/invoice/data/invoice_item_model.dart';
import 'package:uuid/uuid.dart';
import 'package:invoicely/data/database/database.dart' as db;

const uuid = Uuid();

class InvoiceModel implements SortableEntity {
  int? isarId;
  String? remoteId;
  ClientModel? client;

  late String invoiceNumber;
  late DateTime issueDate;
  late DateTime dueDate;
  late double taxRate;
  late double subTotal;
  late double taxAmount;
  late double totalAmount;
  late List<InvoiceItemModel> items;

  late InvoiceStatus status;

  String? notes;
  String? terms;
  bool isActive = true;
  late DateTime createdAt;
  late DateTime updatedAt;

  InvoiceModel({
    this.isarId,
    String? remoteId,
    this.client,
    required this.invoiceNumber,
    required this.issueDate,
    required this.dueDate,
    required this.taxRate,
    required this.subTotal,
    required this.taxAmount,
    required this.totalAmount,
    required this.items,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
    this.terms,
    this.isActive = true,
  }) : remoteId = remoteId ?? uuid.v4();

  InvoiceModel copyWith({
    String? invoiceNumber,
    DateTime? issueDate,
    DateTime? dueDate,
    double? taxRate,
    double? subTotal,
    double? taxAmount,
    double? totalAmount,
    InvoiceStatus? status,
    List<InvoiceItemModel>? items,
    String? notes,
    String? terms,
    bool? isActive,
  }) {
    return InvoiceModel(
      isarId: isarId,
      remoteId: remoteId,
      client: client,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      issueDate: issueDate ?? this.issueDate,
      dueDate: dueDate ?? this.dueDate,
      taxRate: taxRate ?? this.taxRate,
      subTotal: subTotal ?? this.subTotal,
      taxAmount: taxAmount ?? this.taxAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      items: items ?? this.items,
      notes: notes ?? this.notes,
      terms: terms ?? this.terms,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  DateTime get dateCreated => createdAt;

  @override
  String get displayName => invoiceNumber;

  factory InvoiceModel.fromDb(db.Invoice driftInvoice) {
    return InvoiceModel(
      isarId: driftInvoice.id,
      remoteId: driftInvoice.remoteId,
      invoiceNumber: driftInvoice.invoiceNumber,
      issueDate: driftInvoice.issueDate,
      dueDate: driftInvoice.dueDate,
      taxRate: driftInvoice.taxRate,
      subTotal: driftInvoice.subTotal,
      taxAmount: driftInvoice.taxAmount,
      totalAmount: driftInvoice.totalAmount,
      status: driftInvoice.status ?? InvoiceStatus.draft,
      items: driftInvoice.items ?? [],
      notes: driftInvoice.notes,
      terms: driftInvoice.terms,
      isActive: driftInvoice.isActive,
      createdAt: driftInvoice.createdAt,
      updatedAt: driftInvoice.updatedAt,
      client: null,
    );
  }
}
