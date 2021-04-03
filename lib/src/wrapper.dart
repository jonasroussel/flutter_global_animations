import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'engine.dart';

class GlobalAnimations extends InheritedWidget {
  static GlobalAnimations of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<GlobalAnimations>()!;

  GlobalAnimations(
    this._state, {
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  final _GlobalAnimationsWrapperState _state;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  void spawn(AnimationModel animation) => _state.animations.spawn(animation);
}

class GlobalAnimationsWrapper extends StatefulWidget {
  GlobalAnimationsWrapper({required this.child});

  final Widget child;

  @override
  _GlobalAnimationsWrapperState createState() =>
      _GlobalAnimationsWrapperState();
}

class _GlobalAnimationsWrapperState extends State<GlobalAnimationsWrapper>
    with TickerProviderStateMixin {
  late Animations animations;

  @override
  void initState() {
    super.initState();
    animations = Animations(this);
  }

  @override
  void dispose() {
    animations.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlobalAnimations(
      this,
      child: AnimatedBuilder(
        animation: animations,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.topLeft,
            children: [
              Positioned.fill(child: child!),
              ...animations.render(),
            ],
          );
        },
        child: widget.child,
      ),
    );
  }
}
