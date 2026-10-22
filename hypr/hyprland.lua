-- Dependencies: ghostty, yazi, fuzzel, waybar, hyprpaper, hyprlock, hypridle, hyprshot, 
-- brightnessctl, wireplumber/wpctl, playerctl, spotify-launcher, discord, firefox 
-- and hyprpolkitagent

local terminal = "ghostty"
local fileManager = terminal .. " -e yazi"
local menu = "fuzzel"
local home = os.getenv("HOME") or ""

-- Monitors
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
-- hl.monitor({ output = "HDMI-1", mode = "preferred", position = "auto", scale = 1, transform = 3 })

-- Session autostarted services
hl.on("hyprland.start", function()
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("hyprlock")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("ghostty",          { workspace = "1 silent" })
    hl.exec_cmd("firefox",          { workspace = "2 silent" })
    hl.exec_cmd("spotify-launcher", { workspace = "3 silent" })
    hl.exec_cmd("discord",          { workspace = "3 silent" })
end)

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

hl.config({
    general = {
        gaps_in = 3,
        gaps_out = 5,
        border_size = 3,
        col = {
            active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },
    decoration = {
        rounding = 6,
        rounding_power = 2,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = 0xee1a1a1a,
        },
        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
        },
    },
    animations = { enabled = true },
    dwindle = { preserve_split = true, force_split = 2 },
    master = { new_status = "master" },
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo = false,
    },
    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = { natural_scroll = true },
    },
})

-- Curves and animation timings/styles.
hl.curve("easeOutQuint",   { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear",         { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear",   { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick",          { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "quick" })

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.device({ name = "epic-mouse-v1", sensitivity = -0.5 })

-- Searchable, executable palette
-- The bind definitions are the single source of truth: entries are discovered using `hyprctl -j binds`
-- Their actions are retained here because Hyprland 0.56.x's bind JSON exposes Lua actions only as opaque "__lua" numeric references
_G.command_palette = { actions = {} }
function _G.command_palette.run(description)
    local action = _G.command_palette.actions[description]
    assert(action, "Unknown palette action: " .. tostring(description))
    if type(action) == "function" then
        return action()
    end
    return hl.dispatch(action)
end

local function palette_bind(keys, action, description, flags)
    assert(not _G.command_palette.actions[description], "Duplicate palette description: " .. description)
    flags = flags or {}
    flags.description = description
    hl.bind(keys, action, flags)
    _G.command_palette.actions[description] = action
end

-- Application and window controls
palette_bind("SUPER + RETURN", hl.dsp.exec_cmd(terminal), "Open terminal")
palette_bind("SUPER + E", hl.dsp.exec_cmd(fileManager), "Open file manager (Yazi)")
palette_bind("SUPER + O", hl.dsp.exec_cmd(menu), "Open application launcher")
palette_bind("SUPER + Q", hl.dsp.window.close(), "Close focused window")
palette_bind("SUPER + V", hl.dsp.window.float({ action = "toggle" }), "Toggle floating window")
palette_bind("SUPER + F", hl.dsp.window.fullscreen({ action = "toggle" }), "Toggle fullscreen")
palette_bind("SUPER + P", hl.dsp.window.pseudo(), "Toggle pseudotiling")
palette_bind("SUPER + SHIFT + P", hl.dsp.layout("togglesplit"), "Toggle dwindle split")

-- Preserve the original shortcut and fallback shutdown logic, but update
-- the fallback syntax: 0.56 Lua cannot use `hyprctl dispatch exit`.
-- hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd(
--     "command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"
-- ))

palette_bind("SUPER + X", hl.dsp.exec_cmd("hyprshot -m window -o " .. home .. "/Pictures/Screenshots/"), "Screenshot focused window")
palette_bind("SUPER + SHIFT + X", hl.dsp.exec_cmd("hyprshot -m region -o " .. home .. "/Pictures/Screenshots/"), "Screenshot selected region")

-- Focus / move windows with vim bindings
local dirs = { H = {"left", "l"}, J = {"down", "d"}, K = {"up", "u"}, L = {"right", "r"} }
for _, key in ipairs({ "H", "J", "K", "L" }) do
    local name, direction = dirs[key][1], dirs[key][2]
    palette_bind("SUPER + " .. key, hl.dsp.focus({ direction = direction }), "Focus " .. name)
    palette_bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ direction = direction }), "Move window " .. name)
end

-- Keyboard window resizing (20px increments)
local resize = { H = { x = -20, y = 0 }, J = { x = 0, y =  20 }, K = { x = 0, y = -20 }, L = { x =  20, y = 0 }}
for key, delta in pairs(resize) do
    hl.bind(
        "SUPER + CTRL + " .. key,
        hl.dsp.window.resize({ x = delta.x, y = delta.y, relative = true }),
        { repeating = true, description = "Resize window " .. key })
end

-- Workspace keys 1..9 and 0 (workspace 10), descriptions omitted to keep the palette small
for i = 1, 10 do
    local key = tostring(i % 10)
    hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

palette_bind("SUPER + ALT + H", hl.dsp.workspace.move({ monitor = "l" }), "Move workspace to left monitor")
palette_bind("SUPER + ALT + L", hl.dsp.workspace.move({ monitor = "r" }), "Move workspace to right monitor")
palette_bind("SUPER + S", hl.dsp.workspace.toggle_special("magic"), "Toggle scratchpad")
palette_bind("SUPER + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }), "Move window to scratchpad")

-- Workspace scrolling and mouse stuff (drag/resize)
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Original bindel = locked + repeating; bindl = locked
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Shortcut to add command descriptions via palette_bind() above to surface commands automatically without updating the Python script
-- Also allows for execution of the commands when selecting from the fuzzel menu through callback
hl.bind("SUPER + slash", hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/command-palette.py"),
    { description = "Show command palette" })

-- Window rules
hl.window_rule({
    name = "spotify-workspace-3", match = { class = "spotify" }, workspace = "3",
})
hl.window_rule({
    name = "discord-workspace-3", match = { class = "discord" }, workspace = "3",
})
hl.window_rule({
    name = "suppress-maximize-events", match = { class = ".*" }, suppress_event = "maximize",
})
hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
        class = "^$", title = "^$", xwayland = true,
        float = true, fullscreen = false, pin = false,
    },
    no_focus = true,
})
hl.window_rule({
    name = "move-hyprland-run", match = { class = "hyprland-run" },
    move = "20 monitor_h-120", float = true,
})
