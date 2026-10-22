#!/usr/bin/env python3
"""Fuzzel picker backed by Hyprland's live described keybindings (0.56.x).

Fuzzel returns a 0-based index; executing a selected Lua bind by its opaque
hyprctl bind ID is unsupported, so we invoke our own named Lua action registry.
"""

import json
import subprocess
import sys

MODIFIERS = ((64, "SUPER"), (1, "SHIFT"), (4, "CTRL"), (8, "ALT"))


def combo(binding):
    mask = binding.get("modmask", 0)
    parts = [label for bit, label in MODIFIERS if mask & bit]
    key = str(binding.get("key", ""))
    if key:
        parts.append(key.upper())
    return " + ".join(parts)


def entries(binds):
    # The palette launcher itself has a description but no registered action.
    # Only described, non-mouse binds are candidates.
    return [
        binding for binding in binds
        if binding.get("description")
        and binding["description"] != "Show command palette"
        and binding.get("key")
        and not binding.get("mouse")
        and not binding.get("submap")
    ]


def run():
    try:
        result = subprocess.run(
            ["hyprctl", "-j", "binds"], capture_output=True, text=True, check=True
        )
        bindings = entries(json.loads(result.stdout))
    except (subprocess.CalledProcessError, json.JSONDecodeError) as exc:
        print(f"Cannot read Hyprland bindings: {exc}", file=sys.stderr)
        return 1

    if not bindings:
        print("No described bindings available", file=sys.stderr)
        return 0

    labels = [f"{combo(b):<28}  {b['description']}" for b in bindings]
    chosen = subprocess.run(
        ["fuzzel", "--dmenu", "--index", "--width=68", "--lines=14", "--prompt=Commands > "],
        input="\n".join(labels) + "\n", text=True, capture_output=True
    )
    if chosen.returncode != 0:  # Escape / cancelled
        return 0
    try:
        binding = bindings[int(chosen.stdout.strip())]
    except (ValueError, IndexError):
        return 1

    # Use a Lua-safe quoted string; never interpret Fuzzel's free-form input.
    # Description is the stable identifier shared with palette_bind() in Lua.
    description = json.dumps(binding["description"], ensure_ascii=True)
    expression = f"command_palette.run({description})"
    completed = subprocess.run(["hyprctl", "eval", expression], capture_output=True, text=True)
    if completed.returncode != 0 or completed.stdout.lower().startswith("error"):
        print(completed.stderr or completed.stdout, file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(run())
