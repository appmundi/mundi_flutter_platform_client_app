import 'dart:convert';
import 'dart:typed_data';

extension StringExtension on String {
  List<int> get getHourAndMinuteFromAppTimeFormat {
    // Divide a string usando ":" como delimitador
    final parts = split(":");

    // Verifica se há pelo menos duas partes (horas e minutos)
    if (parts.length != 2) {
      throw FormatException("Formato de hora inválido. O formato esperado é HH:mm");
    }

    // Converte as partes para números inteiros
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    return [hour, minute];
  }

  Uint8List get bytesFromBase64 {
    try {
      if (isEmpty) throw FormatException('String vazia');

      var base64Data = contains(',') ? split(',').last : this;

      base64Data = base64Data.replaceAll(RegExp(r'\s+'), '');

      final paddingNeeded = (4 - (base64Data.length % 4)) % 4;
      base64Data += '=' * paddingNeeded;

      return base64Decode(base64Data);
    } on FormatException catch (e) {
      throw FormatException('Falha ao decodificar Base64: ${e.message}');
    }
  }
}
