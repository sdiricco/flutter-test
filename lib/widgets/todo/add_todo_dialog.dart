import 'package:flutter/material.dart';

/// Dialog per aggiungere un nuovo Todo
/// 
/// Questo widget mostra un dialog con campi per inserire il titolo
/// e la descrizione di un nuovo Todo, con validazione del form.
class AddTodoDialog extends StatefulWidget {
  /// Callback chiamato quando si vuole aggiungere un Todo
  final Function(String title, String description) onAdd;

  const AddTodoDialog({
    super.key,
    required this.onAdd,
  });

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    // Importante: pulire i controller per evitare memory leak
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  /// Gestisce l'aggiunta del Todo con validazione
  Future<void> _handleAdd() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      
      try {
        await widget.onAdd(
          _titleController.text.trim(),
          _descriptionController.text.trim(),
        );
        
        if (mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        // Gestione errori
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Errore nell\'aggiunta del Todo: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nuovo Todo'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Campo titolo
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Titolo',
                hintText: 'Inserisci il titolo del Todo',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Il titolo è obbligatorio';
                }
                if (value.trim().length < 3) {
                  return 'Il titolo deve avere almeno 3 caratteri';
                }
                return null;
              },
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),
            
            // Campo descrizione
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrizione (opzionale)',
                hintText: 'Aggiungi una descrizione...',
                prefixIcon: Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              enabled: !_isLoading,
            ),
          ],
        ),
      ),
      actions: [
        // Pulsante Annulla
        TextButton(
          onPressed: _isLoading 
              ? null 
              : () => Navigator.of(context).pop(),
          child: const Text('Annulla'),
        ),
        
        // Pulsante Aggiungi
        ElevatedButton(
          onPressed: _isLoading ? null : _handleAdd,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Aggiungi'),
        ),
      ],
    );
  }
}