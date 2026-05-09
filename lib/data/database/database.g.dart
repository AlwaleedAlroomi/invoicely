// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $InvoicesTable extends Invoices with TableInfo<$InvoicesTable, Invoice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
    'remote_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _clientRemoteIdMeta = const VerificationMeta(
    'clientRemoteId',
  );
  @override
  late final GeneratedColumn<String> clientRemoteId = GeneratedColumn<String>(
    'client_remote_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _invoiceNumberMeta = const VerificationMeta(
    'invoiceNumber',
  );
  @override
  late final GeneratedColumn<String> invoiceNumber = GeneratedColumn<String>(
    'invoice_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _issueDateMeta = const VerificationMeta(
    'issueDate',
  );
  @override
  late final GeneratedColumn<DateTime> issueDate = GeneratedColumn<DateTime>(
    'issue_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taxRateMeta = const VerificationMeta(
    'taxRate',
  );
  @override
  late final GeneratedColumn<double> taxRate = GeneratedColumn<double>(
    'tax_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subTotalMeta = const VerificationMeta(
    'subTotal',
  );
  @override
  late final GeneratedColumn<double> subTotal = GeneratedColumn<double>(
    'sub_total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taxAmountMeta = const VerificationMeta(
    'taxAmount',
  );
  @override
  late final GeneratedColumn<double> taxAmount = GeneratedColumn<double>(
    'tax_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<InvoiceStatus?, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<InvoiceStatus?>($InvoicesTable.$converterstatusn);
  @override
  late final GeneratedColumnWithTypeConverter<List<InvoiceItemModel>?, String>
  items = GeneratedColumn<String>(
    'items',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<List<InvoiceItemModel>?>($InvoicesTable.$converteritemsn);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _termsMeta = const VerificationMeta('terms');
  @override
  late final GeneratedColumn<String> terms = GeneratedColumn<String>(
    'terms',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    remoteId,
    clientRemoteId,
    invoiceNumber,
    issueDate,
    dueDate,
    taxRate,
    subTotal,
    taxAmount,
    totalAmount,
    status,
    items,
    notes,
    terms,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoices';
  @override
  VerificationContext validateIntegrity(
    Insertable<Invoice> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_remoteIdMeta);
    }
    if (data.containsKey('client_remote_id')) {
      context.handle(
        _clientRemoteIdMeta,
        clientRemoteId.isAcceptableOrUnknown(
          data['client_remote_id']!,
          _clientRemoteIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientRemoteIdMeta);
    }
    if (data.containsKey('invoice_number')) {
      context.handle(
        _invoiceNumberMeta,
        invoiceNumber.isAcceptableOrUnknown(
          data['invoice_number']!,
          _invoiceNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_invoiceNumberMeta);
    }
    if (data.containsKey('issue_date')) {
      context.handle(
        _issueDateMeta,
        issueDate.isAcceptableOrUnknown(data['issue_date']!, _issueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_issueDateMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('tax_rate')) {
      context.handle(
        _taxRateMeta,
        taxRate.isAcceptableOrUnknown(data['tax_rate']!, _taxRateMeta),
      );
    } else if (isInserting) {
      context.missing(_taxRateMeta);
    }
    if (data.containsKey('sub_total')) {
      context.handle(
        _subTotalMeta,
        subTotal.isAcceptableOrUnknown(data['sub_total']!, _subTotalMeta),
      );
    } else if (isInserting) {
      context.missing(_subTotalMeta);
    }
    if (data.containsKey('tax_amount')) {
      context.handle(
        _taxAmountMeta,
        taxAmount.isAcceptableOrUnknown(data['tax_amount']!, _taxAmountMeta),
      );
    } else if (isInserting) {
      context.missing(_taxAmountMeta);
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('terms')) {
      context.handle(
        _termsMeta,
        terms.isAcceptableOrUnknown(data['terms']!, _termsMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Invoice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Invoice(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_id'],
      )!,
      clientRemoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_remote_id'],
      )!,
      invoiceNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_number'],
      )!,
      issueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}issue_date'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      )!,
      taxRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tax_rate'],
      )!,
      subTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sub_total'],
      )!,
      taxAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tax_amount'],
      )!,
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_amount'],
      )!,
      status: $InvoicesTable.$converterstatusn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        ),
      ),
      items: $InvoicesTable.$converteritemsn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}items'],
        ),
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      terms: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}terms'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $InvoicesTable createAlias(String alias) {
    return $InvoicesTable(attachedDatabase, alias);
  }

  static TypeConverter<InvoiceStatus, String> $converterstatus =
      const InvoiceStatusConverter();
  static TypeConverter<InvoiceStatus?, String?> $converterstatusn =
      NullAwareTypeConverter.wrap($converterstatus);
  static TypeConverter<List<InvoiceItemModel>, String> $converteritems =
      const InvoiceItemConverter();
  static TypeConverter<List<InvoiceItemModel>?, String?> $converteritemsn =
      NullAwareTypeConverter.wrap($converteritems);
}

