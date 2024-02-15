import 'package:flutter/material.dart';

class BuildRating extends StatelessWidget {
  BuildRating(this.rating, {super.key});

  final double rating;
  final List<bool> _isFilled = [false, false, false, false, false];

  void _filledStarsBy(double rating) {
    for (int i = 0; i < rating; i++) {
      _isFilled[i] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    _filledStarsBy(rating);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _isFilled
          .map(
            (isFilled) => Icon(
              Icons.star_rate_sharp,
              color: isFilled ? Colors.yellow : Colors.grey,
            ),
          )
          .toList(),
    );
  }
}
