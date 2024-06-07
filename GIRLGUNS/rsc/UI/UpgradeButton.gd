extends Button
class_name UpgradeButton

const WAVE : Texture2D = preload("res://assets/spel/Wave.png")
const STAR : Texture2D = preload("res://assets/spel/star.png")
const SHARD : Texture2D = preload("res://assets/spel/shard.png")
const BLAZE : Texture2D = preload("res://assets/spel/blaze.png")
const BEAM : Texture2D = preload("res://assets/spel/Beam.png")

const HEART : Texture2D = preload("res://assets/ui/suit_hearts.png")
const ARROW_UP : Texture2D = preload("res://assets/ui/arrowUp.png")
const SWORD : Texture2D = preload("res://assets/ui/icons/sword.png")
const SHIELD : Texture2D = preload("res://assets/ui/icons/shield.png")
const CYCLE : Texture2D = preload("res://assets/ui/icons/return.png")
const EXPAND : Texture2D = preload("res://assets/ui/icons/larger.png")
const FEET : Texture2D = preload("res://assets/ui/icons/kickCircle.png")
const TIME : Texture2D = preload("res://assets/ui/icons/hourglass_top.png")
const CROWN : Texture2D = preload("res://assets/ui/icons/crown_a.png")
const BOOK : Texture2D = preload("res://assets/ui/icons/book_open.png")
const ARROW_C : Texture2D = preload("res://assets/ui/icons/arrow_right_curve.png")
const BOTTLE : Texture2D = preload("res://assets/ui/icons/flask_half.png")
const ARROW_ARROW : Texture2D = preload("res://assets/ui/fastForward.png")
const SWORD_B : Texture2D = preload("res://assets/ui/icons/dice_sword.png")

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
	match upgrade.type:
		Upgrade.upgrade_type.PLAYER:
			update_player_icon(upgrade)
		Upgrade.upgrade_type.EQUIP:
			subicon.texture = BOOK
			update_weapon_icon(upgrade)
		Upgrade.upgrade_type.BLESS:
			subicon.texture = CROWN
			update_weapon_icon(upgrade)
		Upgrade.upgrade_type.WEAPON:
			update_weapon_upgrade(upgrade)
		Upgrade.upgrade_type.FILLER:
			update_filler_icon(upgrade)
	return

func update_player_icon(upgrade : Upgrade):
	match upgrade.player_upgrade:
		Upgrade.player_stats.HEALTH:
			mainicon.texture = HEART
			subicon.texture = ARROW_UP
		Upgrade.player_stats.SPEED:
			mainicon.texture = FEET
			subicon.texture = ARROW_UP
		Upgrade.player_stats.IFRAME:
			mainicon.texture = SHIELD
			subicon.texture = TIME
		Upgrade.player_stats.STAMINA:
			mainicon.texture = SHIELD
			subicon.texture = CYCLE

func update_weapon_icon(upgrade : Upgrade):
	
	match upgrade.blessing:
		Upgrade.bless.ASTER:
			mainicon.texture = STAR
		Upgrade.bless.LYRIS:
			mainicon.texture = BEAM
		Upgrade.bless.OPHELIA:
			mainicon.texture = WAVE
		Upgrade.bless.RUBY:
			mainicon.texture = BLAZE
		Upgrade.bless.VIOLA:
			mainicon.texture = SHARD

func update_weapon_upgrade(upgrade : Upgrade):
	mainicon.texture = Globals.player.weapon_manager.weapons[upgrade.weapon_slot].icon
	match upgrade.weapon_upgrade:
		Upgrade.weapon_stats.DAMAGE:
			subicon.texture = SWORD
		Upgrade.weapon_stats.RELOAD:
			subicon.texture = CYCLE
		Upgrade.weapon_stats.ROF:
			subicon.texture = ARROW_ARROW
		Upgrade.weapon_stats.MAGAZINE:
			subicon.texture = ARROW_UP
		Upgrade.weapon_stats.PIERCE:
			subicon.texture = ARROW_C
		Upgrade.weapon_stats.AOE:
			subicon.texture = EXPAND

func update_filler_icon(upgrade : Upgrade):
	match upgrade.filler_upgrade:
		Upgrade.fillers.HEAL:
			for thing in [mainicon,subicon]:
				thing.texture = HEART
		Upgrade.fillers.DAMAGE:
			mainicon.texture = BOOK
			subicon.texture = SWORD
		Upgrade.fillers.RECHARGE:
			mainicon.texture = BOOK
			subicon.texture = CYCLE