class Invoice extends DataClass implements Insertable<Invoice> {
  final int id;
  final String remoteId;
  final String clientRemoteId;
  final String invoiceNumber;
  final DateTime issueDate;
  final DateTime dueDate;
  final double taxRate;
  final double subTotal;
  final double taxAmount;
  final double totalAmount;
  final InvoiceStatus? status;
  final List<InvoiceItemModel>? items;
  final String? notes;
  final String? terms;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Invoice({
    required this.id,
    required this.remoteId,
    required this.clientRemoteId,
    required this.invoiceNumber,
    required this.issueDate,
    required this.dueDate,
    required this.taxRate,
    required this.subTotal,
    required this.taxAmount,
    required this.totalAmount,
    this.status,
    this.items,
    this.notes,
    this.terms,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['remote_id'] = Variable<String>(remoteId);
    map['client_remote_id'] = Variable<String>(clientRemoteId);
    map['invoice_number'] = Variable<String>(invoiceNumber);
    map['issue_date'] = Variable<DateTime>(issueDate);
    map['due_date'] = Variable<DateTime>(dueDate);
    map['tax_rate'] = Variable<double>(taxRate);
    map['sub_total'] = Variable<double>(subTotal);
    map['tax_amount'] = Variable<double>(taxAmount);
    map['total_amount'] = Variable<double>(totalAmount);
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(
        $InvoicesTable.$converterstatusn.toSql(status),
      );
    }
    if (!nullToAbsent || items != null) {
      map['items'] = Variable<String>(
        $InvoicesTable.$converteritemsn.toSql(items),
      );
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || terms != null) {
      map['terms'] = Variable<String>(terms);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  InvoicesCompanion toCompanion(bool nullToAbsent) {
    return InvoicesCompanion(
      id: Value(id),
      remoteId: Value(remoteId),
      clientRemoteId: Value(clientRemoteId),
      invoiceNumber: Value(invoiceNumber),
      issueDate: Value(issueDate),
      dueDate: Value(dueDate),
      taxRate: Value(taxRate),
      subTotal: Value(subTotal),
      taxAmount: Value(taxAmount),
      totalAmount: Value(totalAmount),
      status: status == null && nullToAbsent
          ? const Value.absent()
          : Value(status),
      items: items == null && nullToAbsent
          ? const Value.absent()
          : Value(items),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      terms: terms == null && nullToAbsent
          ? const Value.absent()
          : Value(terms),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Invoice.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Invoice(
      id: serializer.fromJson<int>(json['id']),
      remoteId: serializer.fromJson<String>(json['remoteId']),
      clientRemoteId: serializer.fromJson<String>(json['clientRemoteId']),
      invoiceNumber: serializer.fromJson<String>(json['invoiceNumber']),
      issueDate: serializer.fromJson<DateTime>(json['issueDate']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      taxRate: serializer.fromJson<double>(json['taxRate']),
      subTotal: serializer.fromJson<double>(json['subTotal']),
      taxAmount: serializer.fromJson<double>(json['taxAmount']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      status: serializer.fromJson<InvoiceStatus?>(json['status']),
      items: serializer.fromJson<List<InvoiceItemModel>?>(json['items']),
      notes: serializer.fromJson<String?>(json['notes']),
      terms: serializer.fromJson<String?>(json['terms']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'remoteId': serializer.toJson<String>(remoteId),
      'clientRemoteId': serializer.toJson<String>(clientRemoteId),
      'invoiceNumber': serializer.toJson<String>(invoiceNumber),
      'issueDate': serializer.toJson<DateTime>(issueDate),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'taxRate': serializer.toJson<double>(taxRate),
      'subTotal': serializer.toJson<double>(subTotal),
      'taxAmount': serializer.toJson<double>(taxAmount),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'status': serializer.toJson<InvoiceStatus?>(status),
      'items': serializer.toJson<List<InvoiceItemModel>?>(items),
      'notes': serializer.toJson<String?>(notes),
      'terms': serializer.toJson<String?>(terms),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Invoice copyWith({
    int? id,
    String? remoteId,
    String? clientRemoteId,
    String? invoiceNumber,
    DateTime? issueDate,
    DateTime? dueDate,
    double? taxRate,
    double? subTotal,
    double? taxAmount,
    double? totalAmount,
    Value<InvoiceStatus?> status = const Value.absent(),
    Value<List<InvoiceItemModel>?> items = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> terms = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Invoice(
    id: id ?? this.id,
    remoteId: remoteId ?? this.remoteId,
    clientRemoteId: clientRemoteId ?? this.clientRemoteId,
    invoiceNumber: invoiceNumber ?? this.invoiceNumber,
    issueDate: issueDate ?? this.issueDate,
    dueDate: dueDate ?? this.dueDate,
    taxRate: taxRate ?? this.taxRate,
    subTotal: subTotal ?? this.subTotal,
    taxAmount: taxAmount ?? this.taxAmount,
    totalAmount: totalAmount ?? this.totalAmount,
    status: status.present ? status.value : this.status,
    items: items.present ? items.value : this.items,
    notes: notes.present ? notes.value : this.notes,
    terms: terms.present ? terms.value : this.terms,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Invoice copyWithCompanion(InvoicesCompanion data) {
    return Invoice(
      id: data.id.present ? data.id.value : this.id,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      clientRemoteId: data.clientRemoteId.present
          ? data.clientRemoteId.value
          : this.clientRemoteId,
      invoiceNumber: data.invoiceNumber.present
          ? data.invoiceNumber.value
          : this.invoiceNumber,
      issueDate: data.issueDate.present ? data.issueDate.value : this.issueDate,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      taxRate: data.taxRate.present ? data.taxRate.value : this.taxRate,
      subTotal: data.subTotal.present ? data.subTotal.value : this.subTotal,
      taxAmount: data.taxAmount.present ? data.taxAmount.value : this.taxAmount,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      status: data.status.present ? data.status.value : this.status,
      items: data.items.present ? data.items.value : this.items,
      notes: data.notes.present ? data.notes.value : this.notes,
      terms: data.terms.present ? data.terms.value : this.terms,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Invoice(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('clientRemoteId: $clientRemoteId, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('issueDate: $issueDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('taxRate: $taxRate, ')
          ..write('subTotal: $subTotal, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('status: $status, ')
          ..write('items: $items, ')
          ..write('notes: $notes, ')
          ..write('terms: $terms, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    remoteId,
    clientRemoteId,
    invoiceNumber,
    issueDate,
    dueDate,
    taxRate,
    subTotal,
    taxAmount,
    totalAmount,
    status,
    items,
    notes,
    terms,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Invoice &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.clientRemoteId == this.clientRemoteId &&
          other.invoiceNumber == this.invoiceNumber &&
          other.issueDate == this.issueDate &&
          other.dueDate == this.dueDate &&
          other.taxRate == this.taxRate &&
          other.subTotal == this.subTotal &&
          other.taxAmount == this.taxAmount &&
          other.totalAmount == this.totalAmount &&
          other.status == this.status &&
          other.items == this.items &&
          other.notes == this.notes &&
          other.terms == this.terms &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class InvoicesCompanion extends UpdateCompanion<Invoice> {
  final Value<int> id;
  final Value<String> remoteId;
  final Value<String> clientRemoteId;
  final Value<String> invoiceNumber;
  final Value<DateTime> issueDate;
  final Value<DateTime> dueDate;
  final Value<double> taxRate;
  final Value<double> subTotal;
  final Value<double> taxAmount;
  final Value<double> totalAmount;
  final Value<InvoiceStatus?> status;
  final Value<List<InvoiceItemModel>?> items;
  final Value<String?> notes;
  final Value<String?> terms;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const InvoicesCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.clientRemoteId = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    this.issueDate = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.subTotal = const Value.absent(),
    this.taxAmount = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.status = const Value.absent(),
    this.items = const Value.absent(),
    this.notes = const Value.absent(),
    this.terms = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  InvoicesCompanion.insert({
    this.id = const Value.absent(),
    required String remoteId,
    required String clientRemoteId,
    required String invoiceNumber,
    required DateTime issueDate,
    required DateTime dueDate,
    required double taxRate,
    required double subTotal,
    required double taxAmount,
    required double totalAmount,
    this.status = const Value.absent(),
    this.items = const Value.absent(),
    this.notes = const Value.absent(),
    this.terms = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : remoteId = Value(remoteId),
       clientRemoteId = Value(clientRemoteId),
       invoiceNumber = Value(invoiceNumber),
       issueDate = Value(issueDate),
       dueDate = Value(dueDate),
       taxRate = Value(taxRate),
       subTotal = Value(subTotal),
       taxAmount = Value(taxAmount),
       totalAmount = Value(totalAmount),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Invoice> custom({
    Expression<int>? id,
    Expression<String>? remoteId,
    Expression<String>? clientRemoteId,
    Expression<String>? invoiceNumber,
    Expression<DateTime>? issueDate,
    Expression<DateTime>? dueDate,
    Expression<double>? taxRate,
    Expression<double>? subTotal,
    Expression<double>? taxAmount,
    Expression<double>? totalAmount,
    Expression<String>? status,
    Expression<String>? items,
    Expression<String>? notes,
    Expression<String>? terms,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (clientRemoteId != null) 'client_remote_id': clientRemoteId,
      if (invoiceNumber != null) 'invoice_number': invoiceNumber,
      if (issueDate != null) 'issue_date': issueDate,
      if (dueDate != null) 'due_date': dueDate,
      if (taxRate != null) 'tax_rate': taxRate,
      if (subTotal != null) 'sub_total': subTotal,
      if (taxAmount != null) 'tax_amount': taxAmount,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (status != null) 'status': status,
      if (items != null) 'items': items,
      if (notes != null) 'notes': notes,
      if (terms != null) 'terms': terms,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  InvoicesCompanion copyWith({
    Value<int>? id,
    Value<String>? remoteId,
    Value<String>? clientRemoteId,
    Value<String>? invoiceNumber,
    Value<DateTime>? issueDate,
    Value<DateTime>? dueDate,
    Value<double>? taxRate,
    Value<double>? subTotal,
    Value<double>? taxAmount,
    Value<double>? totalAmount,
    Value<InvoiceStatus?>? status,
    Value<List<InvoiceItemModel>?>? items,
    Value<String?>? notes,
    Value<String?>? terms,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return InvoicesCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      clientRemoteId: clientRemoteId ?? this.clientRemoteId,
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
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (clientRemoteId.present) {
      map['client_remote_id'] = Variable<String>(clientRemoteId.value);
    }
    if (invoiceNumber.present) {
      map['invoice_number'] = Variable<String>(invoiceNumber.value);
    }
    if (issueDate.present) {
      map['issue_date'] = Variable<DateTime>(issueDate.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (taxRate.present) {
      map['tax_rate'] = Variable<double>(taxRate.value);
    }
    if (subTotal.present) {
      map['sub_total'] = Variable<double>(subTotal.value);
    }
    if (taxAmount.present) {
      map['tax_amount'] = Variable<double>(taxAmount.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $InvoicesTable.$converterstatusn.toSql(status.value),
      );
    }
    if (items.present) {
      map['items'] = Variable<String>(
        $InvoicesTable.$converteritemsn.toSql(items.value),
      );
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (terms.present) {
      map['terms'] = Variable<String>(terms.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoicesCompanion(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('clientRemoteId: $clientRemoteId, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('issueDate: $issueDate, ')
          ..write('dueDate: $dueDate, ')
          ..write('taxRate: $taxRate, ')
          ..write('subTotal: $subTotal, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('status: $status, ')
          ..write('items: $items, ')
          ..write('notes: $notes, ')
          ..write('terms: $terms, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ClientsTable extends Clients with TableInfo<$ClientsTable, Client> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
    'remote_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _websiteMeta = const VerificationMeta(
    'website',
  );
  @override
  late final GeneratedColumn<String> website = GeneratedColumn<String>(
    'website',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressLine1Meta = const VerificationMeta(
    'addressLine1',
  );
  @override
  late final GeneratedColumn<String> addressLine1 = GeneratedColumn<String>(
    'address_line1',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressLine2Meta = const VerificationMeta(
    'addressLine2',
  );
  @override
  late final GeneratedColumn<String> addressLine2 = GeneratedColumn<String>(
    'address_line2',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _zipCodeMeta = const VerificationMeta(
    'zipCode',
  );
  @override
  late final GeneratedColumn<String> zipCode = GeneratedColumn<String>(
    'zip_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _countryMeta = const VerificationMeta(
    'country',
  );
  @override
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
    'country',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taxNumberMeta = const VerificationMeta(
    'taxNumber',
  );
  @override
  late final GeneratedColumn<String> taxNumber = GeneratedColumn<String>(
    'tax_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('USD'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    remoteId,
    name,
    email,
    phone,
    website,
    addressLine1,
    addressLine2,
    city,
    state,
    zipCode,
    country,
    taxNumber,
    currency,
    notes,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clients';
  @override
  VerificationContext validateIntegrity(
    Insertable<Client> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_remoteIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('website')) {
      context.handle(
        _websiteMeta,
        website.isAcceptableOrUnknown(data['website']!, _websiteMeta),
      );
    }
    if (data.containsKey('address_line1')) {
      context.handle(
        _addressLine1Meta,
        addressLine1.isAcceptableOrUnknown(
          data['address_line1']!,
          _addressLine1Meta,
        ),
      );
    }
    if (data.containsKey('address_line2')) {
      context.handle(
        _addressLine2Meta,
        addressLine2.isAcceptableOrUnknown(
          data['address_line2']!,
          _addressLine2Meta,
        ),
      );
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('zip_code')) {
      context.handle(
        _zipCodeMeta,
        zipCode.isAcceptableOrUnknown(data['zip_code']!, _zipCodeMeta),
      );
    }
    if (data.containsKey('country')) {
      context.handle(
        _countryMeta,
        country.isAcceptableOrUnknown(data['country']!, _countryMeta),
      );
    }
    if (data.containsKey('tax_number')) {
      context.handle(
        _taxNumberMeta,
        taxNumber.isAcceptableOrUnknown(data['tax_number']!, _taxNumberMeta),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Client map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Client(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      website: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}website'],
      ),
      addressLine1: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address_line1'],
      ),
      addressLine2: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address_line2'],
      ),
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      ),
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      ),
      zipCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}zip_code'],
      ),
      country: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country'],
      ),
      taxNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tax_number'],
      ),
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ClientsTable createAlias(String alias) {
    return $ClientsTable(attachedDatabase, alias);
  }
}

class Client extends DataClass implements Insertable<Client> {
  final int id;
  final String remoteId;
  final String name;
  final String email;
  final String? phone;
  final String? website;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? country;
  final String? taxNumber;
  final String currency;
  final String? notes;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Client({
    required this.id,
    required this.remoteId,
    required this.name,
    required this.email,
    this.phone,
    this.website,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.zipCode,
    this.country,
    this.taxNumber,
    required this.currency,
    this.notes,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['remote_id'] = Variable<String>(remoteId);
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || website != null) {
      map['website'] = Variable<String>(website);
    }
    if (!nullToAbsent || addressLine1 != null) {
      map['address_line1'] = Variable<String>(addressLine1);
    }
    if (!nullToAbsent || addressLine2 != null) {
      map['address_line2'] = Variable<String>(addressLine2);
    }
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    if (!nullToAbsent || state != null) {
      map['state'] = Variable<String>(state);
    }
    if (!nullToAbsent || zipCode != null) {
      map['zip_code'] = Variable<String>(zipCode);
    }
    if (!nullToAbsent || country != null) {
      map['country'] = Variable<String>(country);
    }
    if (!nullToAbsent || taxNumber != null) {
      map['tax_number'] = Variable<String>(taxNumber);
    }
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ClientsCompanion toCompanion(bool nullToAbsent) {
    return ClientsCompanion(
      id: Value(id),
      remoteId: Value(remoteId),
      name: Value(name),
      email: Value(email),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      website: website == null && nullToAbsent
          ? const Value.absent()
          : Value(website),
      addressLine1: addressLine1 == null && nullToAbsent
          ? const Value.absent()
          : Value(addressLine1),
      addressLine2: addressLine2 == null && nullToAbsent
          ? const Value.absent()
          : Value(addressLine2),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      state: state == null && nullToAbsent
          ? const Value.absent()
          : Value(state),
      zipCode: zipCode == null && nullToAbsent
          ? const Value.absent()
          : Value(zipCode),
      country: country == null && nullToAbsent
          ? const Value.absent()
          : Value(country),
      taxNumber: taxNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(taxNumber),
      currency: Value(currency),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Client.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Client(
      id: serializer.fromJson<int>(json['id']),
      remoteId: serializer.fromJson<String>(json['remoteId']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      phone: serializer.fromJson<String?>(json['phone']),
      website: serializer.fromJson<String?>(json['website']),
      addressLine1: serializer.fromJson<String?>(json['addressLine1']),
      addressLine2: serializer.fromJson<String?>(json['addressLine2']),
      city: serializer.fromJson<String?>(json['city']),
      state: serializer.fromJson<String?>(json['state']),
      zipCode: serializer.fromJson<String?>(json['zipCode']),
      country: serializer.fromJson<String?>(json['country']),
      taxNumber: serializer.fromJson<String?>(json['taxNumber']),
      currency: serializer.fromJson<String>(json['currency']),
      notes: serializer.fromJson<String?>(json['notes']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'remoteId': serializer.toJson<String>(remoteId),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'phone': serializer.toJson<String?>(phone),
      'website': serializer.toJson<String?>(website),
      'addressLine1': serializer.toJson<String?>(addressLine1),
      'addressLine2': serializer.toJson<String?>(addressLine2),
      'city': serializer.toJson<String?>(city),
      'state': serializer.toJson<String?>(state),
      'zipCode': serializer.toJson<String?>(zipCode),
      'country': serializer.toJson<String?>(country),
      'taxNumber': serializer.toJson<String?>(taxNumber),
      'currency': serializer.toJson<String>(currency),
      'notes': serializer.toJson<String?>(notes),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Client copyWith({
    int? id,
    String? remoteId,
    String? name,
    String? email,
    Value<String?> phone = const Value.absent(),
    Value<String?> website = const Value.absent(),
    Value<String?> addressLine1 = const Value.absent(),
    Value<String?> addressLine2 = const Value.absent(),
    Value<String?> city = const Value.absent(),
    Value<String?> state = const Value.absent(),
    Value<String?> zipCode = const Value.absent(),
    Value<String?> country = const Value.absent(),
    Value<String?> taxNumber = const Value.absent(),
    String? currency,
    Value<String?> notes = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Client(
    id: id ?? this.id,
    remoteId: remoteId ?? this.remoteId,
    name: name ?? this.name,
    email: email ?? this.email,
    phone: phone.present ? phone.value : this.phone,
    website: website.present ? website.value : this.website,
    addressLine1: addressLine1.present ? addressLine1.value : this.addressLine1,
    addressLine2: addressLine2.present ? addressLine2.value : this.addressLine2,
    city: city.present ? city.value : this.city,
    state: state.present ? state.value : this.state,
    zipCode: zipCode.present ? zipCode.value : this.zipCode,
    country: country.present ? country.value : this.country,
    taxNumber: taxNumber.present ? taxNumber.value : this.taxNumber,
    currency: currency ?? this.currency,
    notes: notes.present ? notes.value : this.notes,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Client copyWithCompanion(ClientsCompanion data) {
    return Client(
      id: data.id.present ? data.id.value : this.id,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      phone: data.phone.present ? data.phone.value : this.phone,
      website: data.website.present ? data.website.value : this.website,
      addressLine1: data.addressLine1.present
          ? data.addressLine1.value
          : this.addressLine1,
      addressLine2: data.addressLine2.present
          ? data.addressLine2.value
          : this.addressLine2,
      city: data.city.present ? data.city.value : this.city,
      state: data.state.present ? data.state.value : this.state,
      zipCode: data.zipCode.present ? data.zipCode.value : this.zipCode,
      country: data.country.present ? data.country.value : this.country,
      taxNumber: data.taxNumber.present ? data.taxNumber.value : this.taxNumber,
      currency: data.currency.present ? data.currency.value : this.currency,
      notes: data.notes.present ? data.notes.value : this.notes,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Client(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('website: $website, ')
          ..write('addressLine1: $addressLine1, ')
          ..write('addressLine2: $addressLine2, ')
          ..write('city: $city, ')
          ..write('state: $state, ')
          ..write('zipCode: $zipCode, ')
          ..write('country: $country, ')
          ..write('taxNumber: $taxNumber, ')
          ..write('currency: $currency, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    remoteId,
    name,
    email,
    phone,
    website,
    addressLine1,
    addressLine2,
    city,
    state,
    zipCode,
    country,
    taxNumber,
    currency,
    notes,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Client &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.name == this.name &&
          other.email == this.email &&
          other.phone == this.phone &&
          other.website == this.website &&
          other.addressLine1 == this.addressLine1 &&
          other.addressLine2 == this.addressLine2 &&
          other.city == this.city &&
          other.state == this.state &&
          other.zipCode == this.zipCode &&
          other.country == this.country &&
          other.taxNumber == this.taxNumber &&
          other.currency == this.currency &&
          other.notes == this.notes &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ClientsCompanion extends UpdateCompanion<Client> {
  final Value<int> id;
  final Value<String> remoteId;
  final Value<String> name;
  final Value<String> email;
  final Value<String?> phone;
  final Value<String?> website;
  final Value<String?> addressLine1;
  final Value<String?> addressLine2;
  final Value<String?> city;
  final Value<String?> state;
  final Value<String?> zipCode;
  final Value<String?> country;
  final Value<String?> taxNumber;
  final Value<String> currency;
  final Value<String?> notes;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ClientsCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.website = const Value.absent(),
    this.addressLine1 = const Value.absent(),
    this.addressLine2 = const Value.absent(),
    this.city = const Value.absent(),
    this.state = const Value.absent(),
    this.zipCode = const Value.absent(),
    this.country = const Value.absent(),
    this.taxNumber = const Value.absent(),
    this.currency = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ClientsCompanion.insert({
    this.id = const Value.absent(),
    required String remoteId,
    required String name,
    required String email,
    this.phone = const Value.absent(),
    this.website = const Value.absent(),
    this.addressLine1 = const Value.absent(),
    this.addressLine2 = const Value.absent(),
    this.city = const Value.absent(),
    this.state = const Value.absent(),
    this.zipCode = const Value.absent(),
    this.country = const Value.absent(),
    this.taxNumber = const Value.absent(),
    this.currency = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : remoteId = Value(remoteId),
       name = Value(name),
       email = Value(email),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Client> custom({
    Expression<int>? id,
    Expression<String>? remoteId,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? phone,
    Expression<String>? website,
    Expression<String>? addressLine1,
    Expression<String>? addressLine2,
    Expression<String>? city,
    Expression<String>? state,
    Expression<String>? zipCode,
    Expression<String>? country,
    Expression<String>? taxNumber,
    Expression<String>? currency,
    Expression<String>? notes,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (website != null) 'website': website,
      if (addressLine1 != null) 'address_line1': addressLine1,
      if (addressLine2 != null) 'address_line2': addressLine2,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (zipCode != null) 'zip_code': zipCode,
      if (country != null) 'country': country,
      if (taxNumber != null) 'tax_number': taxNumber,
      if (currency != null) 'currency': currency,
      if (notes != null) 'notes': notes,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ClientsCompanion copyWith({
    Value<int>? id,
    Value<String>? remoteId,
    Value<String>? name,
    Value<String>? email,
    Value<String?>? phone,
    Value<String?>? website,
    Value<String?>? addressLine1,
    Value<String?>? addressLine2,
    Value<String?>? city,
    Value<String?>? state,
    Value<String?>? zipCode,
    Value<String?>? country,
    Value<String?>? taxNumber,
    Value<String>? currency,
    Value<String?>? notes,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ClientsCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      taxNumber: taxNumber ?? this.taxNumber,
      currency: currency ?? this.currency,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (website.present) {
      map['website'] = Variable<String>(website.value);
    }
    if (addressLine1.present) {
      map['address_line1'] = Variable<String>(addressLine1.value);
    }
    if (addressLine2.present) {
      map['address_line2'] = Variable<String>(addressLine2.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (zipCode.present) {
      map['zip_code'] = Variable<String>(zipCode.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (taxNumber.present) {
      map['tax_number'] = Variable<String>(taxNumber.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientsCompanion(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('website: $website, ')
          ..write('addressLine1: $addressLine1, ')
          ..write('addressLine2: $addressLine2, ')
          ..write('city: $city, ')
          ..write('state: $state, ')
          ..write('zipCode: $zipCode, ')
          ..write('country: $country, ')
          ..write('taxNumber: $taxNumber, ')
          ..write('currency: $currency, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
    'remote_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
    'unit_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stockQuantityMeta = const VerificationMeta(
    'stockQuantity',
  );
  @override
  late final GeneratedColumn<int> stockQuantity = GeneratedColumn<int>(
    'stock_quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _skuMeta = const VerificationMeta('sku');
  @override
  late final GeneratedColumn<String> sku = GeneratedColumn<String>(
    'sku',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _lastUpdatedMeta = const VerificationMeta(
    'lastUpdated',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
    'last_updated',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    remoteId,
    name,
    description,
    unitPrice,
    imagePath,
    stockQuantity,
    sku,
    isActive,
    lastUpdated,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<Product> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_remoteIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('stock_quantity')) {
      context.handle(
        _stockQuantityMeta,
        stockQuantity.isAcceptableOrUnknown(
          data['stock_quantity']!,
          _stockQuantityMeta,
        ),
      );
    }
    if (data.containsKey('sku')) {
      context.handle(
        _skuMeta,
        sku.isAcceptableOrUnknown(data['sku']!, _skuMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('last_updated')) {
      context.handle(
        _lastUpdatedMeta,
        lastUpdated.isAcceptableOrUnknown(
          data['last_updated']!,
          _lastUpdatedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}unit_price'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      stockQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stock_quantity'],
      )!,
      sku: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sku'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      lastUpdated: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_updated'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final int id;
  final String remoteId;
  final String name;
  final String? description;
  final double unitPrice;
  final String? imagePath;
  final int stockQuantity;
  final String? sku;
  final bool isActive;
  final DateTime? lastUpdated;
  final DateTime? createdAt;
  const Product({
    required this.id,
    required this.remoteId,
    required this.name,
    this.description,
    required this.unitPrice,
    this.imagePath,
    required this.stockQuantity,
    this.sku,
    required this.isActive,
    this.lastUpdated,
    this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['remote_id'] = Variable<String>(remoteId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['unit_price'] = Variable<double>(unitPrice);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['stock_quantity'] = Variable<int>(stockQuantity);
    if (!nullToAbsent || sku != null) {
      map['sku'] = Variable<String>(sku);
    }
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || lastUpdated != null) {
      map['last_updated'] = Variable<DateTime>(lastUpdated);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      remoteId: Value(remoteId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      unitPrice: Value(unitPrice),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      stockQuantity: Value(stockQuantity),
      sku: sku == null && nullToAbsent ? const Value.absent() : Value(sku),
      isActive: Value(isActive),
      lastUpdated: lastUpdated == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdated),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory Product.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<int>(json['id']),
      remoteId: serializer.fromJson<String>(json['remoteId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      unitPrice: serializer.fromJson<double>(json['unitPrice']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      stockQuantity: serializer.fromJson<int>(json['stockQuantity']),
      sku: serializer.fromJson<String?>(json['sku']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      lastUpdated: serializer.fromJson<DateTime?>(json['lastUpdated']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'remoteId': serializer.toJson<String>(remoteId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'unitPrice': serializer.toJson<double>(unitPrice),
      'imagePath': serializer.toJson<String?>(imagePath),
      'stockQuantity': serializer.toJson<int>(stockQuantity),
      'sku': serializer.toJson<String?>(sku),
      'isActive': serializer.toJson<bool>(isActive),
      'lastUpdated': serializer.toJson<DateTime?>(lastUpdated),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  Product copyWith({
    int? id,
    String? remoteId,
    String? name,
    Value<String?> description = const Value.absent(),
    double? unitPrice,
    Value<String?> imagePath = const Value.absent(),
    int? stockQuantity,
    Value<String?> sku = const Value.absent(),
    bool? isActive,
    Value<DateTime?> lastUpdated = const Value.absent(),
    Value<DateTime?> createdAt = const Value.absent(),
  }) => Product(
    id: id ?? this.id,
    remoteId: remoteId ?? this.remoteId,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    unitPrice: unitPrice ?? this.unitPrice,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    stockQuantity: stockQuantity ?? this.stockQuantity,
    sku: sku.present ? sku.value : this.sku,
    isActive: isActive ?? this.isActive,
    lastUpdated: lastUpdated.present ? lastUpdated.value : this.lastUpdated,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
  );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      stockQuantity: data.stockQuantity.present
          ? data.stockQuantity.value
          : this.stockQuantity,
      sku: data.sku.present ? data.sku.value : this.sku,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      lastUpdated: data.lastUpdated.present
          ? data.lastUpdated.value
          : this.lastUpdated,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('imagePath: $imagePath, ')
          ..write('stockQuantity: $stockQuantity, ')
          ..write('sku: $sku, ')
          ..write('isActive: $isActive, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    remoteId,
    name,
    description,
    unitPrice,
    imagePath,
    stockQuantity,
    sku,
    isActive,
    lastUpdated,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.name == this.name &&
          other.description == this.description &&
          other.unitPrice == this.unitPrice &&
          other.imagePath == this.imagePath &&
          other.stockQuantity == this.stockQuantity &&
          other.sku == this.sku &&
          other.isActive == this.isActive &&
          other.lastUpdated == this.lastUpdated &&
          other.createdAt == this.createdAt);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<int> id;
  final Value<String> remoteId;
  final Value<String> name;
  final Value<String?> description;
  final Value<double> unitPrice;
  final Value<String?> imagePath;
  final Value<int> stockQuantity;
  final Value<String?> sku;
  final Value<bool> isActive;
  final Value<DateTime?> lastUpdated;
  final Value<DateTime?> createdAt;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.stockQuantity = const Value.absent(),
    this.sku = const Value.absent(),
    this.isActive = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    required String remoteId,
    required String name,
    this.description = const Value.absent(),
    required double unitPrice,
    this.imagePath = const Value.absent(),
    this.stockQuantity = const Value.absent(),
    this.sku = const Value.absent(),
    this.isActive = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : remoteId = Value(remoteId),
       name = Value(name),
       unitPrice = Value(unitPrice);
  static Insertable<Product> custom({
    Expression<int>? id,
    Expression<String>? remoteId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<double>? unitPrice,
    Expression<String>? imagePath,
    Expression<int>? stockQuantity,
    Expression<String>? sku,
    Expression<bool>? isActive,
    Expression<DateTime>? lastUpdated,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (imagePath != null) 'image_path': imagePath,
      if (stockQuantity != null) 'stock_quantity': stockQuantity,
      if (sku != null) 'sku': sku,
      if (isActive != null) 'is_active': isActive,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ProductsCompanion copyWith({
    Value<int>? id,
    Value<String>? remoteId,
    Value<String>? name,
    Value<String?>? description,
    Value<double>? unitPrice,
    Value<String?>? imagePath,
    Value<int>? stockQuantity,
    Value<String?>? sku,
    Value<bool>? isActive,
    Value<DateTime?>? lastUpdated,
    Value<DateTime?>? createdAt,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      name: name ?? this.name,
      description: description ?? this.description,
      unitPrice: unitPrice ?? this.unitPrice,
      imagePath: imagePath ?? this.imagePath,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      sku: sku ?? this.sku,
      isActive: isActive ?? this.isActive,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (stockQuantity.present) {
      map['stock_quantity'] = Variable<int>(stockQuantity.value);
    }
    if (sku.present) {
      map['sku'] = Variable<String>(sku.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('imagePath: $imagePath, ')
          ..write('stockQuantity: $stockQuantity, ')
          ..write('sku: $sku, ')
          ..write('isActive: $isActive, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $BusinessProfilesTable extends BusinessProfiles
    with TableInfo<$BusinessProfilesTable, BusinessProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BusinessProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _businessNameMeta = const VerificationMeta(
    'businessName',
  );
  @override
  late final GeneratedColumn<String> businessName = GeneratedColumn<String>(
    'business_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _logoPathMeta = const VerificationMeta(
    'logoPath',
  );
  @override
  late final GeneratedColumn<String> logoPath = GeneratedColumn<String>(
    'logo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taxNumberMeta = const VerificationMeta(
    'taxNumber',
  );
  @override
  late final GeneratedColumn<String> taxNumber = GeneratedColumn<String>(
    'tax_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _websiteMeta = const VerificationMeta(
    'website',
  );
  @override
  late final GeneratedColumn<String> website = GeneratedColumn<String>(
    'website',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressLine1Meta = const VerificationMeta(
    'addressLine1',
  );
  @override
  late final GeneratedColumn<String> addressLine1 = GeneratedColumn<String>(
    'address_line1',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressLine2Meta = const VerificationMeta(
    'addressLine2',
  );
  @override
  late final GeneratedColumn<String> addressLine2 = GeneratedColumn<String>(
    'address_line2',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _zipCodeMeta = const VerificationMeta(
    'zipCode',
  );
  @override
  late final GeneratedColumn<String> zipCode = GeneratedColumn<String>(
    'zip_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _countryMeta = const VerificationMeta(
    'country',
  );
  @override
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
    'country',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    businessName,
    logoPath,
    taxNumber,
    email,
    phone,
    website,
    addressLine1,
    addressLine2,
    city,
    state,
    zipCode,
    country,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'business_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<BusinessProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('business_name')) {
      context.handle(
        _businessNameMeta,
        businessName.isAcceptableOrUnknown(
          data['business_name']!,
          _businessNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_businessNameMeta);
    }
    if (data.containsKey('logo_path')) {
      context.handle(
        _logoPathMeta,
        logoPath.isAcceptableOrUnknown(data['logo_path']!, _logoPathMeta),
      );
    }
    if (data.containsKey('tax_number')) {
      context.handle(
        _taxNumberMeta,
        taxNumber.isAcceptableOrUnknown(data['tax_number']!, _taxNumberMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('website')) {
      context.handle(
        _websiteMeta,
        website.isAcceptableOrUnknown(data['website']!, _websiteMeta),
      );
    }
    if (data.containsKey('address_line1')) {
      context.handle(
        _addressLine1Meta,
        addressLine1.isAcceptableOrUnknown(
          data['address_line1']!,
          _addressLine1Meta,
        ),
      );
    }
    if (data.containsKey('address_line2')) {
      context.handle(
        _addressLine2Meta,
        addressLine2.isAcceptableOrUnknown(
          data['address_line2']!,
          _addressLine2Meta,
        ),
      );
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('zip_code')) {
      context.handle(
        _zipCodeMeta,
        zipCode.isAcceptableOrUnknown(data['zip_code']!, _zipCodeMeta),
      );
    }
    if (data.containsKey('country')) {
      context.handle(
        _countryMeta,
        country.isAcceptableOrUnknown(data['country']!, _countryMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BusinessProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BusinessProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      businessName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}business_name'],
      )!,
      logoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logo_path'],
      ),
      taxNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tax_number'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      website: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}website'],
      ),
      addressLine1: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address_line1'],
      ),
      addressLine2: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address_line2'],
      ),
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      ),
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      ),
      zipCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}zip_code'],
      ),
      country: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country'],
      ),
    );
  }

  @override
  $BusinessProfilesTable createAlias(String alias) {
    return $BusinessProfilesTable(attachedDatabase, alias);
  }
}

class BusinessProfile extends DataClass implements Insertable<BusinessProfile> {
  final int id;
  final String businessName;
  final String? logoPath;
  final String? taxNumber;
  final String? email;
  final String? phone;
  final String? website;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? country;
  const BusinessProfile({
    required this.id,
    required this.businessName,
    this.logoPath,
    this.taxNumber,
    this.email,
    this.phone,
    this.website,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.zipCode,
    this.country,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['business_name'] = Variable<String>(businessName);
    if (!nullToAbsent || logoPath != null) {
      map['logo_path'] = Variable<String>(logoPath);
    }
    if (!nullToAbsent || taxNumber != null) {
      map['tax_number'] = Variable<String>(taxNumber);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || website != null) {
      map['website'] = Variable<String>(website);
    }
    if (!nullToAbsent || addressLine1 != null) {
      map['address_line1'] = Variable<String>(addressLine1);
    }
    if (!nullToAbsent || addressLine2 != null) {
      map['address_line2'] = Variable<String>(addressLine2);
    }
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    if (!nullToAbsent || state != null) {
      map['state'] = Variable<String>(state);
    }
    if (!nullToAbsent || zipCode != null) {
      map['zip_code'] = Variable<String>(zipCode);
    }
    if (!nullToAbsent || country != null) {
      map['country'] = Variable<String>(country);
    }
    return map;
  }

  BusinessProfilesCompanion toCompanion(bool nullToAbsent) {
    return BusinessProfilesCompanion(
      id: Value(id),
      businessName: Value(businessName),
      logoPath: logoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(logoPath),
      taxNumber: taxNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(taxNumber),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      website: website == null && nullToAbsent
          ? const Value.absent()
          : Value(website),
      addressLine1: addressLine1 == null && nullToAbsent
          ? const Value.absent()
          : Value(addressLine1),
      addressLine2: addressLine2 == null && nullToAbsent
          ? const Value.absent()
          : Value(addressLine2),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      state: state == null && nullToAbsent
          ? const Value.absent()
          : Value(state),
      zipCode: zipCode == null && nullToAbsent
          ? const Value.absent()
          : Value(zipCode),
      country: country == null && nullToAbsent
          ? const Value.absent()
          : Value(country),
    );
  }

  factory BusinessProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BusinessProfile(
      id: serializer.fromJson<int>(json['id']),
      businessName: serializer.fromJson<String>(json['businessName']),
      logoPath: serializer.fromJson<String?>(json['logoPath']),
      taxNumber: serializer.fromJson<String?>(json['taxNumber']),
      email: serializer.fromJson<String?>(json['email']),
      phone: serializer.fromJson<String?>(json['phone']),
      website: serializer.fromJson<String?>(json['website']),
      addressLine1: serializer.fromJson<String?>(json['addressLine1']),
      addressLine2: serializer.fromJson<String?>(json['addressLine2']),
      city: serializer.fromJson<String?>(json['city']),
      state: serializer.fromJson<String?>(json['state']),
      zipCode: serializer.fromJson<String?>(json['zipCode']),
      country: serializer.fromJson<String?>(json['country']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'businessName': serializer.toJson<String>(businessName),
      'logoPath': serializer.toJson<String?>(logoPath),
      'taxNumber': serializer.toJson<String?>(taxNumber),
      'email': serializer.toJson<String?>(email),
      'phone': serializer.toJson<String?>(phone),
      'website': serializer.toJson<String?>(website),
      'addressLine1': serializer.toJson<String?>(addressLine1),
      'addressLine2': serializer.toJson<String?>(addressLine2),
      'city': serializer.toJson<String?>(city),
      'state': serializer.toJson<String?>(state),
      'zipCode': serializer.toJson<String?>(zipCode),
      'country': serializer.toJson<String?>(country),
    };
  }

  BusinessProfile copyWith({
    int? id,
    String? businessName,
    Value<String?> logoPath = const Value.absent(),
    Value<String?> taxNumber = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> website = const Value.absent(),
    Value<String?> addressLine1 = const Value.absent(),
    Value<String?> addressLine2 = const Value.absent(),
    Value<String?> city = const Value.absent(),
    Value<String?> state = const Value.absent(),
    Value<String?> zipCode = const Value.absent(),
    Value<String?> country = const Value.absent(),
  }) => BusinessProfile(
    id: id ?? this.id,
    businessName: businessName ?? this.businessName,
    logoPath: logoPath.present ? logoPath.value : this.logoPath,
    taxNumber: taxNumber.present ? taxNumber.value : this.taxNumber,
    email: email.present ? email.value : this.email,
    phone: phone.present ? phone.value : this.phone,
    website: website.present ? website.value : this.website,
    addressLine1: addressLine1.present ? addressLine1.value : this.addressLine1,
    addressLine2: addressLine2.present ? addressLine2.value : this.addressLine2,
    city: city.present ? city.value : this.city,
    state: state.present ? state.value : this.state,
    zipCode: zipCode.present ? zipCode.value : this.zipCode,
    country: country.present ? country.value : this.country,
  );
  BusinessProfile copyWithCompanion(BusinessProfilesCompanion data) {
    return BusinessProfile(
      id: data.id.present ? data.id.value : this.id,
      businessName: data.businessName.present
          ? data.businessName.value
          : this.businessName,
      logoPath: data.logoPath.present ? data.logoPath.value : this.logoPath,
      taxNumber: data.taxNumber.present ? data.taxNumber.value : this.taxNumber,
      email: data.email.present ? data.email.value : this.email,
      phone: data.phone.present ? data.phone.value : this.phone,
      website: data.website.present ? data.website.value : this.website,
      addressLine1: data.addressLine1.present
          ? data.addressLine1.value
          : this.addressLine1,
      addressLine2: data.addressLine2.present
          ? data.addressLine2.value
          : this.addressLine2,
      city: data.city.present ? data.city.value : this.city,
      state: data.state.present ? data.state.value : this.state,
      zipCode: data.zipCode.present ? data.zipCode.value : this.zipCode,
      country: data.country.present ? data.country.value : this.country,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BusinessProfile(')
          ..write('id: $id, ')
          ..write('businessName: $businessName, ')
          ..write('logoPath: $logoPath, ')
          ..write('taxNumber: $taxNumber, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('website: $website, ')
          ..write('addressLine1: $addressLine1, ')
          ..write('addressLine2: $addressLine2, ')
          ..write('city: $city, ')
          ..write('state: $state, ')
          ..write('zipCode: $zipCode, ')
          ..write('country: $country')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    businessName,
    logoPath,
    taxNumber,
    email,
    phone,
    website,
    addressLine1,
    addressLine2,
    city,
    state,
    zipCode,
    country,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BusinessProfile &&
          other.id == this.id &&
          other.businessName == this.businessName &&
          other.logoPath == this.logoPath &&
          other.taxNumber == this.taxNumber &&
          other.email == this.email &&
          other.phone == this.phone &&
          other.website == this.website &&
          other.addressLine1 == this.addressLine1 &&
          other.addressLine2 == this.addressLine2 &&
          other.city == this.city &&
          other.state == this.state &&
          other.zipCode == this.zipCode &&
          other.country == this.country);
}

class BusinessProfilesCompanion extends UpdateCompanion<BusinessProfile> {
  final Value<int> id;
  final Value<String> businessName;
  final Value<String?> logoPath;
  final Value<String?> taxNumber;
  final Value<String?> email;
  final Value<String?> phone;
  final Value<String?> website;
  final Value<String?> addressLine1;
  final Value<String?> addressLine2;
  final Value<String?> city;
  final Value<String?> state;
  final Value<String?> zipCode;
  final Value<String?> country;
  const BusinessProfilesCompanion({
    this.id = const Value.absent(),
    this.businessName = const Value.absent(),
    this.logoPath = const Value.absent(),
    this.taxNumber = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.website = const Value.absent(),
    this.addressLine1 = const Value.absent(),
    this.addressLine2 = const Value.absent(),
    this.city = const Value.absent(),
    this.state = const Value.absent(),
    this.zipCode = const Value.absent(),
    this.country = const Value.absent(),
  });
  BusinessProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String businessName,
    this.logoPath = const Value.absent(),
    this.taxNumber = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.website = const Value.absent(),
    this.addressLine1 = const Value.absent(),
    this.addressLine2 = const Value.absent(),
    this.city = const Value.absent(),
    this.state = const Value.absent(),
    this.zipCode = const Value.absent(),
    this.country = const Value.absent(),
  }) : businessName = Value(businessName);
  static Insertable<BusinessProfile> custom({
    Expression<int>? id,
    Expression<String>? businessName,
    Expression<String>? logoPath,
    Expression<String>? taxNumber,
    Expression<String>? email,
    Expression<String>? phone,
    Expression<String>? website,
    Expression<String>? addressLine1,
    Expression<String>? addressLine2,
    Expression<String>? city,
    Expression<String>? state,
    Expression<String>? zipCode,
    Expression<String>? country,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (businessName != null) 'business_name': businessName,
      if (logoPath != null) 'logo_path': logoPath,
      if (taxNumber != null) 'tax_number': taxNumber,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (website != null) 'website': website,
      if (addressLine1 != null) 'address_line1': addressLine1,
      if (addressLine2 != null) 'address_line2': addressLine2,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (zipCode != null) 'zip_code': zipCode,
      if (country != null) 'country': country,
    });
  }

  BusinessProfilesCompanion copyWith({
    Value<int>? id,
    Value<String>? businessName,
    Value<String?>? logoPath,
    Value<String?>? taxNumber,
    Value<String?>? email,
    Value<String?>? phone,
    Value<String?>? website,
    Value<String?>? addressLine1,
    Value<String?>? addressLine2,
    Value<String?>? city,
    Value<String?>? state,
    Value<String?>? zipCode,
    Value<String?>? country,
  }) {
    return BusinessProfilesCompanion(
      id: id ?? this.id,
      businessName: businessName ?? this.businessName,
      logoPath: logoPath ?? this.logoPath,
      taxNumber: taxNumber ?? this.taxNumber,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (businessName.present) {
      map['business_name'] = Variable<String>(businessName.value);
    }
    if (logoPath.present) {
      map['logo_path'] = Variable<String>(logoPath.value);
    }
    if (taxNumber.present) {
      map['tax_number'] = Variable<String>(taxNumber.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (website.present) {
      map['website'] = Variable<String>(website.value);
    }
    if (addressLine1.present) {
      map['address_line1'] = Variable<String>(addressLine1.value);
    }
    if (addressLine2.present) {
      map['address_line2'] = Variable<String>(addressLine2.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (zipCode.present) {
      map['zip_code'] = Variable<String>(zipCode.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BusinessProfilesCompanion(')
          ..write('id: $id, ')
          ..write('businessName: $businessName, ')
          ..write('logoPath: $logoPath, ')
          ..write('taxNumber: $taxNumber, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('website: $website, ')
          ..write('addressLine1: $addressLine1, ')
          ..write('addressLine2: $addressLine2, ')
          ..write('city: $city, ')
          ..write('state: $state, ')
          ..write('zipCode: $zipCode, ')
          ..write('country: $country')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $InvoicesTable invoices = $InvoicesTable(this);
  late final $ClientsTable clients = $ClientsTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $BusinessProfilesTable businessProfiles = $BusinessProfilesTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    invoices,
    clients,
    products,
    businessProfiles,
  ];
}

typedef $$InvoicesTableCreateCompanionBuilder =
    InvoicesCompanion Function({
      Value<int> id,
      required String remoteId,
      required String clientRemoteId,
      required String invoiceNumber,
      required DateTime issueDate,
      required DateTime dueDate,
      required double taxRate,
      required double subTotal,
      required double taxAmount,
      required double totalAmount,
      Value<InvoiceStatus?> status,
      Value<List<InvoiceItemModel>?> items,
      Value<String?> notes,
      Value<String?> terms,
      Value<bool> isActive,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$InvoicesTableUpdateCompanionBuilder =
    InvoicesCompanion Function({
      Value<int> id,
      Value<String> remoteId,
      Value<String> clientRemoteId,
      Value<String> invoiceNumber,
      Value<DateTime> issueDate,
      Value<DateTime> dueDate,
      Value<double> taxRate,
      Value<double> subTotal,
      Value<double> taxAmount,
      Value<double> totalAmount,
      Value<InvoiceStatus?> status,
      Value<List<InvoiceItemModel>?> items,
      Value<String?> notes,
      Value<String?> terms,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$InvoicesTableFilterComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientRemoteId => $composableBuilder(
    column: $table.clientRemoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get issueDate => $composableBuilder(
    column: $table.issueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get taxRate => $composableBuilder(
    column: $table.taxRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get subTotal => $composableBuilder(
    column: $table.subTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get taxAmount => $composableBuilder(
    column: $table.taxAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<InvoiceStatus?, InvoiceStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<
    List<InvoiceItemModel>?,
    List<InvoiceItemModel>,
    String
  >
  get items => $composableBuilder(
    column: $table.items,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get terms => $composableBuilder(
    column: $table.terms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InvoicesTableOrderingComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientRemoteId => $composableBuilder(
    column: $table.clientRemoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get issueDate => $composableBuilder(
    column: $table.issueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get taxRate => $composableBuilder(
    column: $table.taxRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get subTotal => $composableBuilder(
    column: $table.subTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get taxAmount => $composableBuilder(
    column: $table.taxAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get items => $composableBuilder(
    column: $table.items,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get terms => $composableBuilder(
    column: $table.terms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InvoicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<String> get clientRemoteId => $composableBuilder(
    column: $table.clientRemoteId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get issueDate =>
      $composableBuilder(column: $table.issueDate, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<double> get taxRate =>
      $composableBuilder(column: $table.taxRate, builder: (column) => column);

  GeneratedColumn<double> get subTotal =>
      $composableBuilder(column: $table.subTotal, builder: (column) => column);

  GeneratedColumn<double> get taxAmount =>
      $composableBuilder(column: $table.taxAmount, builder: (column) => column);

  GeneratedColumn<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<InvoiceStatus?, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<InvoiceItemModel>?, String> get items =>
      $composableBuilder(column: $table.items, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get terms =>
      $composableBuilder(column: $table.terms, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$InvoicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InvoicesTable,
          Invoice,
          $$InvoicesTableFilterComposer,
          $$InvoicesTableOrderingComposer,
          $$InvoicesTableAnnotationComposer,
          $$InvoicesTableCreateCompanionBuilder,
          $$InvoicesTableUpdateCompanionBuilder,
          (Invoice, BaseReferences<_$AppDatabase, $InvoicesTable, Invoice>),
          Invoice,
          PrefetchHooks Function()
        > {
  $$InvoicesTableTableManager(_$AppDatabase db, $InvoicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvoicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvoicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvoicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> remoteId = const Value.absent(),
                Value<String> clientRemoteId = const Value.absent(),
                Value<String> invoiceNumber = const Value.absent(),
                Value<DateTime> issueDate = const Value.absent(),
                Value<DateTime> dueDate = const Value.absent(),
                Value<double> taxRate = const Value.absent(),
                Value<double> subTotal = const Value.absent(),
                Value<double> taxAmount = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<InvoiceStatus?> status = const Value.absent(),
                Value<List<InvoiceItemModel>?> items = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> terms = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => InvoicesCompanion(
                id: id,
                remoteId: remoteId,
                clientRemoteId: clientRemoteId,
                invoiceNumber: invoiceNumber,
                issueDate: issueDate,
                dueDate: dueDate,
                taxRate: taxRate,
                subTotal: subTotal,
                taxAmount: taxAmount,
                totalAmount: totalAmount,
                status: status,
                items: items,
                notes: notes,
                terms: terms,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String remoteId,
                required String clientRemoteId,
                required String invoiceNumber,
                required DateTime issueDate,
                required DateTime dueDate,
                required double taxRate,
                required double subTotal,
                required double taxAmount,
                required double totalAmount,
                Value<InvoiceStatus?> status = const Value.absent(),
                Value<List<InvoiceItemModel>?> items = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> terms = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => InvoicesCompanion.insert(
                id: id,
                remoteId: remoteId,
                clientRemoteId: clientRemoteId,
                invoiceNumber: invoiceNumber,
                issueDate: issueDate,
                dueDate: dueDate,
                taxRate: taxRate,
                subTotal: subTotal,
                taxAmount: taxAmount,
                totalAmount: totalAmount,
                status: status,
                items: items,
                notes: notes,
                terms: terms,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InvoicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InvoicesTable,
      Invoice,
      $$InvoicesTableFilterComposer,
      $$InvoicesTableOrderingComposer,
      $$InvoicesTableAnnotationComposer,
      $$InvoicesTableCreateCompanionBuilder,
      $$InvoicesTableUpdateCompanionBuilder,
      (Invoice, BaseReferences<_$AppDatabase, $InvoicesTable, Invoice>),
      Invoice,
      PrefetchHooks Function()
    >;
typedef $$ClientsTableCreateCompanionBuilder =
    ClientsCompanion Function({
      Value<int> id,
      required String remoteId,
      required String name,
      required String email,
      Value<String?> phone,
      Value<String?> website,
      Value<String?> addressLine1,
      Value<String?> addressLine2,
      Value<String?> city,
      Value<String?> state,
      Value<String?> zipCode,
      Value<String?> country,
      Value<String?> taxNumber,
      Value<String> currency,
      Value<String?> notes,
      Value<bool> isActive,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$ClientsTableUpdateCompanionBuilder =
    ClientsCompanion Function({
      Value<int> id,
      Value<String> remoteId,
      Value<String> name,
      Value<String> email,
      Value<String?> phone,
      Value<String?> website,
      Value<String?> addressLine1,
      Value<String?> addressLine2,
      Value<String?> city,
      Value<String?> state,
      Value<String?> zipCode,
      Value<String?> country,
      Value<String?> taxNumber,
      Value<String> currency,
      Value<String?> notes,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$ClientsTableFilterComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addressLine1 => $composableBuilder(
    column: $table.addressLine1,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addressLine2 => $composableBuilder(
    column: $table.addressLine2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get zipCode => $composableBuilder(
    column: $table.zipCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taxNumber => $composableBuilder(
    column: $table.taxNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ClientsTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addressLine1 => $composableBuilder(
    column: $table.addressLine1,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addressLine2 => $composableBuilder(
    column: $table.addressLine2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get zipCode => $composableBuilder(
    column: $table.zipCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taxNumber => $composableBuilder(
    column: $table.taxNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ClientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get website =>
      $composableBuilder(column: $table.website, builder: (column) => column);

  GeneratedColumn<String> get addressLine1 => $composableBuilder(
    column: $table.addressLine1,
    builder: (column) => column,
  );

  GeneratedColumn<String> get addressLine2 => $composableBuilder(
    column: $table.addressLine2,
    builder: (column) => column,
  );

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get zipCode =>
      $composableBuilder(column: $table.zipCode, builder: (column) => column);

  GeneratedColumn<String> get country =>
      $composableBuilder(column: $table.country, builder: (column) => column);

  GeneratedColumn<String> get taxNumber =>
      $composableBuilder(column: $table.taxNumber, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ClientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClientsTable,
          Client,
          $$ClientsTableFilterComposer,
          $$ClientsTableOrderingComposer,
          $$ClientsTableAnnotationComposer,
          $$ClientsTableCreateCompanionBuilder,
          $$ClientsTableUpdateCompanionBuilder,
          (Client, BaseReferences<_$AppDatabase, $ClientsTable, Client>),
          Client,
          PrefetchHooks Function()
        > {
  $$ClientsTableTableManager(_$AppDatabase db, $ClientsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> remoteId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> website = const Value.absent(),
                Value<String?> addressLine1 = const Value.absent(),
                Value<String?> addressLine2 = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<String?> zipCode = const Value.absent(),
                Value<String?> country = const Value.absent(),
                Value<String?> taxNumber = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ClientsCompanion(
                id: id,
                remoteId: remoteId,
                name: name,
                email: email,
                phone: phone,
                website: website,
                addressLine1: addressLine1,
                addressLine2: addressLine2,
                city: city,
                state: state,
                zipCode: zipCode,
                country: country,
                taxNumber: taxNumber,
                currency: currency,
                notes: notes,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String remoteId,
                required String name,
                required String email,
                Value<String?> phone = const Value.absent(),
                Value<String?> website = const Value.absent(),
                Value<String?> addressLine1 = const Value.absent(),
                Value<String?> addressLine2 = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<String?> zipCode = const Value.absent(),
                Value<String?> country = const Value.absent(),
                Value<String?> taxNumber = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => ClientsCompanion.insert(
                id: id,
                remoteId: remoteId,
                name: name,
                email: email,
                phone: phone,
                website: website,
                addressLine1: addressLine1,
                addressLine2: addressLine2,
                city: city,
                state: state,
                zipCode: zipCode,
                country: country,
                taxNumber: taxNumber,
                currency: currency,
                notes: notes,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ClientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClientsTable,
      Client,
      $$ClientsTableFilterComposer,
      $$ClientsTableOrderingComposer,
      $$ClientsTableAnnotationComposer,
      $$ClientsTableCreateCompanionBuilder,
      $$ClientsTableUpdateCompanionBuilder,
      (Client, BaseReferences<_$AppDatabase, $ClientsTable, Client>),
      Client,
      PrefetchHooks Function()
    >;
typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      Value<int> id,
      required String remoteId,
      required String name,
      Value<String?> description,
      required double unitPrice,
      Value<String?> imagePath,
      Value<int> stockQuantity,
      Value<String?> sku,
      Value<bool> isActive,
      Value<DateTime?> lastUpdated,
      Value<DateTime?> createdAt,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<int> id,
      Value<String> remoteId,
      Value<String> name,
      Value<String?> description,
      Value<double> unitPrice,
      Value<String?> imagePath,
      Value<int> stockQuantity,
      Value<String?> sku,
      Value<bool> isActive,
      Value<DateTime?> lastUpdated,
      Value<DateTime?> createdAt,
    });

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stockQuantity => $composableBuilder(
    column: $table.stockQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sku => $composableBuilder(
    column: $table.sku,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stockQuantity => $composableBuilder(
    column: $table.stockQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sku => $composableBuilder(
    column: $table.sku,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<int> get stockQuantity => $composableBuilder(
    column: $table.stockQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sku =>
      $composableBuilder(column: $table.sku, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          Product,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
          Product,
          PrefetchHooks Function()
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> remoteId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<double> unitPrice = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<int> stockQuantity = const Value.absent(),
                Value<String?> sku = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime?> lastUpdated = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                remoteId: remoteId,
                name: name,
                description: description,
                unitPrice: unitPrice,
                imagePath: imagePath,
                stockQuantity: stockQuantity,
                sku: sku,
                isActive: isActive,
                lastUpdated: lastUpdated,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String remoteId,
                required String name,
                Value<String?> description = const Value.absent(),
                required double unitPrice,
                Value<String?> imagePath = const Value.absent(),
                Value<int> stockQuantity = const Value.absent(),
                Value<String?> sku = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime?> lastUpdated = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                remoteId: remoteId,
                name: name,
                description: description,
                unitPrice: unitPrice,
                imagePath: imagePath,
                stockQuantity: stockQuantity,
                sku: sku,
                isActive: isActive,
                lastUpdated: lastUpdated,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      Product,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
      Product,
      PrefetchHooks Function()
    >;
typedef $$BusinessProfilesTableCreateCompanionBuilder =
    BusinessProfilesCompanion Function({
      Value<int> id,
      required String businessName,
      Value<String?> logoPath,
      Value<String?> taxNumber,
      Value<String?> email,
      Value<String?> phone,
      Value<String?> website,
      Value<String?> addressLine1,
      Value<String?> addressLine2,
      Value<String?> city,
      Value<String?> state,
      Value<String?> zipCode,
      Value<String?> country,
    });
typedef $$BusinessProfilesTableUpdateCompanionBuilder =
    BusinessProfilesCompanion Function({
      Value<int> id,
      Value<String> businessName,
      Value<String?> logoPath,
      Value<String?> taxNumber,
      Value<String?> email,
      Value<String?> phone,
      Value<String?> website,
      Value<String?> addressLine1,
      Value<String?> addressLine2,
      Value<String?> city,
      Value<String?> state,
      Value<String?> zipCode,
      Value<String?> country,
    });

class $$BusinessProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $BusinessProfilesTable> {
  $$BusinessProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get businessName => $composableBuilder(
    column: $table.businessName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get logoPath => $composableBuilder(
    column: $table.logoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taxNumber => $composableBuilder(
    column: $table.taxNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addressLine1 => $composableBuilder(
    column: $table.addressLine1,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addressLine2 => $composableBuilder(
    column: $table.addressLine2,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get zipCode => $composableBuilder(
    column: $table.zipCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BusinessProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $BusinessProfilesTable> {
  $$BusinessProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get businessName => $composableBuilder(
    column: $table.businessName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logoPath => $composableBuilder(
    column: $table.logoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taxNumber => $composableBuilder(
    column: $table.taxNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get website => $composableBuilder(
    column: $table.website,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addressLine1 => $composableBuilder(
    column: $table.addressLine1,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addressLine2 => $composableBuilder(
    column: $table.addressLine2,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get zipCode => $composableBuilder(
    column: $table.zipCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BusinessProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BusinessProfilesTable> {
  $$BusinessProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get businessName => $composableBuilder(
    column: $table.businessName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get logoPath =>
      $composableBuilder(column: $table.logoPath, builder: (column) => column);

  GeneratedColumn<String> get taxNumber =>
      $composableBuilder(column: $table.taxNumber, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get website =>
      $composableBuilder(column: $table.website, builder: (column) => column);

  GeneratedColumn<String> get addressLine1 => $composableBuilder(
    column: $table.addressLine1,
    builder: (column) => column,
  );

  GeneratedColumn<String> get addressLine2 => $composableBuilder(
    column: $table.addressLine2,
    builder: (column) => column,
  );

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get zipCode =>
      $composableBuilder(column: $table.zipCode, builder: (column) => column);

  GeneratedColumn<String> get country =>
      $composableBuilder(column: $table.country, builder: (column) => column);
}

class $$BusinessProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BusinessProfilesTable,
          BusinessProfile,
          $$BusinessProfilesTableFilterComposer,
          $$BusinessProfilesTableOrderingComposer,
          $$BusinessProfilesTableAnnotationComposer,
          $$BusinessProfilesTableCreateCompanionBuilder,
          $$BusinessProfilesTableUpdateCompanionBuilder,
          (
            BusinessProfile,
            BaseReferences<
              _$AppDatabase,
              $BusinessProfilesTable,
              BusinessProfile
            >,
          ),
          BusinessProfile,
          PrefetchHooks Function()
        > {
  $$BusinessProfilesTableTableManager(
    _$AppDatabase db,
    $BusinessProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BusinessProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BusinessProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BusinessProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> businessName = const Value.absent(),
                Value<String?> logoPath = const Value.absent(),
                Value<String?> taxNumber = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> website = const Value.absent(),
                Value<String?> addressLine1 = const Value.absent(),
                Value<String?> addressLine2 = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<String?> zipCode = const Value.absent(),
                Value<String?> country = const Value.absent(),
              }) => BusinessProfilesCompanion(
                id: id,
                businessName: businessName,
                logoPath: logoPath,
                taxNumber: taxNumber,
                email: email,
                phone: phone,
                website: website,
                addressLine1: addressLine1,
                addressLine2: addressLine2,
                city: city,
                state: state,
                zipCode: zipCode,
                country: country,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String businessName,
                Value<String?> logoPath = const Value.absent(),
                Value<String?> taxNumber = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> website = const Value.absent(),
                Value<String?> addressLine1 = const Value.absent(),
                Value<String?> addressLine2 = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<String?> zipCode = const Value.absent(),
                Value<String?> country = const Value.absent(),
              }) => BusinessProfilesCompanion.insert(
                id: id,
                businessName: businessName,
                logoPath: logoPath,
                taxNumber: taxNumber,
                email: email,
                phone: phone,
                website: website,
                addressLine1: addressLine1,
                addressLine2: addressLine2,
                city: city,
                state: state,
                zipCode: zipCode,
                country: country,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BusinessProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BusinessProfilesTable,
      BusinessProfile,
      $$BusinessProfilesTableFilterComposer,
      $$BusinessProfilesTableOrderingComposer,
      $$BusinessProfilesTableAnnotationComposer,
      $$BusinessProfilesTableCreateCompanionBuilder,
      $$BusinessProfilesTableUpdateCompanionBuilder,
      (
        BusinessProfile,
        BaseReferences<_$AppDatabase, $BusinessProfilesTable, BusinessProfile>,
      ),
      BusinessProfile,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$InvoicesTableTableManager get invoices =>
      $$InvoicesTableTableManager(_db, _db.invoices);
  $$ClientsTableTableManager get clients =>
      $$ClientsTableTableManager(_db, _db.clients);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$BusinessProfilesTableTableManager get businessProfiles =>
      $$BusinessProfilesTableTableManager(_db, _db.businessProfiles);
}
