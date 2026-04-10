import 'package:invoicely/core/models/sortable_entity.dart';
import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

part 'client_model.g.dart';

const uuid = Uuid();

@collection
class ClientModel implements SortableEntity {
  Id? isarId = Isar.autoIncrement;

  @Index(unique: true)
  String? remoteId;

  String name;
  String email;
  String? phone;
  String? website;

  // Address
  String? addressLine1;
  String? addressLine2;
  String? city;
  String? state;
  String? zipCode;
  String? country;

  // Business
  String? taxNumber;
  String currency = 'USD';

  // Meta
  String? notes;
  bool isActive = true;
  DateTime createdAt;
  DateTime updatedAt;

  ClientModel({
    this.isarId,
    String? remoteId,
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
    this.currency = 'USD',
    this.notes,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  }) : remoteId = remoteId ?? uuid.v4();

  factory ClientModel.fromModel(ClientModel other) {
    return other.copyWith(updatedAt: DateTime.now());
  }

  ClientModel copyWith({
    Id? isarId,
    String? remoteId,
    String? name,
    String? email,
    String? phone,
    String? website,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    String? taxNumber,
    String? currency,
    String? notes,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ClientModel(
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
        updatedAt: updatedAt ?? DateTime.now(),
      )
      ..isarId = isarId
      ..remoteId = this.remoteId;
  }

  @override
  // TODO: implement dateCreated
  DateTime get dateCreated => createdAt;

  @override
  // TODO: implement displayName
  String get displayName => name;
}
