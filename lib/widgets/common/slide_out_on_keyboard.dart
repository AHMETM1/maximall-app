import 'package:flutter/material.dart';

class SlideOutOnKeyboard extends StatefulWidget {
  const SlideOutOnKeyboard({
    super.key,
    required this.child,
    this.enable = true,
    this.duration = const Duration(milliseconds: 100),
  });

  final Widget child;
  final bool enable;
  final Duration duration;

  @override
  State<SlideOutOnKeyboard> createState() => _SlideOutOnKeyboardState();
}

class _SlideOutOnKeyboardState extends State<SlideOutOnKeyboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 1),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  void _onFocusChange() {
    if (widget.enable == false) {
      return;
    }

    final viewInsets = EdgeInsets.fromViewPadding(
        View.of(context).viewInsets, View.of(context).devicePixelRatio);
    final isKeyboardVisible = viewInsets.bottom > 0;

    if (isKeyboardVisible != _isKeyboardVisible) {
      if (isKeyboardVisible) {
        _controller.forward().then((_) {
          setState(() {
            _isKeyboardVisible = true;
          });
        });
      } else {
        setState(() {
          _isKeyboardVisible = false;
        });
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onFocusChange();
    });

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isKeyboardVisible)
          const SizedBox.shrink()
        else
          SlideTransition(
            position: _offsetAnimation,
            child: widget.child,
          ),
      ],
    );
  }
}
