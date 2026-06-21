@tool
extends Node
class_name DialogueRunner
## Drives a linear Dialogue. Connect a DialogueBox (or your own UI) to its
## signals. (Branching choices are a PRO feature.)

signal line_shown(speaker: String, text: String)
signal dialogue_started
signal dialogue_finished

var dialogue: Dialogue
var _current_id: String = ""
var _active: bool = false


func is_active() -> bool:
	return _active


func start(dlg: Dialogue, from_id: String = "") -> void:
	dialogue = dlg
	if dialogue == null or dialogue.nodes.is_empty():
		push_error("DialogueRunner: empty or null dialogue")
		return
	_current_id = from_id if not from_id.is_empty() else dialogue.start_id
	_active = true
	dialogue_started.emit()
	_emit_current()


## Advance to the next line. Ends the dialogue if there is no `-> next`.
func advance() -> void:
	if not _active:
		return
	var node := dialogue.get_node_data(_current_id)
	var next: String = node.get("next", "")
	if next.is_empty():
		_finish()
	else:
		_goto(next)


func stop() -> void:
	if _active:
		_finish()


func _goto(id: String) -> void:
	if not dialogue.has_node_id(id):
		push_error("DialogueRunner: jump to unknown node '%s'" % id)
		_finish()
		return
	_current_id = id
	_emit_current()


func _emit_current() -> void:
	var node := dialogue.get_node_data(_current_id)
	line_shown.emit(node.get("speaker", ""), node.get("text", ""))


func _finish() -> void:
	_active = false
	_current_id = ""
	dialogue_finished.emit()
