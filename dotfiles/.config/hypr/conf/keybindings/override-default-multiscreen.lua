-- -----------------------------------------------------
-- Key bindings
-- name: "Default Override"
-- -----------------------------------------------------
require("conf.keybindings.override-default")

-- -----------------------------------------------------
-- Key bindings overrides
-- name: "Default Override Multiscreen"
-- -----------------------------------------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier
local HYPRSCRIPTS = "~/.config/hypr/scripts"
local SCRIPTS = "~/.config/ml4w/scripts"
local SETTINGS = "~/.config/ml4w/settings"

-- Prüfe und lade 'split_monitor_workspaces' Einstellungen
if smw == nil then
    --local smw = hl.plugin.split_monitor_workspaces
    smw = hl.plugin.split_monitor_workspaces
end


-- Workspaces
-- Window action with 'split-workspace' plugin for mainMod + [ACTION_KEY]] + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.unbind(mainMod .. " + " .. key)
    hl.bind(mainMod .. " + " .. key, function() return smw.workspace(tostring(key)) end, { description = "Focus workspace " .. key })

    hl.unbind(mainMod .. " + SHIFT + " .. key)
    hl.bind(mainMod .. " + SHIFT + " .. key, function() return smw.move_to_workspace(tostring(key)) end, { description = "Move window to workspace " .. key })

    hl.unbind(mainMod .. " + CTRL + " .. key)
    hl.bind(mainMod .. " + CTRL + " .. key, function() return smw.move_to_workspace_silent(tostring(key)) end, { description = "Move active window silent to workspace " .. key })
end

-- Cycle workspaces on the current monitor.
hl.unbind(mainMod .. " + mouse_down")
hl.bind(mainMod .. " + mouse_down", function() return smw.cycle_workspaces("next") end)
hl.unbind(mainMod .. " + mouse_up")
hl.bind(mainMod .. " + mouse_up", function() return smw.cycle_workspaces("prev") end)

