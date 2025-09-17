import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/colors_app.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import '../../../../../../models/entrepreneur.dart';

class RatingPage extends StatefulWidget {
  final List<Rating>? ratings;
  final double? stars;
  const RatingPage({
    super.key,
    this.ratings = const [],
    this.stars = 0.0
  });

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {

  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: context.colors.secondary,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.stars?.toStringAsFixed(2) ?? '0.0',
                          style: context.textStyles.textMedium.copyWith(
                            fontSize: 28,
                            color: const Color.fromRGBO(62, 62, 62, 1),
                          ),
                        )
                      ],
                    ),
                    Text(
                      "${widget.ratings?.length ?? 0} Avaliações",
                      style: context.textStyles.textRegular.copyWith(
                        fontSize: 16,
                        color: const Color.fromRGBO(62, 62, 62, 1),
                      ),
                    )
                  ],
                ),
                RatingBar.builder(
                  initialRating: widget.stars ?? 0.0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  ignoreGestures: true,
                  itemCount: 5,
                  itemSize: 22,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: context.colors.secondary,
                  ),
                  onRatingUpdate: (rating) {},
                ),
              ],
            ),
            ListView.separated(
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 30,
                );
              },
              itemCount: widget.ratings?.length ?? 0,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final rating = widget.ratings?[index];
                return Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          child: Icon(Icons.person),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              rating?.name ?? '',
                              style: context.textStyles.titleBold.copyWith(
                                color: const Color.fromRGBO(62, 62, 62, 1),
                                fontSize: 14,
                              ),
                            ),
                            RatingBar.builder(
                              initialRating: rating?.rating ?? 0,
                              minRating: 1,
                              maxRating: 5,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              ignoreGestures: true,
                              itemCount: 5,
                              itemSize: 13,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 0.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: context.colors.secondary,
                              ),
                              onRatingUpdate: (rating) {},
                            ),
                            Text(
                              DateFormat('yMMMM').format(DateTime.now()),
                              style: context.textStyles.textRegular.copyWith(
                                color: const Color.fromRGBO(184, 184, 184, 1),
                                fontSize: 14,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        rating?.comment ?? '',
                        textAlign: TextAlign.justify,
                        style: context.textStyles.textRegular.copyWith(
                          color: const Color.fromRGBO(62, 62, 62, 1),
                          fontSize: 13,
                          height: 1.3,
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
