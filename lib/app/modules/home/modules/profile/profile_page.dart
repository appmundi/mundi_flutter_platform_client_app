import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mundi_flutter_platform_client_app/app/core/storage/local_storage.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/profile/modules/notification/notification_page.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/profile/widgets/profile_tile.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/profile/widgets/setting_button.dart';

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
    String token = await localStorage.read('accessToken');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    print("Aq ${decodedToken}");

    setState(() {
      name = decodedToken['username'];
      userId = decodedToken['id'];
    });
    return decodedToken;
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
          ],
        ),
      ),
    );
  }
}
