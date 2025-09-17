import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/widgets/image_snapping.dart';

import '../../../../../../models/work.dart';

class PortfolioPage extends StatefulWidget {
  final List<int> images;
  final List<Work> services;
  const PortfolioPage({
    super.key,
    required this.services,
    required this.images
  });

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Expanded(child: ImageSnapping(fetchedImages: widget.images,)),
      ],
    );
  }
}
