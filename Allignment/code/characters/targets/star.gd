extends Enemy

func movement(delta : float):
	
	var pointy : PathFollow2D = get_parent()
	pointy.progress_ratio += 0.25 * delta
