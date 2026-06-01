-- Add your Hyprland permission configurations here
--
-- You need 'hyprland-guiutils' installed to use ist
-- See: https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/

-- Global permission
hl.config({
    ecosystem = {
        enforce_permissions = true,
    },
})

-- Allow use without prompting for sudo permissions
hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
hl.permission("/usr/(bin|local/bin)/hyprpicker", "screencopy", "allow")
hl.permission("/usr/(bin|local/bin)/hyprlock", "screencopy", "allow")
hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")
