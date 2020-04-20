extends Node2D

var down = false

func _ready():
    pass
    
func _process(delta):
    if down:
        position.y += delta*1200
    elif position.y > 0:
        position.y -= delta*1200

func hideCover(body):
    down = true
    #() # Replace with function body.
