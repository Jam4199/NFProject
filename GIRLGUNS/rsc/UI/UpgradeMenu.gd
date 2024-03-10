extends Control
class_name UpgradeMenu

var upgradebuttons : Array[UpgradeButton] = []
@onready var delay : Timer = get_node("Delay")

signal upgrade_selected(upgrade : Upgrade)
signal boop(n : int)

func _ready() -> void:
	Globals.upgrademenu = self
	for n in range(0,4):
		upgradebuttons.append(get_node("Panel/VBoxContainer/UpgradeButton" + str(n)))
		upgradebuttons[n].connect("pressed",Callable(self,"boop" + str(n)))
	close_upgrades()

func open_upgrades(upgrade_selection : Array[Upgrade]):
	for n in range(0,4):
		upgradebuttons[n].update_text(upgrade_selection[n])
		upgradebuttons[n].mouse_filter = Control.MOUSE_FILTER_IGNORE
	visible = true
	delay.start()
	await delay.timeout
	for button in upgradebuttons:
		button.mouse_filter = Control.MOUSE_FILTER_STOP
	var booped : int = await self.boop
	emit_signal("upgrade_selected",upgrade_selection[booped])
	close_upgrades()
	return

func close_upgrades():
	for upgrade in upgradebuttons:
		upgrade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	visible = false

func boop0():
	emit_signal("boop",0)

func boop1():
	emit_signal("boop",1)

func boop2():
	emit_signal("boop",2)

func boop3():
	emit_signal("boop",3)
