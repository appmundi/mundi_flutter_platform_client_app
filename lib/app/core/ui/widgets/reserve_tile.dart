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
  String endsAt = "";

  calculateDuration() {
    try {
      var [hour, minute] =
          widget.selectedTime.getHourAndMinuteFromAppTimeFormat;
      minute = minute + widget.modality.getDuration();
      if (minute < 60) {
        endsAt = "${hour}h${minute.toString().padLeft(2, "0")}";
      } else {
        endsAt = minute == 60 ? "${hour + 1}h" : "${hour + 1}h${minute - 60}";
      }
    } catch (e) {}
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    calculateDuration();
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: context.colors.secondary,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(
          15,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.modality.title,
                      style: context.textStyles.titleBold.copyWith(
                        fontSize: 10,
                        decoration: TextDecoration.none,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "${widget.modality.getDuration()} MIN",
                      style: context.textStyles.titleBold.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 8,
                        decoration: TextDecoration.none,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  width: 5,
                ),
                const SizedBox(
                  height: 15,
                  child: VerticalDivider(
                    color: Colors.black,
                    thickness: 1,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  widget.modality.getPrice(),
                  style: context.textStyles.titleBold.copyWith(
                    fontSize: 10,
                    decoration: TextDecoration.none,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: context.colors.secondary,
              borderRadius: BorderRadius.circular(
                14,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${DateFormat("d").format(widget.selectedDate)} ${DateFormat("MMM").format(widget.selectedDate)}",
                  style: context.textStyles.titleBold.copyWith(
                    color: Colors.white,
                    decoration: TextDecoration.none,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(
                  height: 15,
                  child: VerticalDivider(
                    color: Colors.white,
                    thickness: 1,
                  ),
                ),
                Text(
                  widget.selectedTime == ""
                      ? ""
                      : "${widget.selectedTime} - $endsAt",
                  style: context.textStyles.titleBold.copyWith(
                    color: Colors.white,
                    decoration: TextDecoration.none,
                    fontSize: 10,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }


}
