-- -----------------------------------------------------
-- Key bindings
-- name: "Default"
-- -----------------------------------------------------
require("conf.keybindings.default")

-- -----------------------------------------------------
-- Key bindings overrides
-- name: "Override Default"
-- -----------------------------------------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier
local HYPRSCRIPTS = "~/.config/hypr/scripts"
local SCRIPTS = "~/.config/ml4w/scripts"
local SETTINGS = "~/.config/ml4w/settings"

-- Applications
hl.unbind(mainMod .. " + B")
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(SETTINGS .. "/browser.sh"), { description = "Open the default browser" })

hl.unbind(mainMod .. " + V")
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("gtk-launch codium.desktop"), { description = "Open VSCodium" })

hl.unbind(mainMod .. " + G")
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd(SETTINGS .. "/editor.sh"), { description = "Open the default editor" })

hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("brave --app=https://chat.openai.com"), { description = "Open OpenAI" })
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("missioncenter"), { description = "Open Mission Centerr" })
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("chromium"), { description = "Open chromium" })

hl.unbind(mainMod .. " + CTRL + P")
hl.bind(mainMod .. " + CTRL + P", hl.dsp.exec_cmd("hyprpicker -a"), { description = "Open colorpicker" })

-- Windows
hl.unbind(mainMod .. " + SHIFT + Q")
hl.bind(mainMod .. " + ALT + Q", hl.dsp.exec_cmd("hyprctl activewindow | grep pid | tr -d 'pid:' | xargs kill"), { description = "Quit active window and all open instances" })
-- hl.bind(mainMod .. " + CTRL + Q", hl.dsp.exec_cmd("~/.config/ml4w/scripts/ml4w-wlogout"), { description = "Start wlogout" })
hl.bind(mainMod .. " + CTRL + Q", hl.dsp.exec_cmd("qs ipc call power toggle"), { description = "Start Power Menu" })


-- Actions
hl.unbind(mainMod .. " + CTRL + R")
hl.bind(mainMod .. " + ALT + R", hl.dsp.exec_cmd("hyprctl reload"), { description = "Reload hyprland config" })

hl.unbind(mainMod .. " + PRINT")
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd(HYPRSCRIPTS .. "/screenshot.sh --instant-area"), { description = "Take an instant area screenshot" })

hl.unbind(mainMod .. " + ALT + F")
hl.bind(mainMod .. " + SHIFT + PRINT", hl.dsp.exec_cmd(HYPRSCRIPTS .. "/screenshot.sh  --instant"), { description = "Take an instant full-screen screenshot" })

hl.unbind(mainMod .. " + ALT + S")
hl.bind(mainMod .. " + ALT + PRINT", hl.dsp.exec_cmd(HYPRSCRIPTS .. "/screenshot.sh"), { description = "Take a screenshot" })

hl.unbind(mainMod .. " + CTRL + RETURN")
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(HYPRSCRIPTS .. "/launcher.sh"), { description = "Open application launcher" })

hl.unbind(mainMod .. " + CTRL + B")
hl.bind(mainMod .. " + CTRL + B", hl.dsp.exec_cmd("~/.config/waybar/launch.sh"), { description = "Reload waybar" })

hl.unbind(mainMod .. " + SHIFT + B")
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("~/.config/waybar/toggle.sh"), { description = "Toggle waybar (on/off)" })
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd(SCRIPTS .. "/ml4w-cliphist"), { description = "Open clipboard manager" })

hl.bind(mainMod .. " + ALT + U", hl.dsp.exec_cmd(HYPRSCRIPTS .. "/gdg-update-hyprland-plugins.sh"), { description = "Update Hyprland-Plugins" })

hl.unbind(mainMod .. " + CTRL + L")
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("~/.config/ml4w/scripts/ml4w-power -l"), { description = "Lock Screen" })


-- Workspaces
-- hl.unbind(mainMod .. " + CTRL + left")
hl.bind(mainMod .. " + CTRL + left", hl.dsp.window.move({ direction = "left" }), { description = "Move active window to prev monitor" })
-- hl.unbind(mainMod .. " + CTRL + right")
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.move({ direction = "right" }), { description = "Move active window to next monitor" })

-- Move active window silently to a workspace with mainMod + CTRL + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.unbind(mainMod .. " + CTRL + " .. key)
    hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.window.move({ workspace = i, silent = true }), { description = "Move active window silent to workspace " .. i })
end

