class Entity {
  double x;
  double y;
  double dx;
  double dy;
  dynamic custom;

  Entity({
    this.x = 0.0,
    this.y = 0.0,
    this.dx = 0.0,
    this.dy = 0.0,
    this.custom,
  });

  factory Entity.from(Entity entity) {
    return Entity(
      x: entity.x,
      y: entity.y,
      dx: entity.dx,
      dy: entity.dy,
      custom: entity.custom,
    );
  }
}
