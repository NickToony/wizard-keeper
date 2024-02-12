extends Area3D

var speed = 5
var damage = 50
var velocity = Vector3.ZERO

func _ready():
	#connect("body_entered", on_body_entered)
	body_entered.connect(_on_body_entered)
	update()

func _physics_process(delta):
	position += velocity * delta
	
func _on_body_entered(body: Node3D):
	if (body.is_in_group('enemies')):
		body.health -= damage
	queue_free()

func update():
	velocity = global_transform.basis.z.normalized() * speed
	position += velocity * 0.1
