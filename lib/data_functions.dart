import 'package:sqflite_and_drift/tables/data_table.dart';

Future<void> dataFunctions() async {
  final todosDao = MyDatabase().todosDao;
  print('1. Create todo');
  await todosDao.createTodo(
      title: 'Learning drift', content: 'I am learning drift');

  print('2. Read todo');
  Todo todo = await todosDao.readTodo(id: 1);
  print('Todo at 1 is : ${todo.title} => ${todo.content}');

  print('3. Update todo');
  await todosDao.updateTodo(
      id: 1,
      todo: const Todo(
          id: 1,
          title: 'Learning Go Router',
          content: 'I wish to learn Go Router'));

  print('4. Delete todo');
  await todosDao.deleteTodo(id: 1);
}
