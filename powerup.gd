extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func collect(body):
    $PickupSound.play()
    hide()
    set_process(false)
    yield($PickupSound, "finished")
    queue_free()

func move(d):
    position += d/75
