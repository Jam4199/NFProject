extends Resource
class_name Upgrade

@export var ui_name : String
@export var ui_description : String
@export var type : upgrade_type = upgrade_type.PLAYER
@export var player_upgrade : player_stats
@export var weapon_upgrade : weapon_stats
@export var filler_upgrade : fillers
@export var blessing : bless

var weapon_slot : int = 0
var recommended : bool = false

enum upgrade_type{PLAYER,WEAPON,EQUIP,BLESS,FILLER}
enum player_stats{HEALTH,SPEED,IFRAME,STAMINA}
enum weapon_stats{DAMAGE,RELOAD,ROF,MAGAZINE,PIERCE,AOE}
enum bless{ASTER,LYRIS,OPHELIA,RUBY,VIOLA}
enum fillers{HEAL,DAMAGE,RECHARGE}
