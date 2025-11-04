import 'package:flutter/material.dart';
import '../../models/todo.dart';
import 'todo_item.dart';
import '../common/empty_state.dart';

/// Widget che gestisce la visualizzazione della lista di Todo
/// 
/// Questo widget si occupa di:
/// - Mostrare un indicatore di caricamento quando necessario
/// - Visualizzare uno stato vuoto quando non ci sono Todo
/// - Renderizzare la lista di Todo utilizzando TodoItem
class TodoList extends StatelessWidget {
  /// Lista dei Todo da visualizzare
  final List<Todo> todos;
  
  /// Callback chiamato quando si vuole cambiare lo stato di un Todo
  final Function(Todo) onToggle;
  
  /// Callback chiamato quando si vuole eliminare un Todo
  final Function(String) onDelete;
  
  /// Indica se i dati sono in caricamento
  final bool isLoading;

  const TodoList({
    super.key,
    required this.todos,
    required this.onToggle,
    required this.onDelete,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // Mostra indicatore di caricamento
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Caricamento Todo...'),
          ],
        ),
      );
    }

    // Mostra stato vuoto se non ci sono Todo
    if (todos.isEmpty) {
      return const EmptyState(
        icon: Icons.task_alt,
        title: 'Nessun Todo ancora!',
        subtitle: 'Tocca + per aggiungerne uno',
      );
    }

    // Mostra la lista di Todo
    return ListView.builder(
      itemCount: todos.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        final todo = todos[index];
        return TodoItem(
          todo: todo,
          onToggle: () => onToggle(todo),
          onDelete: () => _showDeleteConfirmation(context, todo),
        );
      },
    );
  }

  /// Mostra un dialog di conferma prima di eliminare un Todo
  void _showDeleteConfirmation(BuildContext context, Todo todo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Conferma eliminazione'),
          content: Text(
            'Sei sicuro di voler eliminare il Todo "${todo.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annulla'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onDelete(todo.id);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Elimina'),
            ),
          ],
        );
      },
    );
  }
}