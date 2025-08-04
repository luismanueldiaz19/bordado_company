import 'package:flutter/material.dart';
import '/src/util/commo_pallete.dart';

class StarRating extends StatelessWidget {
  const StarRating({super.key, required this.percent});
  final int percent;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Icon(index < percent ? Icons.star : Icons.star_border,
            color: index < percent ? Colors.yellow[800] : ktejidogrey);
      }),
    );
  }
}
