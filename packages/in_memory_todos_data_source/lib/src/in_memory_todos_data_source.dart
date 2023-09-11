import 'package:todos_data_source/todos_data_source.dart';
import 'package:uuid/uuid.dart';

class InMemoryTodosDataSource implements TodosDataSource {
  final cache = <String, Todo>{};

  @override
  Future<Todo> create(Todo todo) async {
    final id = const Uuid().v4();
    final createdTodo = todo.copyWith(id: id);
    cache[id] = createdTodo;

    return createdTodo;
  }

  @override
  Future<void> delete(String id) async {
    cache.remove(id);
  }

  @override
  Future<Todo?> read(String id) async {
    return cache[id];
  }

  @override
  Future<List<Todo>> readAll() async {
    return cache.values.toList();
  }

  @override
  Future<Todo> update(String id, Todo todo) async {
    return cache.update(id, (value) => todo);
  }
}
