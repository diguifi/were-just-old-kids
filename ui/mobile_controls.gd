extends Control
## On-screen touch controls for mobile (native + mobile Web). Hidden on desktop.
## Joystick visual size scales with the viewport (~18% of the longer screen edge).

@export var force_show_in_editor: bool = false
## Diameter of each VirtualJoystick as a fraction of the longer viewport edge (~18% of screen).
@export_range(0.1, 0.4, 0.01) var joystick_screen_ratio: float = 0.18
## Jump button diameter as a fraction of the longer viewport edge.
@export_range(0.06, 0.25, 0.01) var jump_screen_ratio: float = 0.12
## Edge inset as a fraction of the shorter viewport edge.
@export_range(0.0, 0.08, 0.005) var edge_margin_ratio: float = 0.025
## Tip diameter relative to the joystick diameter.
@export_range(0.3, 0.7, 0.05) var tip_to_joystick_ratio: float = 0.5
## Grab region multiplier over the visual joystick (Dynamic mode needs room to grab).
@export_range(1.0, 1.5, 0.05) var grab_region_ratio: float = 1.2

@onready var move_joystick: VirtualJoystick = $MoveJoystick
@onready var look_joystick: VirtualJoystick = $LookJoystick
@onready var jump_button: BaseButton = $JumpButton

var _jump_held: bool = false


func _ready() -> void:
	if not _should_show():
		hide()
		process_mode = Node.PROCESS_MODE_DISABLED
		return

	show()
	_apply_safe_area()
	_apply_level_layout()
	# Viewport size can lag one frame after entering the tree (esp. Web).
	call_deferred("_apply_responsive_layout")
	get_viewport().size_changed.connect(_on_viewport_size_changed)

	jump_button.button_down.connect(_on_jump_down)
	jump_button.button_up.connect(_on_jump_up)
	# Release jump if the control is hidden mid-press (scene change, etc.)
	visibility_changed.connect(_on_visibility_changed)


func _should_show() -> bool:
	if force_show_in_editor and OS.has_feature("editor"):
		return true
	return _is_mobile()


func _is_mobile() -> bool:
	if OS.has_feature("mobile") or OS.has_feature("android") or OS.has_feature("ios"):
		return true
	# Primary distribution is Web — phones need these tags
	if OS.has_feature("web_android") or OS.has_feature("web_ios"):
		return true
	return false


func _on_viewport_size_changed() -> void:
	_apply_safe_area()
	_apply_responsive_layout()


func _apply_level_layout() -> void:
	var character := _find_character()
	if character and character.immobile:
		move_joystick.visible = false
	else:
		move_joystick.visible = true


func _find_character() -> Node:
	var node: Node = get_parent()
	while node:
		if "immobile" in node:
			return node
		node = node.get_parent()
	return null


func _apply_safe_area() -> void:
	var safe := DisplayServer.get_display_safe_area()
	var window_size := DisplayServer.window_get_size()
	if window_size.x <= 0 or window_size.y <= 0:
		return
	# Pad root so sticks clear notches / home indicators
	offset_left = float(safe.position.x)
	offset_top = float(safe.position.y)
	offset_right = float(safe.end.x - window_size.x)
	offset_bottom = float(safe.end.y - window_size.y)


func _apply_responsive_layout() -> void:
	var viewport_size := get_viewport().get_visible_rect().size
	if viewport_size.x <= 0.0 or viewport_size.y <= 0.0:
		return

	# Longer edge ≈ "screen size" for the size ratio; clamp so sticks still fit on short edge.
	var short_side := minf(viewport_size.x, viewport_size.y)
	var long_side := maxf(viewport_size.x, viewport_size.y)
	var joy_size := long_side * joystick_screen_ratio
	joy_size = clampf(joy_size, short_side * 0.18, short_side * 0.48)
	var tip_size := joy_size * tip_to_joystick_ratio
	var region := joy_size * grab_region_ratio
	var margin := short_side * edge_margin_ratio
	var jump_size := long_side * jump_screen_ratio
	jump_size = clampf(jump_size, short_side * 0.1, short_side * 0.28)

	for stick in [move_joystick, look_joystick]:
		stick.joystick_size = joy_size
		stick.tip_size = tip_size
		_set_style_corners(stick.get_theme_stylebox("normal_joystick") as StyleBoxFlat, joy_size * 0.5)
		_set_style_corners(stick.get_theme_stylebox("pressed_joystick") as StyleBoxFlat, joy_size * 0.5)
		_set_style_corners(stick.get_theme_stylebox("normal_tip") as StyleBoxFlat, tip_size * 0.5)
		_set_style_corners(stick.get_theme_stylebox("pressed_tip") as StyleBoxFlat, tip_size * 0.5)

	# Move stick — bottom-left grab region
	move_joystick.offset_left = margin
	move_joystick.offset_top = -margin - region
	move_joystick.offset_right = margin + region
	move_joystick.offset_bottom = -margin

	# Look stick — bottom-right grab region
	look_joystick.offset_left = -margin - region
	look_joystick.offset_top = -margin - region
	look_joystick.offset_right = -margin
	look_joystick.offset_bottom = -margin

	# Jump — above look stick, horizontally centered on it
	var look_center_from_right := margin + region * 0.5
	jump_button.offset_right = -(look_center_from_right - jump_size * 0.5)
	jump_button.offset_left = jump_button.offset_right - jump_size
	jump_button.offset_bottom = -margin - region - margin * 0.5
	jump_button.offset_top = jump_button.offset_bottom - jump_size

	jump_button.add_theme_font_size_override("font_size", int(jump_size * 0.35))
	_set_style_corners(jump_button.get_theme_stylebox("normal") as StyleBoxFlat, jump_size * 0.5)
	_set_style_corners(jump_button.get_theme_stylebox("pressed") as StyleBoxFlat, jump_size * 0.5)
	_set_style_corners(jump_button.get_theme_stylebox("hover") as StyleBoxFlat, jump_size * 0.5)
	_set_style_corners(jump_button.get_theme_stylebox("disabled") as StyleBoxFlat, jump_size * 0.5)


func _set_style_corners(style: StyleBoxFlat, radius: float) -> void:
	if style == null:
		return
	var r := int(round(radius))
	style.corner_radius_top_left = r
	style.corner_radius_top_right = r
	style.corner_radius_bottom_right = r
	style.corner_radius_bottom_left = r


func _on_jump_down() -> void:
	if not Input.is_action_pressed("ui_accept"):
		Input.action_press("ui_accept")
	_jump_held = true


func _on_jump_up() -> void:
	_release_jump()


func _on_visibility_changed() -> void:
	if not visible:
		_release_jump()


func _release_jump() -> void:
	if _jump_held:
		Input.action_release("ui_accept")
		_jump_held = false


func _exit_tree() -> void:
	_release_jump()
