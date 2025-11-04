import 'package:flutter/material.dart';

/// Widget per visualizzare uno stato vuoto
/// 
/// Questo widget riutilizzabile mostra un'icona, titolo e sottotitolo
/// quando non ci sono dati da visualizzare.
class EmptyState extends StatelessWidget {
  /// Icona da mostrare
  final IconData icon;
  
  /// Titolo principale
  final String title;
  
  /// Sottotitolo/descrizione
  final String subtitle;
  
  /// Dimensione dell'icona (default: 80)
  final double iconSize;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconSize = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icona principale
            Icon(
              icon,
              size: iconSize,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            
            // Titolo
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            
            // Sottotitolo
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}