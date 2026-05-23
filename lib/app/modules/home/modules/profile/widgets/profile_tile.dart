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
    final hasValidUserId = userId > 0;
    final imageUrl = hasValidUserId
        ? "${Environments.get('BASE_URL')}/images/profile/user/$userId?t=${DateTime.now().millisecondsSinceEpoch}"
        : null;

    return Row(
      children: [
        CircleAvatar(
          radius: 22.5,
          backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
          onBackgroundImageError: imageUrl != null ? (_, __) {} : null,
          child: imageUrl == null
              ? Text(
                  name.isNotEmpty ? name[0].toUpperCase() : "?",
                  style: const TextStyle(fontSize: 20),
                )
              : null,
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
