
//import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:storage/database/todo_db.dart';
import 'package:storage/model/todo.dart';
import 'package:storage/widgets/todo_widget.dart';
import 'package:intl/intl.dart'; // Add this for DateFormat

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodosPageState();
}

class _TodosPageState extends State<TodoPage> {
  Future<List<Todo>>? futureTodos;
  final todoDb = TodoDb();

  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  void fetchTodos() {
    setState(() {
      futureTodos = todoDb.fetchAll();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('ToDo List'),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 111, 92, 92),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => CreateToDoWidget(
                onSubmit: (title) async {
                  await todoDb.create(title: title);
                  if (!mounted) return;
                  fetchTodos();
                  Navigator.of(context).pop();
                },
              ),
            );
          },
        ),
        body: FutureBuilder<List<Todo>>(
          future: futureTodos,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              final todos = snapshot.data!;

              return todos.isEmpty
                  ? const Center(child: Text('No todos'))
                  : ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(height: 12),
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        final todo = todos[index];
                        final subtitle = DateFormat('yyyy/MM/dd').format(
                          DateTime.parse(todo.updatedAt ?? todo.createdAt),
                        );

                        return ListTile(
                          title: Text(todo.title),
                          subtitle: Text(subtitle),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await todoDb.delete(todo.id);
                              fetchTodos();
                            },
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => CreateToDoWidget(
                                todo: todo,
                                onSubmit: (title) async {
                                  await todoDb.update(
                                    id: todo.id,
                                    title: title,
                                  );
                                  fetchTodos();
                                  if (!mounted) return;
                                  Navigator.of(context).pop();
                                },
                              ),
                            );
                          },
                        );
                      },
                    );
            }
          },
        ),
      );
}
