import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/colors_app.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/styles/text_styles.dart';
import 'package:mundi_flutter_platform_client_app/app/core/ui/widgets/app_button.dart';

class ScheduleFeedbackModal extends StatefulWidget {
  const ScheduleFeedbackModal({
    super.key,
  });

  @override
  State<ScheduleFeedbackModal> createState() => _ScheduleFeedbackModalState();
}

class _ScheduleFeedbackModalState extends State<ScheduleFeedbackModal> {
  int _rating = 0;
  final TextEditingController _commentController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 35,
          vertical: 25,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Agendamento',
                    style: context.textStyles.textMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontSize: 25,
                    ),
                  ),
                  Image.asset('assets/images/dark_logo.png', height: 25),
                ],
              ),
              const SizedBox(height: 17),
              Text(
                'Obrigado por realizar\nesse serviço conosco',
                style: context.textStyles.textMedium.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Para melhorar a sua experiência e a de outros clientes de a nota ao fornecedor de serviços:',
                    style: context.textStyles.textLight.copyWith(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  RatingBar.builder(
                    initialRating: _rating.toDouble(),
                    minRating: 1,
                    maxRating: 5,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    ignoreGestures: false,
                    itemCount: 5,
                    itemSize: 40,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                    itemBuilder: (context, index) {
                      return ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(stops: const [
                            .3,
                            1
                          ], colors: [
                            const Color.fromRGBO(144, 240, 153, 1),
                            context.colors.decorationPrimary,
                          ]).createShader(bounds);
                        },
                        child: Icon(
                          _rating > index
                              ? Icons.star
                              : Icons.star_border_outlined,
                          color: Colors.white,
                        ),
                      );
                    },
                    updateOnDrag: true,
                    onRatingUpdate: (rating) {
                      print(rating);
                      setState(() {
                        _rating = rating.toInt();
                      });
                    },
                  ),
                  const SizedBox(height: 13),
                  CommentField(
                    commentController: _commentController,
                  ),
                  const SizedBox(height: 13),
                  AppButton(
                    text: 'Enviar avaliação',
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      Navigator.of(context).pop(
                        [
                          _commentController.text,
                          _rating,
                        ],
                      );
                    },
                    loading: isLoading,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CommentField extends StatelessWidget {
  final TextEditingController commentController;

  const CommentField({
    super.key,
    required this.commentController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFf0f0f0), Colors.white],
        ),
        border: Border.all(
          color: const Color(0xFFd3d3d3),
          width: 1,
        ),
      ),
      child: TextField(
        controller: commentController,
        maxLines: 8,
        textAlignVertical: TextAlignVertical.top,
        style: context.textStyles.textLight.copyWith(
          fontSize: 10,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          hintText: 'Conte-nos mais um pouco de sua experiência...',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          hintStyle: context.textStyles.textLight.copyWith(
            fontSize: 10,
            color: Colors.black.withValues(alpha: .4),
          ),
        ),
      ),
    );
  }
}
