import 'package:drift/drift.dart' as dft;
import 'package:path/path.dart' as p;
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
part 'dbCode.g.dart';

dft.LazyDatabase _openConnection() {
  return dft.LazyDatabase(() async {
    // DriftIsolate isolate = await _DriftIsolate();
    // DatabaseConnection connection = await isolate.connect();
    // return connection.executor;

    final dbFolder = await getApplicationDocumentsDirectory();
    try {
      if (Platform.isAndroid) {
        final file = File(p.join(dbFolder.path, 'Nott.sqlite'));
        return NativeDatabase(file);
      } else {
        final file = File(p.join(Directory.current.path, 'assets/Nott.db'));
        return NativeDatabase(file);
      }
    } catch (e) {
      final file = File(p.join(dbFolder.path, 'Nott.sqlite'));
      return NativeDatabase(file);
    }
  });
}

@dft.DriftDatabase(tables: [Nott])
class MyDatabase extends _$MyDatabase {
  MyDatabase.connect(dft.DatabaseConnection connection)
      : super(_openConnection());

  @override
  int get schemaVersion => 1;
  //CREATE
  Future<int> insertNott(NottCompanion entry) async {
    return await into(nott).insert(entry);
  }

  //READ
  Future<NottData> readNott(int id) async {
    return await (select(nott)..where((tbl) => tbl.id.equals(id))).getSingle();
  }

  //READ ALL
  Future<List<NottData>> readAllNott() async {
    return await (select(nott)).get();
  }

  //UPDATE
  Future<bool> updateNott(NottCompanion entity) async {
    return await update(nott).replace(entity);
  }

  //DELETE
  Future<int> deleteNott(int id) async {
    return await (delete(nott)..where((tbl) => tbl.id.equals(id))).go();
  }
}

class Nott extends dft.Table {
  dft.IntColumn get id => integer().autoIncrement()();
  dft.TextColumn get title => text().named('title')();
  dft.TextColumn get body => text().named('body')();
  dft.TextColumn get color => text().named('color')();
}
