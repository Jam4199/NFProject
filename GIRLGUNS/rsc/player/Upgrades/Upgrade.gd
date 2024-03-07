extends Resource
class_name Upgrade

@export var ui_name : String
@export var ui_description : String
@export var type : upgrade_type = 0
@export var player_upgrade : player_stats
@export var weapon_upgrade : weapon_stats
@export var blessing : bless


enum upgrade_type{PLAYER,WEAPON,BLESS}
enum player_stats{HEALTH,SPEED,IFRAME,STAMINA}
enum weapon_stats{DAMAGE,RELOAD,ROF,MAGAZINE,PIERCE,AOE}
enum bless{ASTER,LYRIS,OPHELIA,RUBY,VIOLA}
