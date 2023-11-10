import 'package:flutter_riverpod/flutter_riverpod.dart';

enum RatingStatus { animatedFinised, animating, ready }

class Rating {
  const Rating({
    required this.rating,
    required this.status,
  });
  final int rating;
  final RatingStatus status;

  void startAnimation() {}
}

final ratingProvider = StateProvider<int>((ref) {
  return 0;
});
