@tool
extends Control
class_name DialogueBox
## A ready-made dialogue UI: speaker name + typewriter text. Bind a
## DialogueRunner with set_runner() and it handles the rest. Press ui_accept
## (Enter/Space) or click to advance / skip the typewriter.
## (Choice buttons are a PRO feature.)

@export var characters_per_second: float = 40.0

@onready var _panel: Panel = $Panel
@onready var _speaker: Label = $Panel/Speaker
@onready var _text: RichTextLabel = $Panel/Text
@onready var _continue: Label = $Panel/Continue

var _runner: DialogueRunner
var _full_text: String = ""
var _revealed: float = 0.0
var _typing: bool = false


func _ready() -> void:
	visible = false
	_text.bbcode_enabled = false


func set_runner(runner: DialogueRunner) -> void:
	if _runner != null:
		_disconnect(_runner)
	_runner = runner
	if _runner != null:
		_runner.line_shown.connect(_on_line_shown)
		_runner.dialogue_started.connect(_on_started)
		_runner.dialogue_finished.connect(_on_finished)


func _disconnect(runner: DialogueRunner) -> void:
	runner.line_shown.disconnect(_on_line_shown)
	runner.dialogue_started.disconnect(_on_started)
	runner.dialogue_finished.disconnect(_on_finished)


func _on_started() -> void:
	visible = true


func _on_finished() -> void:
	visible = false


func _on_line_shown(speaker: String, text: String) -> void:
	_speaker.text = speaker
	_speaker.visible = not speaker.is_empty()
	_full_text = text
	_text.text = text
	_revealed = 0.0
	_text.visible_characters = 0
	_typing = true
	_continue.visible = false


func _process(delta: float) -> void:
	if not _typing:
		return
	_revealed += characters_per_second * delta
	_text.visible_characters = int(_revealed)
	if _text.visible_characters >= _full_text.length():
		_finish_typing()


func _unhandled_input(event: InputEvent) -> void:
	if not visible or _runner == null or not _runner.is_active():
		return
	var pressed: bool = event.is_action_pressed("ui_accept") or \
		(event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT)
	if not pressed:
		return
	if _typing:
		_finish_typing()
	else:
		_runner.advance()


func _finish_typing() -> void:
	_typing = false
	_text.visible_characters = -1
	_continue.visible = true
