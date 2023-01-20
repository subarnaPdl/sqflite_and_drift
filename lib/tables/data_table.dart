import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'data_table.g.dart';

class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 6, max: 32)();

  // TextColumn get content => text().named('body')();
  // we can use .named(....) or @JsonKey(....) to specify the column title
  // @JsonKey('body')
  // TextColumn get content => text()();

  @JsonKey('body')
  TextColumn get content => text()();
}

@DriftDatabase(tables: [Todos], daos: [TodosDao])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_lazyDatabase());

  @override
  int schemaVersion = 1;
}

LazyDatabase _lazyDatabase() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'database.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

@DriftAccessor(tables: [Todos])
class TodosDao extends DatabaseAccessor<MyDatabase> with _$TodosDaoMixin {
  final MyDatabase db;
  TodosDao(this.db) : super(db);

  Future<void> createTodo(
      {required String title, required String content}) async {
    await db
        .into(db.todos)
        .insert(TodosCompanion.insert(title: title, content: content));
    await displayAllTodos();
  }

  Future<Todo> readTodo({required int id}) async {
    final List<Todo> todos = await db.select(db.todos).get();
    return todos.firstWhere((element) => element.id == id);
  }

  Future<void> updateTodo({required int id, required Todo todo}) async {
    await (db.update(db.todos)..where((tbl) => tbl.id.equals(id))).write(todo);
    await displayAllTodos();
  }

  Future<void> deleteTodo({required int id}) async {
    await (db.delete(db.todos)..where((tbl) => tbl.id.equals(id))).go();
    await displayAllTodos();
  }

  Future<void> displayAllTodos() async {
    final todos = await db.select(db.todos).get();
    print('Todos : $todos\n');
  }
}
