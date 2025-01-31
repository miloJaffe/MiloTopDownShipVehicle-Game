extends RigidBody2D
@export var enemies: PackedScene

var spawnCount = Global.spawncount
# Called when the node enters the scene tree for the first time.
func _ready():
		pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if spawnCount >= 0:
		$Timer.one_shot = false
	else:
		$Timer.one_shot = true
	

func _on_timer_timeout():
	randomize()
	var y = enemies.instantiate()
	y.position.x = self.position.x + lerp(-150, 150, randf())
	y.position.y = self.position.y + lerp(-150, 150, randf())


	get_parent().add_child(y)
	y.add_to_group("enemy")
	spawnCount -= 1
	print(spawnCount)


