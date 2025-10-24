extends Node

var player_max_health = 50
var player_health = 50
var player_physical_defense = 1
var player_magic_defense = 1
var player_attack_power = 3
var basket = []
var inventory = []
var rng = RandomNumberGenerator.new()
var doing_alchemy = false
var current_level = "Cottage"
var player_pos = Vector2.ZERO
var enemy_unload = null

var sarah = {
	"name": "Sarah",
	"hp": 50,
	"max_hp": 50,
	"physical_defense": 1,
	"magic_defense": 1,
	"attack_power": 10,
}

var allies = [sarah]

var levels = {
	"Cottage": {
		"name": "Cottage",
		"scene": "res://scenes/cottage.tscn",
		"items": ["water"],
		"enemies": ["Slime"],
		"spawns": [Vector2(-16,156)]
	},
	"CottageAttic": {
		"name": "Cottage attic",
		"scene": "res://scenes/cottage_attic.tscn",
		"items": ["water"],
		"enemies": ["Slime"],
		"spawns": [Vector2(100,12)]
	},
	"NearbyForest": {
		"name": "Nearby forest",
		"scene": "res://scenes/nearby_forest.tscn",
		"items": [
			"water",
			"grass"
		],
		"enemies": [
			"Slime",
			"Goblin"
		],
		"spawns": [
			Vector2(576,192),
			Vector2(256,448)
		]
			
	},
	"Village": {
		"name": "Village",
		"scene": "res://scenes/village.tscn",
		"items": ["bone", "water"],
		"enemies": ["Slime"],
		"spawns": [Vector2(-272,48)]
	},
}


var items = {
	"Uni": {
		"sprite": preload("res://sprites/uni.tres"),
		"category": "ingredient",
		"physical_power":0,
		"magic_power":0,
		"healing_power":0,
	},
	"Magic grass": {
		"sprite": preload("res://sprites/magic_grass.tres"),
		"category": "ingredient",
		"physical_power":0,
		"magic_power":0,
		"healing_power":0,
	},
	"Water": {
		"sprite": preload("res://sprites/water.tres"),
		"category": "ingredient",
		"physical_power":0,
		"magic_power":0,
		"healing_power":0,
	},
	"Bomb": {
		"sprite": preload("res://sprites/bomb.tres"),
		"category": "bomb",
		"physical_power":10,
		"magic_power":0,
		"healing_power":0,
	},
	"Magic bomb": {
		"sprite": preload("res://sprites/magic_bomb.tres"),
		"category": "bomb",
		"physical_power": 0,
		"magic_power": 10,
		"healing_power": 0
	},
	"Potion": {
		"sprite": preload("res://sprites/potion.tres"),
		"category": "healing",
		"physical_power":0,
		"magic_power":0,
		"healing_power":10,
	},
	"Gu grenade": {
		"sprite": preload("res://sprites/gu_grenade.tres"),
		"category": "bomb",
		"physical_power": 1,
		"magic_power": 1,
		"healing_power": 0
	},
	"Slime": {
		"sprite": preload("res://sprites/slime.tres"),
		"category": "ingredient",
		"physical_power": 0,
		"magic_power": 0,
		"healing_power": 0
	}
}



var recipes = [
	{
		"name": "Bomb",
		"ingredients": [
			["Uni",3,0],
			["Magic grass",1,0]
		]
	},
	{
		"name": "Magic bomb",
		"ingredients": [
			["Bomb",1,0],
			["Uni",1,0],
			["Magic grass",4,0],
		]
	},
	{
		"name": "Potion",
		"ingredients": [
			["Magic grass",1,0],
			["Water",1,0]
		]
	},
	{
		"name": "Gu grenade",
		"ingredients": [
			["Bomb", 1,0],
			["Uni", 1,0],
			["Slime", 2,0]
		]
	}
]


var enemies = {
	"Slime": {
		"name": "Slime",
		"hp": 5,
		"sprite": preload("res://resources/slime_frames.tres"),
		"attack_power": 5,
		"physical_defense":3,
		"magic_defense":1
	},
	"Goblin": {
		"name": "Goblin",
		"hp": 20,
		"sprite": preload("res://resources/goblin_frames.tres"),
		"attack_power": 10,
		"physical_defense":1,
		"magic_defense":1
	}
}
