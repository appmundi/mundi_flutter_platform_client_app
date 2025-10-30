import 'package:mundi_flutter_platform_client_app/app/models/entrepreneur.dart';

extension RatingsExtension on List<Rating> {
  double get media {
    double rating = 0.0;
    for (var i = 0; i < (length); i++) {
      rating = rating + this[i].rating;
    }
    rating = isNotEmpty ? rating / (length) : 0.0;

    return rating;
  }
}