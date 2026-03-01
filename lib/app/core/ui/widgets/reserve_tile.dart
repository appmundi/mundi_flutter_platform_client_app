import 'package:flutter/material.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/extension/string_extension.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/colors_app.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';
import 'package:mundi_flutter_platform_client_app/app/models/modality.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class ReserveTile extends StatefulWidget {
  final Modality modality;
  final String selectedTime;
  final DateTime selectedDate;
  const ReserveTile({
    super.key,
    required this.modality,
    required this.selectedDate,
    required this.selectedTime,
  });

  @override
  State<ReserveTile> createState() => _ReserveTileState();
}

class _ReserveTileState extends State<ReserveTile> {
  String calculateDuration() {
    try {
      if (widget.selectedTime.isEmpty) {
        return "";
      }

      var [hour, minute] =
          widget.selectedTime.getHourAndMinuteFromAppTimeFormat;
      final totalMinutes =
          (hour * 60) + minute + widget.modality.getDuration();
      final endHour = (totalMinutes ~/ 60) % 24;
      final endMinute = totalMinutes % 60;

      return "${endHour}h${endMinute.toString().padLeft(2, "0")}";
    } catch (e, s) {
      print('Erro ao calcular duração: $e');
      print(s);
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final endsAt = calculateDuration();

    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth >= 360 && screenWidth < 400;

    // Tamanhos responsivos
    final titleFontSize = isSmallScreen ? 9.0 : 10.0;
    final subtitleFontSize = isSmallScreen ? 7.0 : 8.0;
    final dateFontSize = isSmallScreen ? 9.0 : 10.0;
    final horizontalPadding = isSmallScreen ? 10.0 : 15.0;
    final containerPadding = isSmallScreen ? 15.0 : (isMediumScreen ? 18.0 : 20.0);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: context.colors.secondary,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth;
          final useCompactLayout = availableWidth < 320;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: useCompactLayout ? 1 : 2,
                child: Padding(
                  padding: EdgeInsets.only(left: horizontalPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.modality.title,
                              style: context.textStyles.titleBold.copyWith(
                                fontSize: titleFontSize,
                                decoration: TextDecoration.none,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "${widget.modality.getDuration()} MIN",
                              style: context.textStyles.titleBold.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: subtitleFontSize,
                                decoration: TextDecoration.none,
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 3 : 5),
                      SizedBox(
                        height: 15,
                        child: VerticalDivider(
                          color: Colors.black,
                          thickness: 1,
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 3 : 5),
                      Flexible(
                        child: Text(
                          widget.modality.getPrice(),
                          style: context.textStyles.titleBold.copyWith(
                            fontSize: titleFontSize,
                            decoration: TextDecoration.none,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: containerPadding,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: context.colors.secondary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${DateFormat("d").format(widget.selectedDate)} ${DateFormat("MMM").format(widget.selectedDate)}",
                      style: context.textStyles.titleBold.copyWith(
                        color: Colors.white,
                        decoration: TextDecoration.none,
                        fontSize: dateFontSize,
                      ),
                    ),
                    if (widget.selectedTime.isNotEmpty) ...[
                      SizedBox(
                        height: 15,
                        child: VerticalDivider(
                          color: Colors.white,
                          thickness: 1,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          "${widget.selectedTime} - $endsAt",
                          style: context.textStyles.titleBold.copyWith(
                            color: Colors.white,
                            decoration: TextDecoration.none,
                            fontSize: dateFontSize,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}