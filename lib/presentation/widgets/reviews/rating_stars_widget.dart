import 'package:flutter/material.dart';

class RatingStarsWidget extends StatelessWidget {
  final double rating;
  final int maxStars;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool isInteractive;
  final ValueChanged<double>? onRatingChanged;
  final bool showHalfStars;
  final EdgeInsetsGeometry? padding;

  const RatingStarsWidget({
    super.key,
    required this.rating,
    this.maxStars = 5,
    this.size = 24.0,
    this.activeColor,
    this.inactiveColor,
    this.isInteractive = false,
    this.onRatingChanged,
    this.showHalfStars = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveActiveColor = activeColor ?? Colors.amber;
    final effectiveInactiveColor = inactiveColor ?? Colors.grey[300];

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(maxStars, (index) {
          return GestureDetector(
            onTap: isInteractive && onRatingChanged != null
                ? () => onRatingChanged!(index + 1.0)
                : null,
            child: Icon(
              _getStarIcon(index + 1),
              size: size,
              color: _getStarColor(
                  index + 1, effectiveActiveColor, effectiveInactiveColor),
            ),
          );
        }),
      ),
    );
  }

  IconData _getStarIcon(int starNumber) {
    if (rating >= starNumber) {
      return Icons.star;
    } else if (showHalfStars && rating >= starNumber - 0.5) {
      return Icons.star_half;
    } else {
      return Icons.star_outline;
    }
  }

  Color _getStarColor(
      int starNumber, Color activeColor, Color? inactiveColor) {
    if (rating >= starNumber) {
      return activeColor;
    } else if (showHalfStars && rating >= starNumber - 0.5) {
      return activeColor;
    } else {
      return inactiveColor ?? Colors.grey[300]!;
    }
  }
}

class InteractiveRatingStars extends StatefulWidget {
  final double initialRating;
  final int maxStars;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;
  final ValueChanged<double>? onRatingChanged;
  final String? label;
  final bool allowHalfStars;

  const InteractiveRatingStars({
    super.key,
    this.initialRating = 0.0,
    this.maxStars = 5,
    this.size = 32.0,
    this.activeColor,
    this.inactiveColor,
    this.onRatingChanged,
    this.label,
    this.allowHalfStars = false,
  });

  @override
  State<InteractiveRatingStars> createState() => _InteractiveRatingStarsState();
}

class _InteractiveRatingStarsState extends State<InteractiveRatingStars> {
  late double currentRating;

  @override
  void initState() {
    super.initState();
    currentRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveActiveColor = widget.activeColor ?? Colors.amber;
    final effectiveInactiveColor = widget.inactiveColor ?? Colors.grey[300];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(widget.maxStars, (index) {
            return GestureDetector(
              onTap: () {
                final newRating = (index + 1).toDouble();
                setState(() {
                  currentRating = newRating;
                });
                widget.onRatingChanged?.call(newRating);
              },
              onPanUpdate: widget.allowHalfStars
                  ? (details) {
                      final RenderBox box =
                          context.findRenderObject() as RenderBox;
                      final localPosition =
                          box.globalToLocal(details.globalPosition);
                      final starWidth = widget.size + 4; // Include padding
                      final starIndex = (localPosition.dx / starWidth).floor();
                      final starPosition =
                          (localPosition.dx % starWidth) / starWidth;

                      if (starIndex >= 0 && starIndex < widget.maxStars) {
                        final newRating =
                            starIndex + (starPosition > 0.5 ? 1.0 : 0.5);
                        setState(() {
                          currentRating = newRating.clamp(
                              0.5, widget.maxStars.toDouble());
                        });
                        widget.onRatingChanged?.call(currentRating);
                      }
                    }
                  : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Icon(
                  _getStarIcon(index + 1),
                  size: widget.size,
                  color: _getStarColor(index + 1, effectiveActiveColor,
                      effectiveInactiveColor),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Text(
          _getRatingText(),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  IconData _getStarIcon(int starNumber) {
    if (currentRating >= starNumber) {
      return Icons.star;
    } else if (widget.allowHalfStars && currentRating >= starNumber - 0.5) {
      return Icons.star_half;
    } else {
      return Icons.star_outline;
    }
  }

  Color _getStarColor(
      int starNumber, Color activeColor, Color? inactiveColor) {
    if (currentRating >= starNumber) {
      return activeColor;
    } else if (widget.allowHalfStars && currentRating >= starNumber - 0.5) {
      return activeColor;
    } else {
      return inactiveColor ?? Colors.grey[300]!;
    }
  }

  String _getRatingText() {
    if (currentRating == 0) return 'Sin calificación';

    switch (currentRating.round()) {
      case 1:
        return 'Malo (${currentRating.toStringAsFixed(1)}/5)';
      case 2:
        return 'Regular (${currentRating.toStringAsFixed(1)}/5)';
      case 3:
        return 'Bueno (${currentRating.toStringAsFixed(1)}/5)';
      case 4:
        return 'Muy bueno (${currentRating.toStringAsFixed(1)}/5)';
      case 5:
        return 'Excelente (${currentRating.toStringAsFixed(1)}/5)';
      default:
        return '${currentRating.toStringAsFixed(1)}/5';
    }
  }
}

class RatingDisplayWidget extends StatelessWidget {
  final double rating;
  final int totalReviews;
  final bool showNumber;
  final bool showReviewCount;
  final double size;
  final TextStyle? textStyle;

  const RatingDisplayWidget({
    super.key,
    required this.rating,
    this.totalReviews = 0,
    this.showNumber = true,
    this.showReviewCount = true,
    this.size = 16.0,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveTextStyle = textStyle ?? theme.textTheme.bodyMedium;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RatingStarsWidget(
          rating: rating,
          size: size,
          showHalfStars: true,
        ),
        if (showNumber || showReviewCount) ...[
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showNumber)
                Text(
                  rating.toStringAsFixed(1),
                  style: effectiveTextStyle?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              if (showReviewCount && totalReviews > 0)
                Text(
                  '($totalReviews ${totalReviews == 1 ? 'reseña' : 'reseñas'})',
                  style: effectiveTextStyle?.copyWith(
                    fontSize: (effectiveTextStyle.fontSize ?? 14) * 0.85,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
