import 'package:flutter/material.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/entrepeneur/entrepreneur_search_result.dart';

class LocationFilterBanner extends StatelessWidget {
  final AppliedGeoFilter appliedFilter;

  const LocationFilterBanner({super.key, required this.appliedFilter});

  @override
  Widget build(BuildContext context) {
    if (appliedFilter == AppliedGeoFilter.distance) {
      return const SizedBox.shrink();
    }

    final message = appliedFilter == AppliedGeoFilter.uf
        ? 'Usando o estado do seu cadastro. Ative a localização para resultados por distância.'
        : 'Ative a localização para ver profissionais que atendem sua região.';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4D6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE8B923), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 16, color: Color(0xFF8A6600)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: context.textStyles.textRegular.copyWith(
                fontSize: 12,
                color: const Color(0xFF8A6600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
