# Dialogue System Lite — linear dialogue for Godot 4 (free)

Write conversations as plain text and get a typewriter dialogue box out of the
box. No node graphs, no spreadsheets.

```
# start
Old Merchant: Ahh, a traveler!
-> wares

# wares
Old Merchant: Care to see my wares?
-> bye

# bye
Old Merchant: Safe travels.
```

```gdscript
var dialogue := Dialogue.load_file("res://dialogue/merchant.dialogue")
var runner := DialogueRunner.new()
add_child(runner)
$DialogueBox.set_runner(runner)   # DialogueBox is the included UI scene
runner.start(dialogue)
```

Click / Enter / Space advances lines and skips the typewriter. Run the included
demo (`demo/demo.tscn`).

## Install
1. Copy `addons/dialogue_system` into your project.
2. Enable **Dialogue System Lite** in *Project → Project Settings → Plugins*.

Registers three classes: `Dialogue`, `DialogueRunner`, `DialogueBox`.

## Lite vs PRO

| Feature | Lite (free) | **PRO** |
|---|:---:|:---:|
| Plain-text dialogue format | ✅ | ✅ |
| Typewriter box + click-to-skip | ✅ | ✅ |
| Speaker names | ✅ | ✅ |
| Linear flow (`-> next`) | ✅ | ✅ |
| **Branching choices (`* text -> id`)** | — | ✅ |
| **Automatic choice-button UI** | — | ✅ |
| **`choices_shown` / `choose()` API** | — | ✅ |

Same classes, drop-in upgrade. **Get Dialogue System PRO:**
👉 https://godot-forge.itch.io/dialogue-system-godot

## License
MIT — free for commercial and personal projects. See `LICENSE.txt`.

Made by **GodotForge** · more Godot tools: https://godot-forge.itch.io
