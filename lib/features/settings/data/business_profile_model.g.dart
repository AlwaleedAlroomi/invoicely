// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_profile_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBusinessProfileModelCollection on Isar {
  IsarCollection<BusinessProfileModel> get businessProfileModels =>
      this.collection();
}

const BusinessProfileModelSchema = CollectionSchema(
  name: r'BusinessProfileModel',
  id: 5258442860494852993,
  properties: {
    r'businessName': PropertySchema(
      id: 0,
      name: r'businessName',
      type: IsarType.string,
    ),
    r'displayName': PropertySchema(
      id: 1,
      name: r'displayName',
      type: IsarType.string,
    ),
    r'logo': PropertySchema(
      id: 2,
      name: r'logo',
      type: IsarType.string,
    ),
    r'logoPath': PropertySchema(
      id: 3,
      name: r'logoPath',
      type: IsarType.string,
    )
  },
  estimateSize: _businessProfileModelEstimateSize,
  serialize: _businessProfileModelSerialize,
  deserialize: _businessProfileModelDeserialize,
  deserializeProp: _businessProfileModelDeserializeProp,
  idName: r'isarId',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _businessProfileModelGetId,
  getLinks: _businessProfileModelGetLinks,
  attach: _businessProfileModelAttach,
  version: '3.1.0+1',
);

int _businessProfileModelEstimateSize(
  BusinessProfileModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.businessName.length * 3;
  bytesCount += 3 + object.displayName.length * 3;
  {
    final value = object.logo;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.logoPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _businessProfileModelSerialize(
  BusinessProfileModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.businessName);
  writer.writeString(offsets[1], object.displayName);
  writer.writeString(offsets[2], object.logo);
  writer.writeString(offsets[3], object.logoPath);
}

BusinessProfileModel _businessProfileModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BusinessProfileModel(
    businessName: reader.readString(offsets[0]),
    logoPath: reader.readStringOrNull(offsets[3]),
  );
  object.isarId = id;
  return object;
}

P _businessProfileModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _businessProfileModelGetId(BusinessProfileModel object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _businessProfileModelGetLinks(
    BusinessProfileModel object) {
  return [];
}

void _businessProfileModelAttach(
    IsarCollection<dynamic> col, Id id, BusinessProfileModel object) {
  object.isarId = id;
}

extension BusinessProfileModelQueryWhereSort
    on QueryBuilder<BusinessProfileModel, BusinessProfileModel, QWhere> {
  QueryBuilder<BusinessProfileModel, BusinessProfileModel, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BusinessProfileModelQueryWhere
    on QueryBuilder<BusinessProfileModel, BusinessProfileModel, QWhereClause> {
  QueryBuilder<BusinessProfileModel, BusinessProfileModel, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel, QAfterWhereClause>
      isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BusinessProfileModelQueryFilter on QueryBuilder<BusinessProfileModel,
    BusinessProfileModel, QFilterCondition> {
  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> businessNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'businessName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> businessNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'businessName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> businessNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'businessName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> businessNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'businessName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> businessNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'businessName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> businessNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'businessName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
          QAfterFilterCondition>
      businessNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'businessName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
          QAfterFilterCondition>
      businessNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'businessName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> businessNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'businessName',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> businessNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'businessName',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> displayNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> displayNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> displayNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> displayNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'displayName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> displayNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> displayNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
          QAfterFilterCondition>
      displayNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
          QAfterFilterCondition>
      displayNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'displayName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> displayNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayName',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> displayNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'displayName',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> logoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'logo',
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> logoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'logo',
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> logoEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'logo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> logoGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'logo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> logoLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'logo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> logoBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'logo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> logoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'logo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> logoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'logo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
          QAfterFilterCondition>
      logoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'logo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
          QAfterFilterCondition>
      logoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'logo',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> logoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'logo',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> logoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'logo',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> logoPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'logoPath',
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> logoPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'logoPath',
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> logoPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'logoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> logoPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'logoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> logoPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'logoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> logoPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'logoPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> logoPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'logoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> logoPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'logoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
          QAfterFilterCondition>
      logoPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'logoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
          QAfterFilterCondition>
      logoPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'logoPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> logoPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'logoPath',
        value: '',
      ));
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel,
      QAfterFilterCondition> logoPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'logoPath',
        value: '',
      ));
    });
  }
}

extension BusinessProfileModelQueryObject on QueryBuilder<BusinessProfileModel,
    BusinessProfileModel, QFilterCondition> {}

extension BusinessProfileModelQueryLinks on QueryBuilder<BusinessProfileModel,
    BusinessProfileModel, QFilterCondition> {}

extension BusinessProfileModelQuerySortBy
    on QueryBuilder<BusinessProfileModel, BusinessProfileModel, QSortBy> {
  QueryBuilder<BusinessProfileModel, BusinessProfileModel, QAfterSortBy>
      sortByBusinessName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessName', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel, QAfterSortBy>
      sortByBusinessNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessName', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel, QAfterSortBy>
      sortByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel, QAfterSortBy>
      sortByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel, QAfterSortBy>
      sortByLogo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logo', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel, QAfterSortBy>
      sortByLogoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logo', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel, QAfterSortBy>
      sortByLogoPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoPath', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel, QAfterSortBy>
      sortByLogoPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoPath', Sort.desc);
    });
  }
}

extension BusinessProfileModelQuerySortThenBy
    on QueryBuilder<BusinessProfileModel, BusinessProfileModel, QSortThenBy> {
  QueryBuilder<BusinessProfileModel, BusinessProfileModel, QAfterSortBy>
      thenByBusinessName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessName', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel, QAfterSortBy>
      thenByBusinessNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessName', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel, QAfterSortBy>
      thenByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel, QAfterSortBy>
      thenByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel, QAfterSortBy>
      thenByLogo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logo', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel, QAfterSortBy>
      thenByLogoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logo', Sort.desc);
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel, QAfterSortBy>
      thenByLogoPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoPath', Sort.asc);
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel, QAfterSortBy>
      thenByLogoPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoPath', Sort.desc);
    });
  }
}

extension BusinessProfileModelQueryWhereDistinct
    on QueryBuilder<BusinessProfileModel, BusinessProfileModel, QDistinct> {
  QueryBuilder<BusinessProfileModel, BusinessProfileModel, QDistinct>
      distinctByBusinessName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'businessName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel, QDistinct>
      distinctByDisplayName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'displayName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel, QDistinct>
      distinctByLogo({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'logo', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BusinessProfileModel, BusinessProfileModel, QDistinct>
      distinctByLogoPath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'logoPath', caseSensitive: caseSensitive);
    });
  }
}

extension BusinessProfileModelQueryProperty on QueryBuilder<
    BusinessProfileModel, BusinessProfileModel, QQueryProperty> {
  QueryBuilder<BusinessProfileModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<BusinessProfileModel, String, QQueryOperations>
      businessNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'businessName');
    });
  }

  QueryBuilder<BusinessProfileModel, String, QQueryOperations>
      displayNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'displayName');
    });
  }

  QueryBuilder<BusinessProfileModel, String?, QQueryOperations> logoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'logo');
    });
  }

  QueryBuilder<BusinessProfileModel, String?, QQueryOperations>
      logoPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'logoPath');
    });
  }
}
