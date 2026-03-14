import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mundi_flutter_platform_client_app/app/core/storage/local_storage.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/profile/modules/notification/notification_page.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/profile/widgets/profile_tile.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/profile/widgets/setting_button.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/auth/i_auth_repository.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final LocalStorage localStorage = Modular.get<LocalStorage>();
  String name = "Nome do usuario";
  int userId = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initProfile();
  }

  Future<Map<String, dynamic>> initProfile() async {
    final token = await localStorage.read('accessToken');
    if (token == null || token.isEmpty) return {};
    try {
      final decodedToken = JwtDecoder.decode(token);
      setState(() {
        name = decodedToken['username']?.toString() ?? 'Usuario';
        userId = (decodedToken['id'] ?? decodedToken['sub'] ?? 0) is int
            ? (decodedToken['id'] ?? decodedToken['sub']) as int
            : int.tryParse((decodedToken['id'] ?? decodedToken['sub'] ?? '0').toString()) ?? 0;
      });
      return decodedToken;
    } catch (_) {
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Iniciou assim > ${name} + ${userId}");

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ProfileTile(name: name, userId: userId),
            Image.asset('assets/images/dark_logo.png', height: 25),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            SettingButton(
              label: 'Detalhes da Conta',
              onPressed: () {
                Modular.to.pushNamed(
                  '/profile/details',
                  arguments: {'name': name, 'userId': userId},
                );
              },
            ),
            const SizedBox(height: 10),
            SettingButton.filled(
              label: 'Notificações',
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return const NotificationPage();
                  },
                );
              },
            ),
            SizedBox(height: 10),
            SettingButton(
              label: 'Sair',
              onPressed: () {
                localStorage.clear();
                Modular.to.pushNamed('/splash');
              },
            ),
            const SizedBox(height: 20),
            _buildDeleteAccountButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteAccountButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () => _showDeleteAccountConfirmation(context),
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        side: BorderSide(
          color: Colors.red.withOpacity(0.6),
          width: .5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Excluir minha conta',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.red[700],
            ),
          ),
          Icon(
            Icons.delete_forever_outlined,
            size: 18,
            color: Colors.red[700],
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteAccountConfirmation(BuildContext pageContext) async {
    return showDialog<void>(
      context: pageContext,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
              SizedBox(width: 8),
              Text('Excluir Conta'),
            ],
          ),
          content: const Text(
            'Tem certeza que deseja excluir sua conta? Todos os seus dados serão removidos permanentemente. Esta ação não pode ser desfeita.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await _deleteAccount(pageContext);
              },
              child: Text(
                'Excluir conta',
                style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount(BuildContext context) async {
    try {
      await Modular.get<IAuthRepository>().deleteAccount(userId);
      await localStorage.clear();
      Modular.to.navigate('/splash/');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao excluir conta: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
