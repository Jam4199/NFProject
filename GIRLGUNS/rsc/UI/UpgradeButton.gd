extends Button
class_name UpgradeButton

@onready var upgrade_name : RichTextLabel = get_node("UpgradeName")
@onready var upgrade_desc : RichTextLabel = get_node("UpgradeDescription")


func update_text(upgrade : Upgrade):
	if upgrade == null:
		visible = false
		return
	visible = true
	upgrade_name.text = "[center]" + upgrade.ui_name + "[/center]"
	upgrade_desc.text = "[center]" + upgrade.ui_description + "[/center]"
	return
