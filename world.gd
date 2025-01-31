extends Node
@export var enemy_base: PackedScene
@export var hardenemy_base: PackedScene
@export var enemy: PackedScene
@export var boss_scene: PackedScene
var i = 0
var playing = false
var hardsection = ["Marker2D", "Marker2D2", "Marker2D3", "Marker2D4", "Marker2D5", "Marker2D19", "Marker2D20", "Marker2D6", "Marker2D7", "Marker2D8", "Marker2D9"]
func _ready():
	for spawnpoint in get_tree().get_nodes_in_group("markers"):
		if spawnpoint.get_parent() == $Hard:
				Global.spawncount = 4
				var h = hardenemy_base.instantiate()
				add_child(h)
				h.position = spawnpoint.position

		elif spawnpoint.get_parent() == $SpawnLocations:
			Global.spawncount = -1
			var z = enemy_base.instantiate()
			add_child(z)
			z.position = spawnpoint.position
	
func _process(delta):
	$GUI/Health.value = Global.health
	$GUI/Score.text = ("Score: " + str(Global.score))
	if playing == true:
		$Area2D/Path2D/PathFollow2D.progress_ratio += .005
		print($Area2D/Path2D/PathFollow2D.progress_ratio)
		if $Area2D/Path2D/PathFollow2D.progress_ratio == 1:
			playing = false
	


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		$Area2D.visible = true
		$Player.queue_free()
		$Area2D/Path2D/PathFollow2D/Sprite2D/Camera2D.visible = true
		playing = true


