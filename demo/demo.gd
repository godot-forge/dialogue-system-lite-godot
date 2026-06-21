extends Control
## Dialogue System Lite demo. Press the button (or SPACE) to start.
## Click / Enter / Space advances lines and skips the typewriter.

@onready var box: DialogueBox = $DialogueBox
@onready var start_button: Button = $StartButton
@onready var hint: Label = $Hint

var runner: DialogueRunner
var dialogue: Dialogue


func _ready() -> void:
	dialogue = Dialogue.load_file("res://demo/sample.dialogue")
	runner = DialogueRunner.new()
	add_child(runner)
	box.set_runner(runner)
	runner.dialogue_finished.connect(_on_finished)
	start_button.pressed.connect(_start)


func _start() -> void:
	start_button.visible = false
	hint.visible = false
	runner.start(dialogue)


func _on_finished() -> void:
	start_button.visible = true
	hint.visible = true
