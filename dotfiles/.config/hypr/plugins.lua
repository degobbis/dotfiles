-- Colors
require("plugin-hyprbar-colors")

-- Hyprland Plugins laden
hl.exec_cmd("hyprpm reload -n")

--
-- Plugin configuration
--

-- Prüfe und lade 'split_monitor_workspaces' Einstellungen
if hl.plugin.split_monitor_workspaces ~= nil then
    smw = hl.plugin.split_monitor_workspaces
    hl.config({
        plugin = {
            split_monitor_workspaces = {
                count                        = 10,
                keep_focused                 = 0,
                enable_notifications         = 0,
                --enable_persistent_workspaces = 1,
                --enable_wrapping              = 1,
                --link_monitors                = 0,
            },
        },
    })
end

-- Prüfe und lade 'hyprbars' Einstellungen
if hl.plugin.hyprbars ~= nil then
    hl.config({
        plugin = {
            hyprbars = {
                -- example config
                bar_color = hyprbar_bg,
                col = {
                  text = hyprbar_title_text,
                },
                bar_height = 30,
                bar_text_size = 18,
                bar_part_of_window = true,
                bar_precedence_over_border = true,
            },
        },
    })

    -- Button zum schließen
--    hl.plugin.hyprbars.add_button({
--        bg_color = "rgb(ff4040)",
--        fg_color = "rgb(ffffff)",
--        size = 20,
--        icon = "󰖭",
--        action = "hyprctl dispatch killactive",
--    })

    -- Button zum maximieren
--    hl.plugin.hyprbars.add_button({
--        bg_color = "rgb(eeee11)",
--        fg_color = "rgb(000000)",
--        size = 20,
--        icon = "",
--        action = "hyprctl dispatch fullscreen 1",
--    })
end
