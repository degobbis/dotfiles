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
local smw = hl.plugin.split_monitor_workspaces

-- Workspaces
-- Window action with 'split-workspace' plugin for mainMod + [ACTION_KEY]] + [0-9]
for i = 1, smw.get_amount_of_workspaces() do
    local key = i % 10 -- 10 maps to key 0
    hl.unbind(mainMod .. " + " .. key)
    hl.bind(mainMod .. " + " .. key, smw.workspace(i), { description = "Focus workspace " .. i })

    hl.unbind(mainMod .. " + SHIFT + " .. key)
    hl.bind(mainMod .. " + SHIFT + " .. key, smw.move_to_workspace(i), { description = "Move window to workspace " .. i })

    hl.unbind(mainMod .. " + CTRL + " .. key)
    hl.bind(mainMod .. " + CTRL + " .. key, smw.move_to_workspace_silent(i), { description = "Move active window silent to workspace " .. i })
end


-- Cycle workspaces on the current monitor.
hl.unbind(mainMod .. " + mouse_down")
hl.bind(mainMod .. " + mouse_down", smw.cycle_workspaces("next"))
hl.unbind(mainMod .. " + mouse_up")
hl.bind(mainMod .. " + mouse_up", smw.cycle_workspaces("prev"))
