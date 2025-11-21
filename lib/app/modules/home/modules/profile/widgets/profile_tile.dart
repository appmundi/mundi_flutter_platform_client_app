import 'package:flutter/material.dart';
import 'package:mundi_flutter_platform_client_app/app/core/helpers/environments.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';

class ProfileTile extends StatelessWidget {
  final String name;
  final int userId;

  const ProfileTile({
    required this.name,
    required this.userId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        "${Environments.get('BASE_URL')}/images/profile/user/$userId?t=${DateTime.now().millisecondsSinceEpoch}";

    return Row(
      children: [
        CircleAvatar(
          radius: 22.5,
          backgroundImage: NetworkImage(imageUrl),
          onBackgroundImageError: (_, __) {
            // Se der erro ao carregar, mantém avatar padrão
          },
        ),
        const SizedBox(width: 10),
        Text(
          name.isNotEmpty ? name : "usuario",
          style: context.textStyles.titleBold.copyWith(fontSize: 14),
        ),
      ],
    );
  }
}
