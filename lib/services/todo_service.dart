import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';

/// Servizio per gestire la persistenza dei Todo usando SharedPreferences.
/// 
/// Questo servizio fornisce metodi per:
/// - Caricare i Todo da SharedPreferences
/// - Salvare i Todo in SharedPreferences  
/// - Aggiungere, aggiornare ed eliminare singoli Todo
/// 
/// I dati vengono salvati come stringa JSON in SharedPreferences.
/// Questo approccio funziona su tutte le piattaforme Flutter.
class TodoService {
  static const String _key = 'todos_list';
  
  /// Ottiene l'istanza di SharedPreferences
  Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  /// Carica tutti i Todo da SharedPreferences
  /// 
  /// Ritorna una lista vuota se non ci sono Todo salvati o in caso di errore
  Future<List<Todo>> loadTodos() async {
    try {
      final prefs = await _getPrefs();
      final jsonString = prefs.getString(_key);
      
      if (jsonString == null) {
        return [];
      }

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => Todo.fromJson(json)).toList();
    } catch (e) {
      print('Errore nel caricamento Todo: $e');
      return [];
    }
  }

  /// Salva tutti i Todo in SharedPreferences
  /// 
  /// [todos] - Lista di Todo da salvare
  Future<void> saveTodos(List<Todo> todos) async {
    try {
      final prefs = await _getPrefs();
      final jsonList = todos.map((todo) => todo.toJson()).toList();
      final jsonString = json.encode(jsonList);
      
      await prefs.setString(_key, jsonString);
      print('Todo salvati con successo: ${todos.length} elementi');
    } catch (e) {
      print('Errore nel salvataggio Todo: $e');
    }
  }

  /// Aggiunge un nuovo Todo alla lista e salva
  /// 
  /// [todo] - Il Todo da aggiungere
  Future<void> addTodo(Todo todo) async {
    final todos = await loadTodos();
    todos.add(todo);
    await saveTodos(todos);
  }

  /// Aggiorna un Todo esistente
  /// 
  /// [updatedTodo] - Il Todo con le modifiche
  Future<void> updateTodo(Todo updatedTodo) async {
    final todos = await loadTodos();
    final index = todos.indexWhere((todo) => todo.id == updatedTodo.id);
    
    if (index != -1) {
      todos[index] = updatedTodo;
      await saveTodos(todos);
    }
  }

  /// Elimina un Todo dalla lista
  /// 
  /// [id] - L'ID del Todo da eliminare
  Future<void> deleteTodo(String id) async {
    final todos = await loadTodos();
    todos.removeWhere((todo) => todo.id == id);
    await saveTodos(todos);
  }
}