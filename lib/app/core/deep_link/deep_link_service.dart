import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mundi_flutter_platform_client_app/app/app_module.dart';

/// Gerencia deep links com scheme `mundi://` e Android App Links `https://`.
///
/// Formatos suportados:
///   mundi://entrepreneur?id=123               →  abre a tela do entrepreneur
///   https://mundiapp.com.br/entrepreneur?id=123 →  idem (Android App Links)
class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._();
  factory DeepLinkService() => _instance;
  DeepLinkService._();

  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  /// Inicializa o serviço. Deve ser chamado após o app estar montado.
  Future<void> init() async {
    // Link que abriu o app quando ele estava fechado (cold start)
    final initialLink = await _appLinks.getInitialLink();
    if (initialLink != null) {
      _handleLink(initialLink);
    }

    // Links recebidos com o app em foreground/background
    _sub = _appLinks.uriLinkStream.listen(_handleLink);
  }

  void _handleLink(Uri uri) {
    final id = int.tryParse(uri.queryParameters['id'] ?? '');

    if (id == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (uri.scheme == 'mundi' && uri.host == 'entrepreneur') {
          Modular.to.pushNamed('/home/entrepreneur/', arguments: id);
        }

        if (uri.scheme == 'https' &&
            uri.host == 'mundiapp.com.br' &&
            uri.path.startsWith('/entrepreneur')) {
          Modular.to.pushNamed('/home/entrepreneur/', arguments: id);
        }
      });
    });
  }

  void dispose() {
    _sub?.cancel();
  }
}
