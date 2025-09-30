import 'dart:math';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';

class CartButtonWithQuantity extends StatefulWidget {
  const CartButtonWithQuantity({
    super.key,
    required this.quantity,
    this.borderRadiusValue = 0,
    this.sizeButton = 40.0,
    required this.increaseQuantityFunction,
    required this.decreaseQuantityFunction,
  });

  final int quantity;
  final double borderRadiusValue;
  final double sizeButton;
  final VoidCallback increaseQuantityFunction;
  final VoidCallback decreaseQuantityFunction;

  @override
  State<CartButtonWithQuantity> createState() => _CartButtonWithQuantityState();
}

class _CartButtonWithQuantityState extends State<CartButtonWithQuantity>
    with TickerProviderStateMixin {
  int get _quantity => widget.quantity;

  bool _isShowQuantity = false;
  double get _size => widget.sizeButton;
  double get _radius => widget.borderRadiusValue;

  late AnimationController _animationController;
  late Animation<double> _animation;

  void _updateAnimation() {
    if (_quantity == 0) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  void _increaseQuantity() {
    EasyDebounce.debounce('deboundChangeAnimateion_increaseQuantity',
        const Duration(milliseconds: 200), () {
      _isShowQuantity = true;
      widget.increaseQuantityFunction();
    });
  }

  void _decreaseQuantity() {
    EasyDebounce.debounce('deboundChangeAnimateion_decreaseQuantity',
        const Duration(milliseconds: 200), () {
      if (_quantity == 0) {
        return;
      }
      widget.decreaseQuantityFunction();

      WidgetsBinding.instance.endOfFrame.then((_) {
        if (_quantity <= 0 && _isShowQuantity) {
          _isShowQuantity = false;
          _hideQuantity();
        }
      });
    });
  }

  void _showQuantity() {
    _animationController.forward();
  }

  void _hideQuantity() {
    _animationController.reverse();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _updateAnimation();
  }

  @override
  void didUpdateWidget(covariant CartButtonWithQuantity oldWidget) {
    super.didUpdateWidget(oldWidget);

    _updateAnimation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (_quantity == 0) {
          _showQuantity();
        }
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            margin: const EdgeInsets.all(6),
            height: _size,
            decoration: BoxDecoration(
              color: Color.lerp(
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColorLight,
                _animation.value,
              ),
              border: Border.all(
                color: Color.lerp(
                      Colors.transparent,
                      Theme.of(context).colorScheme.secondary,
                      _animation.value,
                    ) ??
                    Theme.of(context).colorScheme.secondary,
              ),
              borderRadius: BorderRadius.circular(_radius),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.linear,
                    child: _quantity != 0
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(_radius),
                                child: Material(
                                  color: Colors.transparent,
                                  child: SizedBox(
                                    width: _size,
                                    height: _size,
                                    child: IconButton(
                                      onPressed: _decreaseQuantity,
                                      icon: const Icon(Icons.remove),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: SizedBox(
                                  width: 60,
                                  child: Center(
                                    child: Text(
                                      '$_quantity',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
                Flexible(
                  child: Transform.rotate(
                    angle: _animation.value * (pi / 2),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(_radius),
                      child: Material(
                        color: Colors.transparent,
                        child: SizedBox(
                          width: _size,
                          height: _size,
                          child: IconButton(
                            onPressed: _increaseQuantity,
                            icon: const Icon(Icons.add),
                            color: Color.lerp(
                              Colors.white,
                              Theme.of(context).iconTheme.color,
                              _animation.value,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
