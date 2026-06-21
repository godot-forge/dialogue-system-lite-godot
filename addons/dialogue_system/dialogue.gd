@tool
extends Resource
class_name Dialogue
## A parsed linear dialogue. Build one with Dialogue.parse(text), or load a
## .dialogue file with Dialogue.load_file(path).
##
## Text format:
##   # node_id              <- starts a node (first node is the start node)
##   Speaker: Some line.    <- a spoken line ("Speaker" optional)
##   -> next_id             <- jump to another node
##
## A node with `-> id` continues to that node. A node with no `->` ends.
##
## ─────────────────────────────────────────────────────────────────────────
## Dialogue System LITE: linear conversations + typewriter box.
## Dialogue System PRO adds: BRANCHING CHOICES (`* text -> id`) with an
## automatic choice-button UI — same classes, drop-in upgrade:
##   https://godot-forge.itch.io/dialogue-system-godot
## ─────────────────────────────────────────────────────────────────────────

var nodes: Dictionary = {}   # id -> {id, speaker, text, next}
var start_id: String = ""


static func parse(text: String) -> Dialogue:
	var dlg := Dialogue.new()
	var current: Dictionary = {}

	for raw_line in text.split("\n"):
		var line := raw_line.strip_edges()
		if line.is_empty() or line.begins_with("//"):
			continue

		if line.begins_with("#"):
			var id := line.substr(1).strip_edges()
			current = {"id": id, "speaker": "", "text": "", "next": ""}
			dlg.nodes[id] = current
			if dlg.start_id.is_empty():
				dlg.start_id = id
			continue

		if current.is_empty():
			push_warning("Dialogue.parse: content before first '# node_id' was ignored")
			continue

		if line.begins_with("*"):
			push_warning("Dialogue Lite: branching choices ('*') are a PRO feature and were ignored. https://godot-forge.itch.io/dialogue-system-godot")
			continue

		if line.begins_with("->"):
			current["next"] = line.substr(2).strip_edges()
			continue

		# Otherwise: a spoken line, optionally "Speaker: text".
		var parts := line.split(":", true, 1)
		if parts.size() == 2 and not parts[0].contains(" -> "):
			current["speaker"] = parts[0].strip_edges()
			current["text"] = parts[1].strip_edges()
		else:
			current["text"] = line
	return dlg


static func load_file(path: String) -> Dialogue:
	if not FileAccess.file_exists(path):
		push_error("Dialogue.load_file: not found: %s" % path)
		return Dialogue.new()
	var text := FileAccess.get_file_as_string(path)
	return parse(text)


func has_node_id(id: String) -> bool:
	return nodes.has(id)


func get_node_data(id: String) -> Dictionary:
	return nodes.get(id, {})
