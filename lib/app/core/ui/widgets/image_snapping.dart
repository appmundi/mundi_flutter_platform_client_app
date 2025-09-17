import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mundi_flutter_platform_client_app/app/core/helpers/environments.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/colors_app.dart';

class ImageSnapping extends StatefulWidget {
  final bool favorite;
  final List<int> fetchedImages;
  const ImageSnapping({super.key, required this.fetchedImages})
    : favorite = false;

  const ImageSnapping.favorite({super.key, required this.fetchedImages})
    : favorite = true;

  @override
  State<ImageSnapping> createState() => _ImageSnappingState();
}

class _ImageSnappingState extends State<ImageSnapping> {
  final imagesViewCtrl = PageController();
  int selectedImg = 0;
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: .30.sh,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children: [
          PageView.builder(
            controller: imagesViewCtrl,
            onPageChanged: (value) {
              setState(() {
                selectedImg = value;
              });
            },
            itemCount:
                widget.fetchedImages.isEmpty ? 1 : widget.fetchedImages.length,
            itemBuilder: (context, index) {
              if (widget.fetchedImages.isEmpty) {
                return Image.asset('assets/images/dark_logo.png');
              }
              final imageID = widget.fetchedImages[index];
              final imageUrl =
                  "${Environments.get('BASE_URL')}/images/$imageID";
              return Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/images/dark_logo.png');
                },
              );
            },
          ),
          Align(
            alignment: Alignment.topRight,
            child: Visibility(
              visible: widget.favorite,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                  },
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_outline,
                    size: 30,
                    color: isFavorite ? context.colors.secondary : Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 4,
              margin: const EdgeInsets.only(bottom: 10),
              child: ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 5);
                },
                itemCount:
                    widget.fetchedImages.isEmpty
                        ? 1
                        : widget.fetchedImages.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    width: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(
                            0,
                            3,
                          ), // changes position of shadow
                        ),
                      ],
                      color:
                          index == selectedImg
                              ? Colors.white
                              : Colors.transparent,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
