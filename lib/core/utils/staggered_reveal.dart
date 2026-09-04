import 'package:flutter/material.dart';

/// Wrap each item in a ListView.builder's itemBuilder with this to get a
/// cascading entrance — item 0 leads, each following item starts slightly
/// later, so the list reveals itself top-to-bottom instead of popping in
/// all at once.
///
/// Usage:
///   itemBuilder: (context, i) => StaggeredReveal(
///     index: i,
///     child: MyListItemWidget(...),
///   ),
///
/// Each item animates once (on first build) and then stays static — this
/// isn't a per-rebuild effect, so it's safe inside a BlocBuilder-driven
/// list without re-triggering on unrelated state changes.
class StaggeredReveal extends StatefulWidget {
  final int index;
  final Widget child;
  final Duration stagger;
  final Duration duration;
  final double riseFrom;

  const StaggeredReveal({
    super.key,
    required this.index,
    required this.child,
    this.stagger = const Duration(milliseconds: 45),
    this.duration = const Duration(milliseconds: 380),
    this.riseFrom = 18,
  });

  @override
  State<StaggeredReveal> createState() => _StaggeredRevealState();
}

class _StaggeredRevealState extends State<StaggeredReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _rise;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _rise = Tween<double>(begin: widget.riseFrom, end: 0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    // Cap the stagger so a long list doesn't leave item #40 waiting
    // several seconds to appear — everything settles within ~600ms.
    final delay = Duration(
      milliseconds: (widget.stagger.inMilliseconds * widget.index).clamp(0, 600),
    );
    Future.delayed(delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        return Opacity(
          opacity: _fade.value,
          child: Transform.translate(
            offset: Offset(0, _rise.value),
            child: child,
          ),
        );
      },
    );
  }
}