import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mundi_flutter_platform_client_app/app/core/helpers/environments.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';
import 'package:mundi_flutter_platform_client_app/app/models/entrepreneur.dart';

class EntrepreneurTile extends StatefulWidget {
  final Entrepreneur? entrepreneur;
  final double? stars;
  final bool isLoading;

  const EntrepreneurTile({
    super.key,
    this.entrepreneur,
    this.stars,
    this.isLoading = false,
  });

  // Factory constructor para estado de loading
  const EntrepreneurTile.loading({
    super.key,
  }) : entrepreneur = null,
        stars = null,
        isLoading = true;

  @override
  State<EntrepreneurTile> createState() => _EntrepreneurTileState();
}

class _EntrepreneurTileState extends State<EntrepreneurTile> {
  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return _buildShimmerTile();
    }

    if (widget.entrepreneur == null) {
      return const SizedBox.shrink();
    }

    return _buildEntrepreneurTile();
  }

  Widget _buildShimmerTile() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 275,
            height: 152,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            width: 180,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            width: 120,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntrepreneurTile() {
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
              '${Environments.get('BASE_URL')}/images/profile/${widget.entrepreneur!.id}',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/images/dark_logo.png');
              },
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          widget.entrepreneur!.name,
          style: context.textStyles.titleBold.copyWith(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          widget.entrepreneur!.fullAddress,
          style: context.textStyles.textRegular.copyWith(
            fontSize: 10,
            color: const Color(0xFFA4A4A4),
          ),
        ),
      ],
    );
  }
}