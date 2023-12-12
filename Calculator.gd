extends Control

const types = preload("res://Types.gd").types
@onready var matchups = preload("res://Matchups.gd").new()

@onready var fire_label = preload("res://Labels/FireLabel.tscn")
@onready var ice_label = preload("res://Labels/IceLabel.tscn")
@onready var flora_label = preload("res://Labels/FloraLabel.tscn")
@onready var earth_label = preload("res://Labels/EarthLabel.tscn")
@onready var electric_label = preload("res://Labels/ElectricLabel.tscn")
@onready var water_label = preload("res://Labels/WaterLabel.tscn")
@onready var metal_label = preload("res://Labels/MetalLabel.tscn")
@onready var wind_label = preload("res://Labels/WindLabel.tscn")
@onready var textile_label = preload("res://Labels/TextileLabel.tscn")
@onready var polymer_label = preload("res://Labels/PolymerLabel.tscn")
@onready var light_label = preload("res://Labels/LightLabel.tscn")
@onready var dark_label = preload("res://Labels/DarkLabel.tscn")
@onready var mind_label = preload("res://Labels/MindLabel.tscn")

@onready var labels = {
	"FIRE": fire_label,
	"ICE": ice_label,
	"FLORA": flora_label,
	"EARTH": earth_label,
	"ELECTRIC": electric_label,
	"WATER": water_label,
	"METAL": metal_label,
	"WIND": wind_label,
	"TEXTILE": textile_label,
	"POLYMER": polymer_label,
	"LIGHT": light_label,
	"DARK": dark_label,
	"MIND": mind_label
}

@onready var type_button_1 = $"Selectors/TypeButton1/"
@onready var type_button_2 = $"Selectors/TypeButton2/"

@onready var quarter_effective_box = $TypeListingBox/QuarterEffective/Types
@onready var half_effective_box = $TypeListingBox/HalfEffective/Types
@onready var neutrally_effective_box = $TypeListingBox/NeutrallyEffective/Types
@onready var double_effective_box = $TypeListingBox/DoubleEffective/Types
@onready var quadruple_effective_box = $TypeListingBox/QuadrupleEffective/Types

@onready var boxes = {
	0.25: quarter_effective_box, 
	0.5: half_effective_box, 
	1.0: neutrally_effective_box, 
	2.0: double_effective_box, 
	4.0: quadruple_effective_box}

var current_matchups := {}

func _ready():
	run_program()

func run_program():
	clear_boxes()
	calculate()
	display_matchups()
	hide_unused_boxes()

func clear_boxes():
	for box in boxes:
		for child in boxes[box].get_children():
			child.visible = false
			child.queue_free()
		boxes[box].get_parent().visible = true

func calculate():
	for type in types:
		var result = calculate_defense(types[type], type_button_1.selected, type_button_2.selected)
		current_matchups[type] = result

func calculate_defense(attacking_type: int, defending_type_1: int, defending_type_2: int) -> float:
	var matchup_1 = matchups.get_matchup(attacking_type, defending_type_1)
	var matchup_2 = matchups.get_matchup(attacking_type, defending_type_2)
	if defending_type_1 == defending_type_2:
		return matchup_1
	var result = matchup_1 * matchup_2
	result = snapped(result, 0.25)
	return result

func display_matchups():
	for type in types:
		if type != "NONE":
			var value = current_matchups.get(type)
			boxes[value].add_child(labels[type].instantiate())

func hide_unused_boxes():
	for box in boxes:
		var box_empty = true
		for child in boxes[box].get_children():
			if child.visible:
				box_empty = false
		if box_empty:
			boxes[box].get_parent().visible = false

func _on_TypeButton1_item_selected(_index):
	run_program()

func _on_TypeButton2_item_selected(_index):
	run_program()
