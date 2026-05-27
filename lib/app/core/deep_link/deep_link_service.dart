import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

/// Gerencia deep links com scheme `mundi://` e Android App Links `https://`.
///
/// Formatos suportados:
///   mundi://entrepreneur?id=123                  →  abre a tela do entrepreneur
///   https://mundiapp.com.br/entrepreneur?id=123  →  idem (Android App Links)
///
/// Cold start: o link é guardado em [_pendingLink] e só é consumido após a
/// splash sinalizar [notifyAppReady], garantindo que `/home/` esteja na pilha
/// antes de empilhar `/home/entrepreneur/` (necessário para o botão voltar).
class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._();
  factory DeepLinkService() => _instance;
  DeepLinkService._();

  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  Future<Uri?>? _initialLinkFuture;
  Uri? _pendingLink;
  bool _isAppReady = false;

  /// Captura o link inicial e começa a ouvir links recebidos em runtime.
  /// Deve ser chamado o mais cedo possível (antes da splash navegar).
  Future<void> init() async {
    _initialLinkFuture = _appLinks.getInitialLink();

    _sub = _appLinks.uriLinkStream.listen((uri) {
      if (_isAppReady) {
        _handleLink(uri);
      } else {
        _pendingLink = uri;
      }
    });
  }

  /// Sinaliza que a tela inicial (`/home/`) já está carregada e que links
  /// pendentes podem ser empilhados em cima dela. Chamado pela splash após
  /// o `Modular.to.navigate('/home/')`.
  Future<void> notifyAppReady() async {
    if (_isAppReady) return;
    _isAppReady = true;

    final initialLink = await _initialLinkFuture;
    final link = _pendingLink ?? initialLink;
    if (link != null) {
      _pendingLink = null;
      _handleLink(link);
    }
  }

  Future<void> _handleLink(Uri uri) async {
    final id = int.tryParse(uri.queryParameters['id'] ?? '');
    if (id == null) return;

    final isMundiScheme =
        uri.scheme == 'mundi' &&
        (uri.host == 'entrepreneur' || uri.path == '/entrepreneur');

    final isHttpsLink =
        uri.scheme == 'https' &&
        uri.host == 'mundiapp.com.br' &&
        uri.path.startsWith('/entrepreneur');

    if (!isMundiScheme && !isHttpsLink) return;

    await Future.delayed(const Duration(milliseconds: 500));

    Modular.to.pushNamed('/home/entrepreneur/', arguments: id);
  }

  void dispose() {
    _sub?.cancel();
    _sub = null;
    _isAppReady = false;
    _pendingLink = null;
    _initialLinkFuture = null;
  }
}
