// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPlayerCollection on Isar {
  IsarCollection<Player> get players => this.collection();
}

const PlayerSchema = CollectionSchema(
  name: r'Player',
  id: -1052842935974721688,
  properties: {
    r'gender': PropertySchema(
      id: 0,
      name: r'gender',
      type: IsarType.string,
    ),
    r'isFocused': PropertySchema(
      id: 1,
      name: r'isFocused',
      type: IsarType.bool,
    ),
    r'level': PropertySchema(
      id: 2,
      name: r'level',
      type: IsarType.long,
    ),
    r'level1Score': PropertySchema(
      id: 3,
      name: r'level1Score',
      type: IsarType.long,
    ),
    r'level2Score': PropertySchema(
      id: 4,
      name: r'level2Score',
      type: IsarType.long,
    ),
    r'level3Score': PropertySchema(
      id: 5,
      name: r'level3Score',
      type: IsarType.long,
    ),
    r'level4Score': PropertySchema(
      id: 6,
      name: r'level4Score',
      type: IsarType.long,
    ),
    r'level5Score': PropertySchema(
      id: 7,
      name: r'level5Score',
      type: IsarType.long,
    )
  },
  estimateSize: _playerEstimateSize,
  serialize: _playerSerialize,
  deserialize: _playerDeserialize,
  deserializeProp: _playerDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _playerGetId,
  getLinks: _playerGetLinks,
  attach: _playerAttach,
  version: '3.1.8',
);

int _playerEstimateSize(
  Player object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.gender;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _playerSerialize(
  Player object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.gender);
  writer.writeBool(offsets[1], object.isFocused);
  writer.writeLong(offsets[2], object.level);
  writer.writeLong(offsets[3], object.level1Score);
  writer.writeLong(offsets[4], object.level2Score);
  writer.writeLong(offsets[5], object.level3Score);
  writer.writeLong(offsets[6], object.level4Score);
  writer.writeLong(offsets[7], object.level5Score);
}

Player _playerDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Player(
    reader.readLongOrNull(offsets[2]),
  );
  object.gender = reader.readStringOrNull(offsets[0]);
  object.id = id;
  object.isFocused = reader.readBoolOrNull(offsets[1]);
  object.level1Score = reader.readLongOrNull(offsets[3]);
  object.level2Score = reader.readLongOrNull(offsets[4]);
  object.level3Score = reader.readLongOrNull(offsets[5]);
  object.level4Score = reader.readLongOrNull(offsets[6]);
  object.level5Score = reader.readLongOrNull(offsets[7]);
  return object;
}

