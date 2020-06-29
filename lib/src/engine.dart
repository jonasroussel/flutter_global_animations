import 'dart:math';

import 'package:flutter/widgets.dart';

import 'models.dart';

class Animations extends ChangeNotifier {
  Animations(this._vsync);

  final TickerProvider _vsync;

  List<AnimationModel> _animations = List();

  void spawn(AnimationModel animation) {
    final controller = animation.createController(_vsync);

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animations.remove(animation..dispose());
      }
    });
    controller.addListener(() {
      notifyListeners();
    });

    _animations.add(animation..start());
  }

  List<Widget> render() => _animations.map((anim) => anim.buildEntities()).expand((pair) => pair).toList();

  @override
  void dispose() {
    _animations?.forEach((anim) {
      anim?.dispose();
    });
    super.dispose();
  }
}

abstract class AnimationModel {
  AnimationModel({
    @required this.position,
    @required this.region,
    @required this.duration,
    this.count = 1,
    this.data,
  });

  final Offset position;
  final Size region;
  final Duration duration;
  final int count;
  final dynamic data;

  List<Entity> entities;
  AnimationController controller;
  Random random;

  AnimationController createController(TickerProvider vsync) {
    if (controller != null) return controller;
    return (controller = AnimationController(vsync: vsync, duration: duration));
  }

  Entity createEntity() {
    random = Random();

    final x = random.nextDouble() * region.width;
    final y = random.nextDouble() * region.height;

    return Entity(x: x, y: y);
  }

  void start() {
    entities = List.generate(count, (index) => createEntity());
    controller.forward();
  }

  Iterable<Widget> buildEntities() {
    return entities.map((entity) {
      final pos = getEntityPosition(entity);

      return Positioned(
        left: entity.x + position.dx + pos.dx,
        top: entity.y + position.dy + pos.dy,
        child: IgnorePointer(child: buildEntity(entity)),
      );
    });
  }

  void dispose() {
    controller?.dispose();
    entities?.clear();
  }

  Widget buildEntity(Entity entity);
  Offset getEntityPosition(Entity entity);
}
