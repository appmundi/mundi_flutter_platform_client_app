import 'package:flutter/material.dart';

/// Ícone do endereço a partir do apelido — usado tanto nos chips de escolha
/// quanto no card de endereço salvo, para os dois nunca divergirem.
IconData addressLabelIcon(String? label) {
  switch (label) {
    case 'Casa':
      return Icons.home_outlined;
    case 'Trabalho':
      return Icons.work_outline;
    default:
      return Icons.location_on_outlined;
  }
}
