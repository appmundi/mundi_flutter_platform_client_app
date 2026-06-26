import 'package:flutter/material.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/colors_app.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';

class OpenHoursTile extends StatelessWidget {
  final String day;
  final String? startAt;
  final String? endAt;

  const OpenHoursTile({
    super.key,
    required this.day,
    required this.startAt,
    required this.endAt,
  });

  const OpenHoursTile.closed({
    super.key,
    required this.day,
  })  : startAt = null,
        endAt = null;

  bool get _isOpen => startAt != null;

  @override
  Widget build(BuildContext context) {
    final barColor = _isOpen ? context.colors.secondary : Colors.red;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 4,
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  day,
                  style: context.textStyles.textRegular.copyWith(
                    color: context.colors.textPrimary,
                    fontSize: 13,
                  ),
                ),
                _isOpen
                    ? Text(
                        '${startAt}h–${endAt}h',
                        style: context.textStyles.textRegular.copyWith(
                          fontSize: 12,
                          color: context.colors.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: context.colors.cardBackground,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Fechado',
                          style: context.textStyles.textRegular.copyWith(
                            fontSize: 12,
                            color: context.colors.mutedText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
