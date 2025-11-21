import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/helpers/Utils.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';
import 'package:mundi_flutter_platform_client_app/app/models/entrepreneur.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/widgets/entrepreneur_tile.dart';

class HorizontalEntrepreneursList extends StatefulWidget {
  final List<Entrepreneur> entrepeneurs;
  final String title;
  final bool isLoading;
  const HorizontalEntrepreneursList({
    super.key,
    required this.title,
    required this.entrepeneurs,
    this.isLoading = false,
  });

  @override
  State<HorizontalEntrepreneursList> createState() => _HorizontalEntrepreneursListState();
}

class _HorizontalEntrepreneursListState extends State<HorizontalEntrepreneursList> {


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: context.textStyles.titleBold.copyWith(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 280,
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 10,
                width: 20,
              );
            },
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: widget.entrepeneurs.length,
            itemBuilder: (context, index) {
              if(widget.isLoading) {
                return const EntrepreneurTile.loading();
              }

              final entrepreneur = widget.entrepeneurs[index];
              return InkWell(
                onTap: () {
                  Modular.to.pushNamed(
                    '/home/entrepreneur/',
                    arguments: entrepreneur.id,
                  );
                },
                child: EntrepreneurTile(
                  stars: calculeStars(entrepreneur.ratings ?? []),
                  entrepreneur: entrepreneur,
                ),
              );
            },
          ),
        )
      ],
    );
  }
}



