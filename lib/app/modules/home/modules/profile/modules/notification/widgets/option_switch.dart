import 'package:flutter/material.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/colors_app.dart';

class OptionSwitch extends StatefulWidget {
  final String label;
  const OptionSwitch({
    super.key,
    required this.label,
  });

  @override
  State<OptionSwitch> createState() => _OptionSwitchState();
}

class _OptionSwitchState extends State<OptionSwitch> {
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black.withValues(alpha: .7),
          width: .2,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.label),
          Switch(
            value: isActive,
            activeColor: context.colors.secondary,
            onChanged: (value) {
              setState(() {
                isActive = !isActive;
              });
            },
          )
        ],
      ),
    );
  }
}