P _playerDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readBoolOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _playerGetId(Player object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _playerGetLinks(Player object) {
  return [];
}

void _playerAttach(IsarCollection<dynamic> col, Id id, Player object) {
  object.id = id;
}

extension PlayerQueryWhereSort on QueryBuilder<Player, Player, QWhere> {
  QueryBuilder<Player, Player, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PlayerQueryWhere on QueryBuilder<Player, Player, QWhereClause> {
  QueryBuilder<Player, Player, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Player, Player, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Player, Player, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Player, Player, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PlayerQueryFilter on QueryBuilder<Player, Player, QFilterCondition> {
  QueryBuilder<Player, Player, QAfterFilterCondition> genderIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'gender',
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> genderIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'gender',
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> genderEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> genderGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> genderLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> genderBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gender',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> genderStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> genderEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> genderContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> genderMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'gender',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> genderIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gender',
        value: '',
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> genderIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'gender',
        value: '',
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> isFocusedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isFocused',
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> isFocusedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isFocused',
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> isFocusedEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isFocused',
        value: value,
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> levelIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'level',
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> levelIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'level',
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> levelEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'level',
        value: value,
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> levelGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'level',
        value: value,
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> levelLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'level',
        value: value,
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> levelBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'level',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> level1ScoreIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'level1Score',
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> level1ScoreIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'level1Score',
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> level1ScoreEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'level1Score',
        value: value,
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> level1ScoreGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'level1Score',
        value: value,
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> level1ScoreLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'level1Score',
        value: value,
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> level1ScoreBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'level1Score',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> level2ScoreIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'level2Score',
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> level2ScoreIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'level2Score',
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> level2ScoreEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'level2Score',
        value: value,
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> level2ScoreGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'level2Score',
        value: value,
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> level2ScoreLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'level2Score',
        value: value,
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> level2ScoreBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'level2Score',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> level3ScoreIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'level3Score',
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> level3ScoreIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'level3Score',
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> level3ScoreEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'level3Score',
        value: value,
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> level3ScoreGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'level3Score',
        value: value,
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> level3ScoreLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'level3Score',
        value: value,
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> level3ScoreBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'level3Score',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> level4ScoreIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'level4Score',
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> level4ScoreIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'level4Score',
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> level4ScoreEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'level4Score',
        value: value,
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> level4ScoreGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'level4Score',
        value: value,
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> level4ScoreLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'level4Score',
        value: value,
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> level4ScoreBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'level4Score',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> level5ScoreIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'level5Score',
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> level5ScoreIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'level5Score',
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> level5ScoreEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'level5Score',
        value: value,
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> level5ScoreGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'level5Score',
        value: value,
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> level5ScoreLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'level5Score',
        value: value,
      ));
    });
  }

  QueryBuilder<Player, Player, QAfterFilterCondition> level5ScoreBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'level5Score',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PlayerQueryObject on QueryBuilder<Player, Player, QFilterCondition> {}

extension PlayerQueryLinks on QueryBuilder<Player, Player, QFilterCondition> {}

extension PlayerQuerySortBy on QueryBuilder<Player, Player, QSortBy> {
  QueryBuilder<Player, Player, QAfterSortBy> sortByGender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.asc);
    });
  }

  QueryBuilder<Player, Player, QAfterSortBy> sortByGenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.desc);
    });
  }

  QueryBuilder<Player, Player, QAfterSortBy> sortByIsFocused() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFocused', Sort.asc);
    });
  }

  QueryBuilder<Player, Player, QAfterSortBy> sortByIsFocusedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFocused', Sort.desc);
    });
  }

  QueryBuilder<Player, Player, QAfterSortBy> sortByLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.asc);
    });
  }

  QueryBuilder<Player, Player, QAfterSortBy> sortByLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.desc);
    });
  }

  QueryBuilder<Player, Player, QAfterSortBy> sortByLevel1Score() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level1Score', Sort.asc);
    });
  }

  QueryBuilder<Player, Player, QAfterSortBy> sortByLevel1ScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level1Score', Sort.desc);
    });
  }

  QueryBuilder<Player, Player, QAfterSortBy> sortByLevel2Score() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level2Score', Sort.asc);
    });
  }

  QueryBuilder<Player, Player, QAfterSortBy> sortByLevel2ScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level2Score', Sort.desc);
    });
  }

  QueryBuilder<Player, Player, QAfterSortBy> sortByLevel3Score() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level3Score', Sort.asc);
    });
  }

  QueryBuilder<Player, Player, QAfterSortBy> sortByLevel3ScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level3Score', Sort.desc);
    });
  }

  QueryBuilder<Player, Player, QAfterSortBy> sortByLevel4Score() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level4Score', Sort.asc);
    });
  }

  QueryBuilder<Player, Player, QAfterSortBy> sortByLevel4ScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level4Score', Sort.desc);
    });
  }

  QueryBuilder<Player, Player, QAfterSortBy> sortByLevel5Score() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level5Score', Sort.asc);
    });
  }

  QueryBuilder<Player, Player, QAfterSortBy> sortByLevel5ScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level5Score', Sort.desc);
    });
  }
}

