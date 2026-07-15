import 'package:flutter/material.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/colors_app.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/entrepreneur/modules/details/widgets/open_hours_tile.dart';

import '../../../../../../models/entrepreneur.dart';

class DetailsPage extends StatelessWidget {
  final String address;
  final String email;
  final String phone;
  final List<Operation> operation;
  const DetailsPage(
      {super.key,
      required this.address,
      required this.email,
      required this.phone,
      required this.operation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            "Endereço",
            style: context.textStyles.textMedium.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color.fromRGBO(33, 33, 33, 1),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            address,
            style: context.textStyles.textRegular.copyWith(
              color: context.colors.mutedText,
              fontSize: 10,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Funcionamento",
            style: context.textStyles.textMedium.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color.fromRGBO(33, 33, 33, 1),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Column(
            children: [
              for (int i = 0; i < operation.length; i++) ...[
                !operation[i].isActive
                    ? OpenHoursTile.closed(day: operation[i].day)
                    : OpenHoursTile(
                        startAt: operation[i].openinHours,
                        endAt: operation[i].closingTime,
                        day: operation[i].day,
                      ),
                if (i < operation.length - 1) const SizedBox(height: 8),
              ],
            ],
          ),
          Text(
            "Contato",
            style: context.textStyles.textMedium.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color.fromRGBO(33, 33, 33, 1),
            ),
          ),
          Text(
            phone,
            style: context.textStyles.textRegular.copyWith(
              color: context.colors.mutedText,
              fontSize: 10,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            email,
            style: context.textStyles.textRegular.copyWith(
              color: context.colors.mutedText,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
