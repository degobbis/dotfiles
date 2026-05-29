hl.monitor({
    output = "",
    mode = "1920x1080@60.0",
    position = "auto",
    scale = 1
})
hl.bind("ALT + Q", hl.dsp.window.close())
hl.config({
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
    },
    animations  = {
        enabled = false,
    },
    xwayland = {
        force_zero_scaling = true,
    },
    input = {
        kb_layout = "de",
        kb_variant = "nodeadkeys",
        kb_model = "pc105",
        kb_options = "shift:breaks_caps",
        kb_rules = "evdev",
        numlock_by_default = true,
        follow_mouse = 1,
        mouse_refocus = false,

        touchpad = {
            -- for desktop
            --natural_scroll = false,

            -- for laptop
            natural_scroll = true,
            middle_button_emulation = false,
            clickfinger_behavior = true,
            disable_while_typing = true,
        },
        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.
    },
})
hl.on("hyprland.start", function()
    hl.exec_cmd("nwg-hello; hyprctl dispatch exit")
end)
