import 'package:flutter/material.dart';

class RatingStarsWidget extends StatefulWidget {
  final double rating;
  final int starCount;
  final Color color;
  final Color backgroundColor;
  final double size;
  final ValueChanged<double>? onRatingChanged;

  const RatingStarsWidget({
    super.key,
    required this.rating,
    this.starCount = 5,
    this.color = Colors.amber,
    this.backgroundColor = Colors.grey,
    this.size = 24.0,
    this.onRatingChanged,
  });

  @override
  State<RatingStarsWidget> createState() => _RatingStarsWidgetState();
}

class _RatingStarsWidgetState extends State<RatingStarsWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.starCount, (index) {
        return GestureDetector(
          onTap: widget.onRatingChanged != null
              ? () => widget.onRatingChanged!(index + 1.0)
              : null,
          child: Icon(
            index < widget.rating.floor()
                ? Icons.star
                : index < widget.rating
                ? Icons.star_half
                : Icons.star_border,
            color: index < widget.rating
                ? widget.color
                : widget.backgroundColor,
            size: widget.size,
          ),
        );
      }),
    );
  }
}
