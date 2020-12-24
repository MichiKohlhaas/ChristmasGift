extends Control

enum {
	RUN,
	JUMP,
	BACK_JUMP,
	RUN_SHOOT,
	CLIMB,
	GNU,
	MAGE,
	SHADOW,
	SORCERER,
	MONSTER,
}

onready var animated_sprite = $Menu/CentreRow/CenterContainer/Characters
onready var enemy_anim_sprite = $Menu/CentreRow/CenterContainer/Enemy

func _ready():
	for button in $Menu/CentreRow/Buttons.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.target_scene])
		

func pick_random_animation():
	var list = [RUN, JUMP, BACK_JUMP, RUN_SHOOT, CLIMB]
	list.shuffle()
	var animation = list.pop_front()
	if animation == RUN:
		animated_sprite.play("run")
	if animation == JUMP:
		animated_sprite.play("jump")
	if animation == BACK_JUMP:
		animated_sprite.play("back_jump")
	if animation == RUN_SHOOT:
		animated_sprite.play("run_shoot")
	if animation == CLIMB:
		animated_sprite.play("climb")

func pick_random_enemy_animation():
	var list = [GNU, MAGE, SHADOW, SORCERER, MONSTER]
	list.shuffle()
	var animation = list.pop_front()
	if animation == GNU:
		enemy_anim_sprite.play("gnu")
	if animation == MAGE:
		enemy_anim_sprite.play("mage_super")
	if animation == SHADOW:
		enemy_anim_sprite.play("shadow")
	if animation == SORCERER:
		enemy_anim_sprite.play("sorcerer")
	if animation == MONSTER:
		enemy_anim_sprite.play("monster")

func _on_Characters_animation_finished():
	pick_random_animation()


func _on_Enemy_animation_finished():
	pick_random_enemy_animation()

func _on_Button_pressed(target_scene):
	get_tree().change_scene(target_scene)
