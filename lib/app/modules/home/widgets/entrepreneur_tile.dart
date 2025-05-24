import 'package:flutter/material.dart';
import 'package:mundi_flutter_platform_client_app/app/core/helpers/environments.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';
import 'package:mundi_flutter_platform_client_app/app/models/entrepreneur.dart';

class EntrepreneurTile extends StatefulWidget {
  final Entrepreneur entrepreneur;
  final double stars;

  const EntrepreneurTile({
    super.key,
    required this.entrepreneur,
    required this.stars,
  });

  @override
  State<EntrepreneurTile> createState() => _EntrepreneurTileState();
}

class _EntrepreneurTileState extends State<EntrepreneurTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 275,
          height: 152,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(
              '${Environments.get('BASE_URL')}/images/profile/${widget.entrepreneur.id}',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/images/dark_logo.png');
              },
            ),
          ),
        ),

        const SizedBox(height: 5),
        Text(
          widget.entrepreneur.name,
          style: context.textStyles.titleBold.copyWith(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          widget.entrepreneur.fullAddress,
          style: context.textStyles.textRegular.copyWith(
            fontSize: 10,
            color: const Color(0xFFA4A4A4),
          ),
        ),
      ],
    );
  }
}
