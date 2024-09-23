extends TileMapLayer

@onready var player = $Node2D

var t: Tween

var astar: AStarGrid2D
var moving: bool = false

func _ready():
	astar = AStarGrid2D.new()
	astar.cell_shape = AStarGrid2D.CELL_SHAPE_ISOMETRIC_DOWN
	astar.region = get_used_rect()
	astar.cell_size = tile_set.tile_size
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.update()
	for i in get_used_cells():
		if get_cell_tile_data(i).get_custom_data("blocked") == true:
			astar.set_point_solid(i)
	player.position = map_to_local(Vector2i(0,0))

func _unhandled_input(event):
	if Input.is_action_just_pressed("click") and not moving:
		var pos = local_to_map(get_local_mouse_position())
		travel_path(pos)

func travel_path(pos):
	player.walking = true
	if not astar.is_in_boundsv(pos):
		return
	var path = astar.get_id_path(local_to_map(player.position), pos)
	for point in path:
		var dir = player.position.direction_to(map_to_local(point))
		if dir == Vector2.ZERO:
			continue
		player.direction = player.position.direction_to(map_to_local(point))
		move_player(point)
		await t.finished
	
	
	player.walking = false
	

func move_player(tile: Vector2i):
	t = get_tree().create_tween()
	t.tween_property(player, "position", map_to_local(tile), 0.5)
	
