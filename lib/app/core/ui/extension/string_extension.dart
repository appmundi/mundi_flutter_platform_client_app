import 'dart:convert';
import 'dart:typed_data';

extension StringExtension on String {
  List<int> get getHourAndMinuteFromAppTimeFormat {
    try {
      if (isEmpty) {
        throw Exception('String de hora vazia');
      }

      // Remove espaços em branco
      String timeString = trim();

      // Tenta primeiro com formato "HH:mm" ou "H:mm"
      if (timeString.contains(':')) {
        List<String> parts = timeString.split(':');
        if (parts.length == 2) {
          int hour = int.parse(parts[0].trim());
          int minute = int.parse(parts[1].trim());
          return [hour, minute];
        }
      }

      // Tenta com formato "XhY" ou "Xh" (formato do app)
      if (timeString.contains('h') || timeString.contains('H')) {
        // Remove qualquer caractere que não seja número ou 'h'
        timeString = timeString.replaceAll(RegExp(r'[^0-9hH]'), '');
        
        List<String> parts = timeString.split(RegExp(r'[hH]'));
        
        if (parts.length >= 1 && parts[0].isNotEmpty) {
          int hour = int.parse(parts[0]);
          // Se não tiver minutos, assume 0
          int minute = parts.length > 1 && parts[1].isNotEmpty 
              ? int.parse(parts[1]) 
              : 0;
          return [hour, minute];
        }
      }

      throw Exception('Formato de hora inválido: "$this". Formatos aceitos: HH:mm, XhY ou Xh');
    } catch (e) {
      if (e is FormatException || e.toString().contains('invalid')) {
        throw Exception('Formato de hora inválido: "$this". Formatos aceitos: HH:mm, XhY ou Xh');
      }
      rethrow;
    }
  }

  Uint8List? get bytesFromBase64 {
    try {
      if (isEmpty) return null;

      var base64Data = contains(',') ? split(',').last : this;

      // Remove espaços em branco e caracteres inválidos
      base64Data = base64Data.replaceAll(RegExp(r'\s+'), '');
      base64Data = base64Data.replaceAll(RegExp(r'[^A-Za-z0-9+/=]'), '');

      // Verifica se a string tem pelo menos alguns caracteres válidos
      if (base64Data.isEmpty || base64Data.length < 4) {
        return null;
      }

      // Adiciona padding se necessário
      final paddingNeeded = (4 - (base64Data.length % 4)) % 4;
      base64Data += '=' * paddingNeeded;

      return base64Decode(base64Data);
    } catch (e) {
      // Retorna null em vez de lançar exceção para evitar quebrar o app
      print('Erro ao decodificar Base64: $e');
      return null;
    }
  }
}
