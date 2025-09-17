import 'package:flutter/material.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/extension/size_screen_extension.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/colors_app.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';

class AvailableTimesInput extends StatelessWidget {
  final List<String> availablesTimes;
  final void Function(String time) onSelectTime;
  final String selectedTime;
  const AvailableTimesInput({
    super.key,
    required this.availablesTimes,
    required this.onSelectTime,
    required this.selectedTime,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 39,
      width: .8.sw,
      child: Visibility(
        visible: availablesTimes.isNotEmpty,
        replacement: Center(
          child: Text('Sem horários disponíveis para esta data', style: context.textStyles.textMedium.copyWith(
            fontSize: 14,
          ),
          textAlign: TextAlign.center,),
        ),
        child: ListView.separated(
          separatorBuilder: (context, index) {
            return const SizedBox(
              width: 10,
            );
          },
          itemCount: availablesTimes.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final time = availablesTimes[index];
            return InkWell(
              onTap: () {
                onSelectTime(time);
              },
              child: Container(
                width: .3.sw,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selectedTime == time
                      ? context.colors.secondary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(
                    15,
                  ),
                ),
                child: Text(
                  time,
                  style: context.textStyles.titleBold.copyWith(
                    color: selectedTime == time
                        ? Colors.white
                        : context.colors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.33,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
