-- Add your additional Hyprland configurations here
--
-- This is an additional key binding
--

-- Example for xwayland
hl.config({
    debug = {
        disable_logs = true,
        disable_time = false,
    },

    ecosystem = {
        enforce_permissions = true,
    },

    general = {
        layout = "master",
    },

    master = {
        mfact = 0.6,
        new_on_active = "before",
        new_status = "slave",
    },

    misc = {
        -- This only works with HL v0.53+
        --on_focus_under_fullscreen = 1, -- Defined in misc.lua

        -- Suggestion from Ddubs, to be watched
        disable_hyprland_logo = true,
        --disable_splash_rendering = true, -- Defined in misc.lua

        -- vfr = true
        vrr = 2,
        enable_swallow = false,
        swallow_regex = "^(kitty)$",
        focus_on_activate = false,

        --initial_workspace_tracking = 1 -- Defined in misc.lua
        middle_click_paste = false,
        --allow_session_lock_restore = true, -- Defined in misc.lua

        mouse_move_enables_dpms = true,
        key_press_enables_dpms = true,
        enable_anr_dialog = true,
        anr_missed_pings = 15,
    },

    xwayland = {
        force_zero_scaling = true,
    },

    input = {
        -- Override keyboard (input)
        kb_layout = "de",
        kb_variant = "nodeadkeys",
        kb_model = "pc105",
        kb_options = "shift:breaks_caps",
        kb_rules = "evdev",
        numlock_by_default = true,
        follow_mouse = 1,
        mouse_refocus = false,
        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            -- for desktop
            --natural_scroll = false,

            -- for laptop
            natural_scroll = true,
            scroll_factor = 1.0,
            middle_button_emulation = false,
            clickfinger_behavior = true,
            disable_while_typing = true,
        },
    },
})

hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
hl.permission("/usr/(bin|local/bin)/hyprpicker", "screencopy", "allow")
hl.permission("/usr/(bin|local/bin)/hyprlock", "screencopy", "allow")
hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

-- qt5ct or qt6ct environment variable
--hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
--hl.env("QT_QPA_PLATFORMTHEME", "qt6ct") -- Defined in ml4w.lua

-- SDL version (für Nvidia)
--hl.env("SDL_VIDEODRIVER", "wayland") -- Defined in ml4w.lua

-- Speicherort für Screenshots
hl.env("XDG_SCREENSHOTS_DIR", "$HOME/Bilder/screenshots")
hl.env("_JAVA_AWT_WM_NONREPARENTING", "1")

-- Set the cursor size for xcursor
hl.env("XCURSOR_SIZE", "32")    -- Defined with 24 in ml4w.lua
hl.env("HYPRCURSOR_SIZE", "32") -- Defined with 24 in ml4w.lua

-- Disable appimage launcher by default
hl.env("APPIMAGELAUNCHER_DISABLE", "1")

-- Hyprland Plugins laden
hl.exec_cmd("hyprpm reload -n")

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 32")
    -- Jetbrains IDE Fix for rendering
    hl.exec_cmd("wmname LG3D")
    -- The basic wayland copy/paste mechanisms will now persist even when the source window is closed.
    hl.exec_cmd("wl-clip-persist --clipboard regular")
    -- Start my apps
    hl.exec_cmd("~/.config/ml4w/scripts/guido-autostart.sh")
end)

-- Rambox auf Monitor 0 Workspace 1 (Workspace 1)
hl.window_rule({
    name = "Rambox",
    match = {
        class = "rambox",
    },
    workspace = "1 silent",
})

-- FreeTube auf Monitor 1 Workspace 0 (workspace 20)
hl.window_rule({
    name = "FreeTube",
    match = {
        class = "freetube",
    },
    workspace = "20 silent",
    opacity = "1 override 1 override 1 override",
})

-- SwayNC
hl.layer_rule({
    match = {
        namespace = "swaync-control-center",
    },
    blur = true,
})
hl.layer_rule({
    match = {
        namespace = "swaync-notification-window",
    },
    blur = true,
})

-- Add Tag to override windowrules
hl.window_rule({
    match = {
        class = "(feh|org.gnome.Loupe|dotfiles-floating|io.missioncenter.MissionCenter|nwg-displays)",
    },
    tag = "+gdg-fcp-wh85%",
})
hl.window_rule({
    match = {
        class = "(.*org.pulseaudio.pavucontrol.*)",
    },
    tag = "+gdg-fcp-wh70%",
})
hl.window_rule({
    match = {
        class = "(.*waypaper.*|timeshift-gtk)",
    },
    tag = "+gdg-fcp-w60%-h75%",
})

-- Floating window pinned center at w 6% h 75%
hl.window_rule({
    name = "gdg-float-center-pin-w60%-h75%",
    match = {
        tag = "gdg-fcp-w60%-h75%",
    },
    float = true,
    center = true,
    pin = true,
    size = "(monitor_w*0.60) (monitor_h*0.75)",
})

-- Floating window pinned center at 70% w/h
hl.window_rule({
    name = "gdg-float-center-pin-wh70%",
    match = {
        tag = "gdg-fcp-wh70%",
    },
    float = true,
    center = true,
    pin = true,
    size = "(monitor_w*0.70) (monitor_h*0.70)",
})

-- Floating window pinned center at 85% w/h
hl.window_rule({
    name = "gdg-float-center-pin-wh85%",
    match = {
        tag = "gdg-fcp-wh85%",
    },
    float = true,
    center = true,
    pin = true,
    size = "(monitor_w*0.85) (monitor_h*0.85)",
})

--
-- Plugin configuration
--

-- Prüfe und lade 'split_monitor_workspaces' Einstellungen
if hl.plugin.split_monitor_workspaces ~= nil then
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
                bar_height = 30,
                bar_text_size = 12,
                on_double_click = "hyprctl dispatch fullscreen 1",

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
