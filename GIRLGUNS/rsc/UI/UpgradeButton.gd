extends Button
class_name UpgradeButton

const WAVE : Texture2D = preload("res://assets/spel/Wave.png")
const STAR : Texture2D = preload("res://assets/spel/star.png")
const SHARD : Texture2D = preload("res://assets/spel/shard.png")
const BLAZE : Texture2D = preload("res://assets/spel/blaze.png")
const BEAM : Texture2D = preload("res://assets/spel/Beam.png")

@onready var upgrade_name : RichTextLabel = get_node("%UpgradeName")
@onready var upgrade_desc : RichTextLabel = get_node("%UpgradeDescription")
@onready var rec : RichTextLabel = get_node("%Recommended")
@onready var mainicon : TextureRect = get_node("%Icon")
@onready var subicon : TextureRect = get_node("%SubIcon")

func update_text(upgrade : Upgrade):
	if upgrade == null:
		visible = false
		return
	visible = true
	update_icon(upgrade)
	upgrade_name.text = "[center]" + upgrade.ui_name + "[/center]"
	upgrade_desc.text = "[center]" + upgrade.ui_description + "[/center]"
	if upgrade.recommended:
		rec.visible = true
	else:
		rec.visible = false
	return

func update_icon(upgrade : Upgrade):
	return
