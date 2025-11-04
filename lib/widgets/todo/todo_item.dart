import 'package:flutter/material.dart';
import '../../models/todo.dart';
import '../../utils/app_theme.dart';

/// Widget per rappresentare un singolo Todo item nella lista
/// 
/// Questo widget è responsabile della visualizzazione di un singolo Todo
/// con tutte le sue proprietà e azioni disponibili (completare, eliminare).
class TodoItem extends StatelessWidget {
  /// Il Todo da visualizzare
  final Todo todo;
  
  /// Callback chiamato quando l'utente tocca la checkbox
  final VoidCallback onToggle;
  
  /// Callback chiamato quando l'utente tocca il pulsante elimina
  final VoidCallback onDelete;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        // Checkbox per completare/scompletare il Todo
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (_) => onToggle(),
        ),
        
        // Titolo del Todo con stile condizionale
        title: Text(
          todo.title,
          style: todo.isCompleted
              ? AppTextStyles.completedTodo
              : Theme.of(context).textTheme.titleMedium,
        ),
        
        // Descrizione (se presente) con stile condizionale
        subtitle: todo.description.isNotEmpty
            ? Text(
                todo.description,
                style: TextStyle(
                  color: todo.isCompleted 
                      ? Colors.grey 
                      : Theme.of(context).textTheme.bodyMedium?.color,
                  decoration: todo.isCompleted 
                      ? TextDecoration.lineThrough 
                      : TextDecoration.none,
                ),
              )
            : null,
        
        // Area di azioni (data e pulsante elimina)
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Data di creazione
            Text(
              _formatDate(todo.createdAt),
              style: AppTextStyles.caption,
            ),
            const SizedBox(width: 8),
            
            // Pulsante elimina
            IconButton(
              icon: Icon(
                Icons.delete,
                color: AppTheme.errorColor,
              ),
              onPressed: onDelete,
              tooltip: 'Elimina Todo',
            ),
          ],
        ),
        
        // Feedback visivo per Todo completati
        tileColor: todo.isCompleted 
            ? Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3)
            : null,
      ),
    );
  }

  /// Formatta la data in formato giorno/mese/anno
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
           '${date.month.toString().padLeft(2, '0')}/'
           '${date.year}';
  }
}