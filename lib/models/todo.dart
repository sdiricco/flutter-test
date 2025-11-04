/// Modello dati per rappresentare un singolo Todo item.
/// 
/// Questa classe definisce la struttura di un Todo con tutte le proprietà
/// necessarie e i metodi per la serializzazione JSON.
/// 
/// Proprietà:
/// - [id]: Identificatore univoco del Todo
/// - [title]: Titolo del Todo (obbligatorio)
/// - [description]: Descrizione opzionale del Todo
/// - [isCompleted]: Stato di completamento (default: false)
/// - [createdAt]: Data e ora di creazione del Todo
/// 
/// Metodi principali:
/// - [fromJson]: Crea un Todo da dati JSON (per il caricamento)
/// - [toJson]: Converte il Todo in JSON (per il salvataggio)
/// - [copyWith]: Crea una copia modificata del Todo (per gli aggiornamenti)
class Todo {
  /// Identificatore univoco del Todo
  final String id;
  
  /// Titolo del Todo (campo obbligatorio)
  final String title;
  
  /// Descrizione opzionale del Todo
  final String description;
  
  /// Indica se il Todo è stato completato
  final bool isCompleted;
  
  /// Data e ora di creazione del Todo
  final DateTime createdAt;

  /// Costruttore per creare un nuovo Todo
  /// 
  /// [id] e [title] sono obbligatori
  /// [description] è opzionale (default: stringa vuota)
  /// [isCompleted] è opzionale (default: false)
  /// [createdAt] è obbligatorio
  Todo({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    required this.createdAt,
  });

  /// Factory constructor per creare un Todo da dati JSON
  /// 
  /// Utilizzato quando si caricano i Todo dal file JSON locale
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  /// Converte il Todo in formato JSON
  /// 
  /// Utilizzato quando si salvano i Todo nel file JSON locale
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Crea una copia del Todo con alcune proprietà modificate
  /// 
  /// Utile per aggiornare un Todo esistente senza modificare l'originale.
  /// Solo le proprietà specificate verranno cambiate.
  Todo copyWith({
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return Todo(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
    );
  }
}