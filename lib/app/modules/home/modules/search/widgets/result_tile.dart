import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/extension/ratings_extension.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/colors_app.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/widgets/image_snapping.dart';

import '../../../../../models/entrepreneur.dart';
import 'package:http/http.dart' as http;

class ResultTile extends StatefulWidget {
  final Entrepreneur? entrepreneur;
  final bool isLoading;

  const ResultTile({
    super.key,
    this.entrepreneur,
    this.isLoading = false,
  });

  // Factory constructor para estado de loading
  const ResultTile.loading({
    super.key,
  }) : entrepreneur = null,
        isLoading = true;

  @override
  State<ResultTile> createState() => _ResultTileState();
}

class _ResultTileState extends State<ResultTile> {
  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return _buildShimmerTile();
    }

    if (widget.entrepreneur == null) {
      return const SizedBox.shrink();
    }

    return _buildResultTile();
  }

  Widget _buildShimmerTile() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Simulando o ImageSnapping
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 10),

          // Simulando o nome
          Container(
            width: 150,
            height: 14,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 10),

          // Simulando a row com endereço e estrelas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Endereço
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 4),
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
              ),
              // Estrelas
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    width: 20,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Simulando a row inferior com distância e botão
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 100,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                width: 100,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultTile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImageSnapping.favorite(
          fetchedImages: widget.entrepreneur!.imagesID ?? [],
        ),
        const SizedBox(height: 10),
        Text(
          widget.entrepreneur!.displayName,
          style: context.textStyles.textMedium.copyWith(
            fontSize: 14,
            color: const Color.fromRGBO(33, 33, 33, 1),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                widget.entrepreneur!.fullAddress,
                softWrap: true,
                maxLines: 8,
                textAlign: TextAlign.left,
                style: context.textStyles.textRegular.copyWith(
                  fontSize: 10,
                  color: const Color.fromRGBO(164, 164, 164, 1),
                  height: 1.35,
                ),
              ),
            ),
            Row(
              children: [
                Icon(
                  Icons.star,
                  size: 8,
                  color: context.colors.decorationPrimary,
                ),
                const SizedBox(width: 5),
                Text(
                  '${widget.entrepreneur?.ratings?.media ?? 0}',
                  style: context.textStyles.textMedium.copyWith(
                    color: context.colors.decorationPrimary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${widget.entrepreneur!.distance?.toStringAsFixed(2)} km",
              style: context.textStyles.textRegular.copyWith(
                fontSize: 14,
                color: const Color.fromRGBO(113, 113, 113, 1),
              ),
            ),
            GestureDetector(
              onTap: () => Modular.to.pushNamed(
                '/home/entrepreneur/',
                arguments: widget.entrepreneur!.id,
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromRGBO(221, 221, 221, 1),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  "Agende Aqui",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromRGBO(33, 33, 33, 1),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}