extension PlayerQuerySortThenBy on QueryBuilder<Player, Player, QSortThenBy> {
  QueryBuilder<Player, Player, QAfterSortBy> thenByGender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.asc);
    });
  }

  QueryBuilder<Player, Player, QAfterSortBy> thenByGenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.desc);
    });
  }

  QueryBuilder<Player, Player, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Player, Player, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Player, Player, QAfterSortBy> thenByIsFocused() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFocused', Sort.asc);
    });
  }

  QueryBuilder<Player, Player, QAfterSortBy> thenByIsFocusedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFocused', Sort.desc);
    });
  }

  QueryBuilder<Player, Player, QAfterSortBy> thenByLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.asc);
    });
  }

  QueryBuilder<Player, Player, QAfterSortBy> thenByLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.desc);
    });
  }

  QueryBuilder<Player, Player, QAfterSortBy> thenByLevel1Score() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level1Score', Sort.asc);
    });
  }

  QueryBuilder<Player, Player, QAfterSortBy> thenByLevel1ScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level1Score', Sort.desc);
    });
  }

  QueryBuilder<Player, Player, QAfterSortBy> thenByLevel2Score() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level2Score', Sort.asc);
    });
  }

  QueryBuilder<Player, Player, QAfterSortBy> thenByLevel2ScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level2Score', Sort.desc);
    });
  }

  QueryBuilder<Player, Player, QAfterSortBy> thenByLevel3Score() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level3Score', Sort.asc);
    });
  }

  QueryBuilder<Player, Player, QAfterSortBy> thenByLevel3ScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level3Score', Sort.desc);
    });
  }

  QueryBuilder<Player, Player, QAfterSortBy> thenByLevel4Score() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level4Score', Sort.asc);
    });
  }

  QueryBuilder<Player, Player, QAfterSortBy> thenByLevel4ScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level4Score', Sort.desc);
    });
  }

  QueryBuilder<Player, Player, QAfterSortBy> thenByLevel5Score() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level5Score', Sort.asc);
    });
  }

  QueryBuilder<Player, Player, QAfterSortBy> thenByLevel5ScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level5Score', Sort.desc);
    });
  }
}

extension PlayerQueryWhereDistinct on QueryBuilder<Player, Player, QDistinct> {
  QueryBuilder<Player, Player, QDistinct> distinctByGender(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gender', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Player, Player, QDistinct> distinctByIsFocused() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFocused');
    });
  }

  QueryBuilder<Player, Player, QDistinct> distinctByLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'level');
    });
  }

  QueryBuilder<Player, Player, QDistinct> distinctByLevel1Score() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'level1Score');
    });
  }

  QueryBuilder<Player, Player, QDistinct> distinctByLevel2Score() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'level2Score');
    });
  }

  QueryBuilder<Player, Player, QDistinct> distinctByLevel3Score() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'level3Score');
    });
  }

  QueryBuilder<Player, Player, QDistinct> distinctByLevel4Score() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'level4Score');
    });
  }

  QueryBuilder<Player, Player, QDistinct> distinctByLevel5Score() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'level5Score');
    });
  }
}

extension PlayerQueryProperty on QueryBuilder<Player, Player, QQueryProperty> {
  QueryBuilder<Player, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Player, String?, QQueryOperations> genderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gender');
    });
  }

  QueryBuilder<Player, bool?, QQueryOperations> isFocusedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFocused');
    });
  }

  QueryBuilder<Player, int?, QQueryOperations> levelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'level');
    });
  }

  QueryBuilder<Player, int?, QQueryOperations> level1ScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'level1Score');
    });
  }

  QueryBuilder<Player, int?, QQueryOperations> level2ScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'level2Score');
    });
  }

  QueryBuilder<Player, int?, QQueryOperations> level3ScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'level3Score');
    });
  }

  QueryBuilder<Player, int?, QQueryOperations> level4ScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'level4Score');
    });
  }

  QueryBuilder<Player, int?, QQueryOperations> level5ScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'level5Score');
    });
  }
}
