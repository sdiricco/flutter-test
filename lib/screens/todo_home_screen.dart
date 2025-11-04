import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/todo_service.dart';
import '../widgets/todo/todo_list.dart';
import '../widgets/todo/add_todo_dialog.dart';

/// Schermata principale dell'app Todo
/// 
/// Questa schermata gestisce lo stato principale dell'applicazione
/// e coordina l'interazione tra i vari widget componenti.
class TodoHomeScreen extends StatefulWidget {
  const TodoHomeScreen({super.key});

  @override
  State<TodoHomeScreen> createState() => _TodoHomeScreenState();
}

class _TodoHomeScreenState extends State<TodoHomeScreen> {
  final TodoService _todoService = TodoService();
  List<Todo> _todos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  /// Carica tutti i Todo dal servizio
  /// 
  /// Questo metodo gestisce lo stato di caricamento e aggiorna la UI
  Future<void> _loadTodos() async {
    setState(() => _isLoading = true);
    
    try {
      final todos = await _todoService.loadTodos();
      setState(() {
        _todos = todos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Errore nel caricamento dei Todo: $e');
    }
  }

  /// Aggiunge un nuovo Todo
  Future<void> _addTodo(String title, String description) async {
    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
    );

    try {
      await _todoService.addTodo(newTodo);
      await _loadTodos(); // Ricarica la lista
      _showSuccessSnackBar('Todo aggiunto con successo!');
    } catch (e) {
      _showErrorSnackBar('Errore nell\'aggiunta del Todo: $e');
    }
  }

  /// Cambia lo stato di completamento di un Todo
  Future<void> _toggleTodo(Todo todo) async {
    try {
      final updatedTodo = todo.copyWith(isCompleted: !todo.isCompleted);
      await _todoService.updateTodo(updatedTodo);
      await _loadTodos(); // Ricarica la lista
      
      final message = updatedTodo.isCompleted 
          ? 'Todo completato!' 
          : 'Todo riattivato!';
      _showSuccessSnackBar(message);
    } catch (e) {
      _showErrorSnackBar('Errore nell\'aggiornamento del Todo: $e');
    }
  }

  /// Elimina un Todo
  Future<void> _deleteTodo(String id) async {
    try {
      await _todoService.deleteTodo(id);
      await _loadTodos(); // Ricarica la lista
      _showSuccessSnackBar('Todo eliminato con successo!');
    } catch (e) {
      _showErrorSnackBar('Errore nell\'eliminazione del Todo: $e');
    }
  }

  /// Mostra il dialog per aggiungere un nuovo Todo
  void _showAddTodoDialog() {
    showDialog(
      context: context,
      builder: (_) => AddTodoDialog(onAdd: _addTodo),
    );
  }

  /// Mostra un messaggio di successo
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Mostra un messaggio di errore
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Calcola le statistiche dei Todo
  Map<String, int> get _todoStats {
    final total = _todos.length;
    final completed = _todos.where((todo) => todo.isCompleted).length;
    final pending = total - completed;
    
    return {
      'total': total,
      'completed': completed,
      'pending': pending,
    };
  }

  @override
  Widget build(BuildContext context) {
    final stats = _todoStats;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('La Mia Todo App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Pulsante refresh
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTodos,
            tooltip: 'Ricarica Todo',
          ),
          
          // Badge con statistiche
          if (stats['total']! > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Chip(
                  label: Text(
                    '${stats['completed']}/${stats['total']}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: stats['pending'] == 0 
                      ? Colors.green.withOpacity(0.2)
                      : Colors.orange.withOpacity(0.2),
                ),
              ),
            ),
        ],
      ),
      
      // Corpo principale con la lista Todo
      body: TodoList(
        todos: _todos,
        onToggle: _toggleTodo,
        onDelete: _deleteTodo,
        isLoading: _isLoading,
      ),
      
      // Pulsante per aggiungere Todo
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        tooltip: 'Aggiungi Todo',
        child: const Icon(Icons.add),
      ),
    );
  }
}