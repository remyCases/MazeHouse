extends Area2D

var size: Vector2
var target: Vector2
var direction: Vector2
@export var speed: float = 2.0
@export var angular_speed: float = 0.02
var topSprite: Polygon2D
var bottomSprite: Polygon2D
var topCollider: CollisionPolygon2D
var bottomCollider: CollisionPolygon2D

func _ready():
	size = get_viewport().get_visible_rect().size
	position = Vector2(size.x/2, size.y/2)
	next_point()

	topSprite = get_node("Sprites/TopConeSprite")
	topSprite.polygon = [
		Vector2(0.0, 0.0),
		Vector2(-size.length(), -size.length()),
		Vector2(size.length(), -size.length()),
	]
	bottomSprite = get_node("Sprites/BottomConeSprite")
	bottomSprite.polygon = [
		Vector2(0.0, 0.0),
		Vector2(-size.length(), size.length()),
		Vector2(size.length(), size.length()),
	]
	topCollider = get_node("TopConeCollider")
	topCollider.polygon = [
		Vector2(0.0, 0.0),
		Vector2(-size.length(), size.length()),
		Vector2(size.length(), size.length()),
	]
	bottomCollider = get_node("BottomConeCollider")
	bottomCollider.polygon = [
		Vector2(0.0, 0.0),
		Vector2(-size.length(), -size.length()),
		Vector2(size.length(), -size.length()),
	]

func next_point():
	target = Vector2(
		RandomUtils.rand_int((size.x - 60)) as float + 30.0, 
		RandomUtils.rand_int((size.y - 60)) as float + 30.0
	)
	direction = target - position
	direction = direction.normalized()

func check_proximity():
	return position.distance_to(target) < 0.5 * speed;

func _physics_process(_delta: float):
	if check_proximity():
		next_point();
	else:
		position += direction * speed;
		rotation += angular_speed;
