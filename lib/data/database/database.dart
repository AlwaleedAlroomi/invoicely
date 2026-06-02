import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:invoicely/core/enum/invoice_status.dart';
import 'package:invoicely/features/invoice/data/invoice_item_model.dart';

part 'database.g.dart';

class InvoiceItemConverter
    extends TypeConverter<List<InvoiceItemModel>, String> {
  const InvoiceItemConverter();

  @override
  List<InvoiceItemModel> fromSql(String column) {
    final list = (jsonDecode(column) as List).cast<Map<String, dynamic>>();
    return list.map((e) => InvoiceItemModel.fromJson(e)).toList();
  }

  @override
  String toSql(List<InvoiceItemModel> value) {
    return jsonEncode(value.map((e) => e.toJson()).toList());
  }
}

class InvoiceStatusConverter extends TypeConverter<InvoiceStatus, String> {
  const InvoiceStatusConverter();

  @override
  InvoiceStatus fromSql(String fromDb) =>
      InvoiceStatus.values.firstWhere((e) => e.name == fromDb);

  @override
  String toSql(InvoiceStatus value) => value.name;
}

class Invoices extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get remoteId => text().unique()();
  TextColumn get clientRemoteId => text()();
  TextColumn get invoiceNumber => text()();
  DateTimeColumn get issueDate => dateTime()();
  DateTimeColumn get dueDate => dateTime()();
  RealColumn get taxRate => real()();
  RealColumn get subTotal => real()();
  RealColumn get taxAmount => real()();
  RealColumn get totalAmount => real()();
  TextColumn get status =>
      text().map(const InvoiceStatusConverter()).nullable()();
  TextColumn get items => text().map(const InvoiceItemConverter()).nullable()();
  TextColumn? get notes => text().nullable()();
  TextColumn? get terms => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class Clients extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get remoteId => text().unique()();
  TextColumn get name => text()();
  TextColumn get email => text()();
  TextColumn? get phone => text().nullable()();
  TextColumn? get website => text().nullable()();
  TextColumn? get addressLine1 => text().nullable()();
  TextColumn? get addressLine2 => text().nullable()();
  TextColumn? get city => text().nullable()();
  TextColumn? get state => text().nullable()();
  TextColumn? get zipCode => text().nullable()();
  TextColumn? get country => text().nullable()();
  TextColumn? get taxNumber => text().nullable()();
  TextColumn get currency => text().withDefault(const Constant('USD'))();
  TextColumn? get notes => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get remoteId => text().unique()();
  TextColumn get name => text()();
  TextColumn? get description => text().nullable()();
  RealColumn get unitPrice => real()();
  TextColumn? get imagePath => text().nullable()();
  IntColumn get stockQuantity => integer().withDefault(const Constant(0))();
  TextColumn? get sku => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn? get lastUpdated => dateTime().nullable()();
  DateTimeColumn? get createdAt => dateTime().nullable()();
}

class BusinessProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get businessName => text()();
  TextColumn? get logoPath => text().nullable()();
  TextColumn? get taxNumber => text().nullable()();
  TextColumn? get email => text().nullable()();
  TextColumn? get phone => text().nullable()();
  TextColumn? get website => text().nullable()();
  TextColumn? get addressLine1 => text().nullable()();
  TextColumn? get addressLine2 => text().nullable()();
  TextColumn? get city => text().nullable()();
  TextColumn? get state => text().nullable()();
  TextColumn? get zipCode => text().nullable()();
  TextColumn? get country => text().nullable()();
}

@DriftDatabase(tables: [Invoices, Clients, Products, BusinessProfiles])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // ignore: use_super_parameters
  AppDatabase.connect(DatabaseConnection connection) : super(connection);

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'invoicely.db'));
    return NativeDatabase(file);
  });
}
