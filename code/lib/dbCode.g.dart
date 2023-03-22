// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dbCode.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: type=lint
class NottData extends dft.DataClass implements dft.Insertable<NottData> {
  final int id;
  final String title;
  final String body;
  final String color;
  NottData(
      {required this.id,
      required this.title,
      required this.body,
      required this.color});
  factory NottData.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return NottData(
      id: const dft.IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      title: const dft.StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
      body: const dft.StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}body'])!,
      color: const dft.StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}color'])!,
    );
  }
  @override
  Map<String, dft.Expression> toColumns(bool nullToAbsent) {
    final map = <String, dft.Expression>{};
    map['id'] = dft.Variable<int>(id);
    map['title'] = dft.Variable<String>(title);
    map['body'] = dft.Variable<String>(body);
    map['color'] = dft.Variable<String>(color);
    return map;
  }

  NottCompanion toCompanion(bool nullToAbsent) {
    return NottCompanion(
      id: dft.Value(id),
      title: dft.Value(title),
      body: dft.Value(body),
      color: dft.Value(color),
    );
  }

  factory NottData.fromJson(Map<String, dynamic> json,
      {dft.ValueSerializer? serializer}) {
    serializer ??= dft.driftRuntimeOptions.defaultSerializer;
    return NottData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      color: serializer.fromJson<String>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({dft.ValueSerializer? serializer}) {
    serializer ??= dft.driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'color': serializer.toJson<String>(color),
    };
  }

  NottData copyWith({int? id, String? title, String? body, String? color}) =>
      NottData(
        id: id ?? this.id,
        title: title ?? this.title,
        body: body ?? this.body,
        color: color ?? this.color,
      );
  @override
  String toString() {
    return (StringBuffer('NottData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, body, color);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NottData &&
          other.id == this.id &&
          other.title == this.title &&
          other.body == this.body &&
          other.color == this.color);
}

class NottCompanion extends dft.UpdateCompanion<NottData> {
  final dft.Value<int> id;
  final dft.Value<String> title;
  final dft.Value<String> body;
  final dft.Value<String> color;
  const NottCompanion({
    this.id = const dft.Value.absent(),
    this.title = const dft.Value.absent(),
    this.body = const dft.Value.absent(),
    this.color = const dft.Value.absent(),
  });
  NottCompanion.insert({
    this.id = const dft.Value.absent(),
    required String title,
    required String body,
    required String color,
  })  : title = dft.Value(title),
        body = dft.Value(body),
        color = dft.Value(color);
  static dft.Insertable<NottData> custom({
    dft.Expression<int>? id,
    dft.Expression<String>? title,
    dft.Expression<String>? body,
    dft.Expression<String>? color,
  }) {
    return dft.RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (color != null) 'color': color,
    });
  }

  NottCompanion copyWith(
      {dft.Value<int>? id,
      dft.Value<String>? title,
      dft.Value<String>? body,
      dft.Value<String>? color}) {
    return NottCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      color: color ?? this.color,
    );
  }

  @override
  Map<String, dft.Expression> toColumns(bool nullToAbsent) {
    final map = <String, dft.Expression>{};
    if (id.present) {
      map['id'] = dft.Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = dft.Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = dft.Variable<String>(body.value);
    }
    if (color.present) {
      map['color'] = dft.Variable<String>(color.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NottCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }
}

class $NottTable extends Nott with dft.TableInfo<$NottTable, NottData> {
  @override
  final dft.GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NottTable(this.attachedDatabase, [this._alias]);
  final dft.VerificationMeta _idMeta = const dft.VerificationMeta('id');
  @override
  late final dft.GeneratedColumn<int?> id = dft.GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const dft.IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final dft.VerificationMeta _titleMeta = const dft.VerificationMeta('title');
  @override
  late final dft.GeneratedColumn<String?> title = dft.GeneratedColumn<String?>(
      'title', aliasedName, false,
      type: const dft.StringType(), requiredDuringInsert: true);
  final dft.VerificationMeta _bodyMeta = const dft.VerificationMeta('body');
  @override
  late final dft.GeneratedColumn<String?> body = dft.GeneratedColumn<String?>(
      'body', aliasedName, false,
      type: const dft.StringType(), requiredDuringInsert: true);
  final dft.VerificationMeta _colorMeta = const dft.VerificationMeta('color');
  @override
  late final dft.GeneratedColumn<String?> color = dft.GeneratedColumn<String?>(
      'color', aliasedName, false,
      type: const dft.StringType(), requiredDuringInsert: true);
  @override
  List<dft.GeneratedColumn> get $columns => [id, title, body, color];
  @override
  String get aliasedName => _alias ?? 'nott';
  @override
  String get actualTableName => 'nott';
  @override
  dft.VerificationContext validateIntegrity(dft.Insertable<NottData> instance,
      {bool isInserting = false}) {
    final context = dft.VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
          _bodyMeta, body.isAcceptableOrUnknown(data['body']!, _bodyMeta));
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    return context;
  }

  @override
  Set<dft.GeneratedColumn> get $primaryKey => {id};
  @override
  NottData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return NottData.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $NottTable createAlias(String alias) {
    return $NottTable(attachedDatabase, alias);
  }
}

abstract class _$MyDatabase extends dft.GeneratedDatabase {
  _$MyDatabase(dft.QueryExecutor e)
      : super(dft.SqlTypeSystem.defaultInstance, e);
  late final $NottTable nott = $NottTable(this);
  @override
  Iterable<dft.TableInfo> get allTables =>
      allSchemaEntities.whereType<dft.TableInfo>();
  @override
  List<dft.DatabaseSchemaEntity> get allSchemaEntities => [nott];
}
