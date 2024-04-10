extends EnemyBullet


func move(delta : float):
	look_at(Globals.player.global_position)
	super(delta)
