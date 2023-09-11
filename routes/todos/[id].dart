import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:todos_data_source/todos_data_source.dart';

FutureOr<Response> onRequest(RequestContext context, String id) async {
  final dataSource = context.read<TodosDataSource>();
  final todo = await dataSource.read(id);

  if (todo == null) {
    return Response(statusCode: HttpStatus.notFound, body: 'Not Found');
  }

  switch (context.request.method) {
    case HttpMethod.get:
      return get(context, todo);
    case HttpMethod.put:
      return put(context, id, todo);
    case HttpMethod.delete:
      return delete(context, id);
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.post:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> get(RequestContext context, Todo todo) async {
  return Response.json(body: todo);
}

Future<Response> put(RequestContext context, String id, Todo todo) async {
  final dataSource = context.read<TodosDataSource>();
  final jsn = await context.request.json() as Map<String, dynamic>;
  final updateTodo = Todo.fromJson(jsn);
  final newTodo = await dataSource.update(
    id,
    todo.copyWith(
      title: updateTodo.title,
      description: updateTodo.description,
      isCompleted: updateTodo.isCompleted,
    ),
  );

  return Response.json(body: newTodo);
}

Future<Response> delete(RequestContext context, String id) async {
  final dataSource = context.read<TodosDataSource>();
  await dataSource.delete(id);

  return Response.json(
    statusCode: HttpStatus.noContent,
    body: 'Delete Success',
  );
}
