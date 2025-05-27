// lib/presentation/page_views/custom_page_view.dart
import 'package:flutter/material.dart';

class CustomPageView extends StatefulWidget {
  final List<Widget> pages;
  final PageController? pageController;
  final bool disableSwipe;
  // ignore: inference_failure_on_function_return_type
  final Function(int)? onPageChanged;

  const CustomPageView({
    super.key,
    required this.pages,
    this.pageController,
    this.disableSwipe = true,
    this.onPageChanged,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomPageViewState createState() => _CustomPageViewState();
}

class _CustomPageViewState extends State<CustomPageView> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = widget.pageController ?? PageController();
  }

  @override
  void dispose() {
    if (widget.pageController == null) {
      _pageController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return PageView(
      controller: _pageController,
      physics:
          widget.disableSwipe ? const NeverScrollableScrollPhysics() : null,
      onPageChanged: widget.onPageChanged,
      children: widget.pages,
    );
  }
}
